import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:doglio/core/errors/exceptions.dart';
import 'package:doglio/core/storage/secure_storage.dart';
import 'package:doglio/features/admin/data/datasources/admin_promotions_remote_datasource.dart';
import 'package:doglio/features/admin/data/models/admin_promotion_model.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockSecureStorage extends Mock implements SecureStorage {}

Map<String, dynamic> _promoJson({String id = '1'}) => {
      'id': id,
      'name': 'Promo $id',
      'type': 'percentage',
      'discount_value': '15.00',
      'starts_at': '2026-01-01T00:00:00.000Z',
      'is_active': true,
      'is_currently_active': true,
      'min_quantity': 1,
      'products': [],
    };

AdminPromotionModel _model({String id = '1'}) =>
    AdminPromotionModel.fromJson(_promoJson(id: id));

void main() {
  late MockHttpClient http_;
  late MockSecureStorage storage;
  late AdminPromotionsRemoteDatasource datasource;

  setUpAll(() {
    registerFallbackValue(Uri.parse('http://example.com'));
    registerFallbackValue(<String, String>{});
    registerFallbackValue(http.Request('GET', Uri.parse('http://example.com')));
  });

  setUp(() {
    http_ = MockHttpClient();
    storage = MockSecureStorage();
    datasource = AdminPromotionsRemoteDatasource(
      httpClient: http_,
      secureStorage: storage,
    );
    when(() => storage.getToken()).thenAnswer((_) async => 'token');
  });

  group('getPromotions', () {
    test('parseia lista paginada e meta', () async {
      when(() => http_.get(any(), headers: any(named: 'headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'data': [_promoJson(id: '1'), _promoJson(id: '2')],
            'meta': {'current_page': 1, 'last_page': 2, 'total': 10},
          }),
          200,
        ),
      );

      final (list, meta) = await datasource.getPromotions();

      expect(list.length, 2);
      expect(meta.total, 10);
      expect(meta.lastPage, 2);
    });

    test('envia filtro is_active como "1"', () async {
      when(() => http_.get(any(), headers: any(named: 'headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode({'data': [], 'meta': {}}),
          200,
        ),
      );

      await datasource.getPromotions(isActive: true);

      final uri =
          verify(() => http_.get(captureAny(), headers: any(named: 'headers')))
              .captured
              .single as Uri;
      expect(uri.queryParameters['is_active'], '1');
    });

    test('envia filtro expired como "1"', () async {
      when(() => http_.get(any(), headers: any(named: 'headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode({'data': [], 'meta': {}}),
          200,
        ),
      );

      await datasource.getPromotions(expired: true);

      final uri =
          verify(() => http_.get(captureAny(), headers: any(named: 'headers')))
              .captured
              .single as Uri;
      expect(uri.queryParameters['expired'], '1');
    });

    test('envia search quando fornecido', () async {
      when(() => http_.get(any(), headers: any(named: 'headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode({'data': [], 'meta': {}}),
          200,
        ),
      );

      await datasource.getPromotions(search: 'black');

      final uri =
          verify(() => http_.get(captureAny(), headers: any(named: 'headers')))
              .captured
              .single as Uri;
      expect(uri.queryParameters['search'], 'black');
    });
  });

  group('createPromotion', () {
    test('faz POST com JSON correto e parseia retorno', () async {
      when(() => http_.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer(
        (_) async => http.Response(
          jsonEncode({'data': _promoJson(id: '99')}),
          201,
        ),
      );

      final result = await datasource.createPromotion(_model());
      expect(result.id, '99');

      final uri =
          verify(() => http_.post(captureAny(),
                  headers: any(named: 'headers'), body: any(named: 'body')))
              .captured
              .single as Uri;
      expect(uri.path, endsWith('/admin/promotions'));
    });

    test('422 lança ValidationException', () async {
      when(() => http_.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'message': 'Erro de validação.',
            'errors': {
              'name': ['O campo nome é obrigatório.']
            }
          }),
          422,
        ),
      );

      expect(
        () => datasource.createPromotion(_model()),
        throwsA(isA<ValidationException>()),
      );
    });
  });

  group('updatePromotion', () {
    test('faz PUT em /admin/promotions/{id}', () async {
      when(() => http_.put(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer(
        (_) async =>
            http.Response(jsonEncode({'data': _promoJson(id: '5')}), 200),
      );

      await datasource.updatePromotion(_model(id: '5'));

      final uri =
          verify(() => http_.put(captureAny(),
                  headers: any(named: 'headers'), body: any(named: 'body')))
              .captured
              .single as Uri;
      expect(uri.path, endsWith('/admin/promotions/5'));
    });

    test('JSON de update não contém product_ids', () async {
      String? capturedBody;
      when(() => http_.put(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((invocation) async {
        capturedBody = invocation.namedArguments[const Symbol('body')] as String;
        return http.Response(
            jsonEncode({'data': _promoJson(id: '5')}), 200);
      });

      await datasource.updatePromotion(_model(id: '5'));

      final decoded = jsonDecode(capturedBody!) as Map<String, dynamic>;
      expect(decoded.containsKey('product_ids'), isFalse);
    });
  });

  group('deletePromotion', () {
    test('aceita 204 sem erro', () async {
      when(() => http_.delete(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('', 204));

      await expectLater(datasource.deletePromotion('3'), completes);
    });
  });

  group('linkProducts', () {
    test('faz POST em /admin/promotions/{id}/products com body correto',
        () async {
      String? capturedBody;
      when(() => http_.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((invocation) async {
        capturedBody = invocation.namedArguments[const Symbol('body')] as String;
        return http.Response(
            jsonEncode({'data': _promoJson(id: '2')}), 200);
      });

      await datasource.linkProducts(
        '2',
        [(productId: 'pX', useLimit: 5)],
      );

      final uri =
          verify(() => http_.post(captureAny(),
                  headers: any(named: 'headers'), body: any(named: 'body')))
              .captured
              .single as Uri;
      expect(uri.path, endsWith('/admin/promotions/2/products'));

      final decoded = jsonDecode(capturedBody!) as Map<String, dynamic>;
      final products = decoded['products'] as List<dynamic>;
      expect(products.length, 1);
      expect((products.first as Map)['id'], 'pX');
      expect((products.first as Map)['use_limit'], 5);
    });
  });

  group('unlinkProducts', () {
    test('faz DELETE com body JSON em /admin/promotions/{id}/products',
        () async {
      when(() => http_.send(any())).thenAnswer((_) async {
        final stream = http.ByteStream.fromBytes(
          utf8.encode(jsonEncode({'data': _promoJson(id: '3')})),
        );
        return http.StreamedResponse(stream, 200);
      });

      final result = await datasource.unlinkProducts('3', ['pA', 'pB']);
      expect(result.id, '3');

      final request =
          verify(() => http_.send(captureAny())).captured.single as http.Request;
      expect(request.method, 'DELETE');
      expect(request.url.path, endsWith('/admin/promotions/3/products'));
      final decoded = jsonDecode(request.body) as Map<String, dynamic>;
      expect((decoded['product_ids'] as List).length, 2);
    });
  });
}
