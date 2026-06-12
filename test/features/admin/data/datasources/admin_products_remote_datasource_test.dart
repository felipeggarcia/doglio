import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:doglio/core/errors/exceptions.dart';
import 'package:doglio/core/storage/secure_storage.dart';
import 'package:doglio/features/admin/data/datasources/admin_products_remote_datasource.dart';
import 'package:doglio/features/admin/data/models/admin_product_model.dart';
import 'package:doglio/features/admin/domain/entities/admin_product_filters.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockSecureStorage extends Mock implements SecureStorage {}

Map<String, dynamic> _productJson({String id = 'p1'}) => {
      'id': id,
      'name': 'Ração',
      'description': 'Desc',
      'price': '89.90',
      'is_active': true,
      'stock_quantity': 5,
    };

const _model = AdminProductModel(
  id: 'p1',
  name: 'Ração',
  description: 'Desc',
  price: '89.90',
  isHighlighted: false,
  isActive: true,
  inStock: true,
  stockQuantity: 5,
);

void main() {
  late MockHttpClient httpClient;
  late MockSecureStorage storage;
  late AdminProductsRemoteDatasource datasource;
  late File tempImage;

  setUpAll(() {
    registerFallbackValue(Uri.parse('http://x'));
    registerFallbackValue(http.Request('GET', Uri.parse('http://x')));
    tempImage = File(
        '${Directory.systemTemp.path}/doglio_test_image_${DateTime.now().microsecondsSinceEpoch}.jpg');
    tempImage.writeAsBytesSync(List.filled(16, 0));
  });

  tearDownAll(() {
    if (tempImage.existsSync()) tempImage.deleteSync();
  });

  setUp(() {
    httpClient = MockHttpClient();
    storage = MockSecureStorage();
    datasource = AdminProductsRemoteDatasource(
      httpClient: httpClient,
      secureStorage: storage,
    );
    when(() => storage.getToken()).thenAnswer((_) async => 'token');
  });

  group('getProducts', () {
    test('monta query com todos os filtros e parseia data + meta', () async {
      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'data': [_productJson(), _productJson(id: 'p2')],
            'meta': {'current_page': 2, 'last_page': 3, 'total': 42},
          }),
          200,
        ),
      );

      final filters = AdminProductFilters(
        search: 'ração',
        isActive: true,
        isHighlighted: true,
        outOfStock: false,
        categoryIds: const ['cat1', 'cat2'],
        priceMin: '10.00',
        priceMax: '99.90',
        dateFrom: DateTime(2026, 1, 5),
        dateTo: DateTime(2026, 6, 1),
        sortBy: AdminProductSort.stockQuantity,
        sortDesc: false,
      );

      final (products, meta) =
          await datasource.getProducts(filters: filters, page: 2);

      expect(products.length, 2);
      expect(meta.currentPage, 2);
      expect(meta.lastPage, 3);
      expect(meta.total, 42);

      final captured =
          verify(() => httpClient.get(captureAny(), headers: any(named: 'headers')))
              .captured
              .single as Uri;
      expect(captured.path, endsWith('/admin/products'));
      expect(captured.queryParameters['page'], '2');
      expect(captured.queryParameters['search'], 'ração');
      expect(captured.queryParameters['is_active'], '1');
      expect(captured.queryParameters['is_highlighted'], '1');
      expect(captured.queryParameters['out_of_stock'], '0');
      expect(captured.queryParametersAll['category_ids[]'], ['cat1', 'cat2']);
      expect(captured.queryParameters['price_min'], '10.00');
      expect(captured.queryParameters['price_max'], '99.90');
      expect(captured.queryParameters['date_from'], '2026-01-05');
      expect(captured.queryParameters['date_to'], '2026-06-01');
      expect(captured.queryParameters['sort_by'], 'stock_quantity');
      expect(captured.queryParameters['sort_order'], 'asc');
    });

    test('filtros vazios omitem os params opcionais', () async {
      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer(
        (_) async => http.Response(jsonEncode({'data': []}), 200),
      );

      await datasource.getProducts();

      final captured =
          verify(() => httpClient.get(captureAny(), headers: any(named: 'headers')))
              .captured
              .single as Uri;
      expect(captured.queryParameters.containsKey('search'), isFalse);
      expect(captured.queryParameters.containsKey('is_active'), isFalse);
      expect(captured.queryParameters.containsKey('category_ids[]'), isFalse);
      // Ordenação é sempre enviada (default: created_at desc).
      expect(captured.queryParameters['sort_by'], 'created_at');
      expect(captured.queryParameters['sort_order'], 'desc');
    });

    test('envia headers de auth e Host', () async {
      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer(
        (_) async => http.Response(jsonEncode({'data': []}), 200),
      );

      await datasource.getProducts();

      final headers = verify(
        () => httpClient.get(any(), headers: captureAny(named: 'headers')),
      ).captured.single as Map<String, String>;
      expect(headers['Authorization'], 'Bearer token');
      expect(headers['Host'], 'doglio_backend.test');
    });
  });

  group('createProduct (multipart)', () {
    test('envia POST multipart com fields e arquivos', () async {
      when(() => httpClient.send(any())).thenAnswer(
        (_) async => http.StreamedResponse(
          Stream.value(utf8.encode(jsonEncode({'data': _productJson()}))),
          201,
          headers: {'content-type': 'application/json; charset=utf-8'},
        ),
      );

      final result = await datasource.createProduct(
        _model,
        imagePaths: [tempImage.path],
      );

      expect(result.id, 'p1');

      final request = verify(() => httpClient.send(captureAny()))
          .captured
          .single as http.MultipartRequest;
      expect(request.method, 'POST');
      expect(request.url.path, endsWith('/admin/products'));
      expect(request.fields['name'], 'Ração');
      expect(request.fields.containsKey('_method'), isFalse);
      expect(request.files.length, 1);
      expect(request.files.single.field, 'images[]');
      // O Content-Type multipart (com boundary) é definido pelo próprio
      // MultipartRequest no finalize(); o datasource não pode forçar JSON.
      expect(request.headers['Content-Type'], isNot('application/json'));
      expect(request.headers['Authorization'], 'Bearer token');
    });
  });

  group('updateProduct (multipart + method spoofing)', () {
    test('envia POST com _method=PUT, is_active e remove_images', () async {
      when(() => httpClient.send(any())).thenAnswer(
        (_) async => http.StreamedResponse(
          Stream.value(utf8.encode(jsonEncode({'data': _productJson()}))),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        ),
      );

      await datasource.updateProduct(
        _model,
        imagePaths: const [],
        removeImageIds: const ['img1'],
      );

      final request = verify(() => httpClient.send(captureAny()))
          .captured
          .single as http.MultipartRequest;
      expect(request.method, 'POST');
      expect(request.url.path, endsWith('/admin/products/p1'));
      expect(request.fields['_method'], 'PUT');
      expect(request.fields['is_active'], '1');
      expect(request.fields['remove_images[0]'], 'img1');
      expect(request.files, isEmpty);
    });

    test('422 lança ValidationException com erros por campo', () async {
      when(() => httpClient.send(any())).thenAnswer(
        (_) async => http.StreamedResponse(
          Stream.value(utf8.encode(jsonEncode({
            'success': false,
            'message': 'Falha na validação.',
            'errors': {
              'price': ['O preço é obrigatório.'],
              'images.0': ['Imagem inválida.'],
            },
          }))),
          422,
          headers: {'content-type': 'application/json; charset=utf-8'},
        ),
      );

      expect(
        () => datasource.updateProduct(
          _model,
          imagePaths: const [],
          removeImageIds: const [],
        ),
        throwsA(isA<ValidationException>().having(
          (e) => e.errors['price'],
          'errors[price]',
          ['O preço é obrigatório.'],
        )),
      );
    });
  });

  group('deleteProduct', () {
    test('DELETE com sucesso (204)', () async {
      when(() => httpClient.delete(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('', 204));

      await datasource.deleteProduct('p1');

      final captured = verify(
        () => httpClient.delete(captureAny(), headers: any(named: 'headers')),
      ).captured.single as Uri;
      expect(captured.path, endsWith('/admin/products/p1'));
    });

    test('erro usa a message do backend', () async {
      when(() => httpClient.delete(any(), headers: any(named: 'headers')))
          .thenAnswer(
        (_) async => http.Response(
          jsonEncode({'success': false, 'message': 'Não encontrado.'}),
          404,
        ),
      );

      expect(
        () => datasource.deleteProduct('p1'),
        throwsA(predicate((e) => e.toString().contains('Não encontrado.'))),
      );
    });
  });

  group('getStockMovements', () {
    test('GET /{id}/stock parseia movimentações + meta', () async {
      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'data': [
              {
                'id': 'm1',
                'type': 'in',
                'quantity': 10,
                'stock_before': 0,
                'stock_after': 10,
                'reason': 'purchase',
              },
            ],
            'meta': {'current_page': 1, 'last_page': 1, 'total': 1},
          }),
          200,
        ),
      );

      final (movements, meta) =
          await datasource.getStockMovements('p1', page: 1);

      expect(movements.single.quantity, 10);
      expect(meta.total, 1);

      final captured =
          verify(() => httpClient.get(captureAny(), headers: any(named: 'headers')))
              .captured
              .single as Uri;
      expect(captured.path, endsWith('/admin/products/p1/stock'));
    });
  });

  group('adjustStock', () {
    test('modo delta envia type + quantity em JSON', () async {
      when(() => httpClient.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'data': {
              'id': 'm1',
              'type': 'out',
              'quantity': 2,
              'stock_before': 5,
              'stock_after': 3,
              'reason': 'loss',
            },
          }),
          201,
        ),
      );

      final movement = await datasource.adjustStock(
        'p1',
        type: 'out',
        quantity: 2,
        reason: 'loss',
        notes: 'avaria',
      );

      expect(movement.stockAfter, 3);

      final body = jsonDecode(
        verify(() => httpClient.post(any(),
                headers: any(named: 'headers'), body: captureAny(named: 'body')))
            .captured
            .single as String,
      ) as Map<String, dynamic>;
      expect(body['type'], 'out');
      expect(body['quantity'], 2);
      expect(body.containsKey('absolute'), isFalse);
      expect(body['reason'], 'loss');
      expect(body['notes'], 'avaria');
    });

    test('modo absoluto envia somente absolute', () async {
      when(() => httpClient.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer(
        (_) async => http.Response(jsonEncode({'data': {'id': 'm1'}}), 200),
      );

      await datasource.adjustStock('p1', absolute: 0, reason: 'manual_adjustment');

      final body = jsonDecode(
        verify(() => httpClient.post(any(),
                headers: any(named: 'headers'), body: captureAny(named: 'body')))
            .captured
            .single as String,
      ) as Map<String, dynamic>;
      expect(body['absolute'], 0);
      expect(body.containsKey('type'), isFalse);
      expect(body.containsKey('quantity'), isFalse);
    });

    test('INSUFFICIENT_STOCK propaga a message do backend', () async {
      when(() => httpClient.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'success': false,
            'message': 'Estoque insuficiente.',
            'error': {'code': 'INSUFFICIENT_STOCK'},
          }),
          400,
        ),
      );

      expect(
        () => datasource.adjustStock('p1',
            type: 'out', quantity: 99, reason: 'manual_adjustment'),
        throwsA(
            predicate((e) => e.toString().contains('Estoque insuficiente.'))),
      );
    });
  });
}
