import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:doglio/core/errors/exceptions.dart';
import 'package:doglio/core/storage/secure_storage.dart';
import 'package:doglio/features/admin/data/datasources/admin_orders_remote_datasource.dart';
import 'package:doglio/features/admin/domain/entities/admin_order.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockSecureStorage extends Mock implements SecureStorage {}

Map<String, dynamic> _orderJson(String id) => {
      'id': id,
      'status': 'pending',
      'total_amount': '50.00',
      'delivery_type': 'pickup',
      'customer': {'id': 'c1', 'name': 'Ana', 'email': 'ana@x.com'},
      'items': [],
      'status_history': [],
      'created_at': '2026-06-10T10:00:00.000Z',
    };

http.Response _listResponse(List<String> ids) => http.Response(
      jsonEncode({
        'data': ids.map(_orderJson).toList(),
        'meta': {'current_page': 1, 'last_page': 1, 'total': ids.length},
      }),
      200,
    );

http.Response _singleResponse(String id) =>
    http.Response(jsonEncode({'data': _orderJson(id)}), 200);

void main() {
  late MockHttpClient http_;
  late MockSecureStorage storage;
  late AdminOrdersRemoteDatasource datasource;

  setUpAll(() {
    registerFallbackValue(Uri.parse('http://example.com'));
    registerFallbackValue(<String, String>{});
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    http_ = MockHttpClient();
    storage = MockSecureStorage();
    datasource = AdminOrdersRemoteDatasource(
      httpClient: http_,
      secureStorage: storage,
    );
    when(() => storage.getToken()).thenAnswer((_) async => 'token-test');
  });

  group('getOrders', () {
    test('parseia lista e inclui paginação', () async {
      when(() => http_.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => _listResponse(['o1', 'o2']));

      final (orders, meta) = await datasource.getOrders();

      expect(orders.length, 2);
      expect(meta.total, 2);
    });

    test('inclui status e delivery_type na query quando fornecidos', () async {
      when(() => http_.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => _listResponse([]));

      await datasource.getOrders(
        status: AdminOrderStatus.confirmed,
        deliveryType: 'delivery',
      );

      final uri =
          verify(() => http_.get(captureAny(), headers: any(named: 'headers')))
              .captured
              .single as Uri;
      expect(uri.queryParameters['status'], 'confirmed');
      expect(uri.queryParameters['delivery_type'], 'delivery');
    });

    test('inclui datas em formato yyyy-MM-dd', () async {
      when(() => http_.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => _listResponse([]));

      await datasource.getOrders(
        dateFrom: DateTime(2026, 1, 5),
        dateTo: DateTime(2026, 3, 20),
      );

      final uri =
          verify(() => http_.get(captureAny(), headers: any(named: 'headers')))
              .captured
              .single as Uri;
      expect(uri.queryParameters['date_from'], '2026-01-05');
      expect(uri.queryParameters['date_to'], '2026-03-20');
    });

    test('omite filtros opcionais quando null', () async {
      when(() => http_.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => _listResponse([]));

      await datasource.getOrders();

      final uri =
          verify(() => http_.get(captureAny(), headers: any(named: 'headers')))
              .captured
              .single as Uri;
      expect(uri.queryParameters.containsKey('status'), isFalse);
      expect(uri.queryParameters.containsKey('delivery_type'), isFalse);
      expect(uri.queryParameters.containsKey('date_from'), isFalse);
    });

    test('lança UnauthorizedException em 401', () async {
      when(() => http_.get(any(), headers: any(named: 'headers'))).thenAnswer(
        (_) async =>
            http.Response(jsonEncode({'message': 'Não autorizado'}), 401),
      );

      await expectLater(
        datasource.getOrders(),
        throwsA(isA<UnauthorizedException>()),
      );
    });
  });

  group('getOrderDetail', () {
    test('GET em /admin/orders/{id}', () async {
      when(() => http_.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => _singleResponse('ord99'));

      final order = await datasource.getOrderDetail('ord99');

      expect(order.id, 'ord99');
      final uri =
          verify(() => http_.get(captureAny(), headers: any(named: 'headers')))
              .captured
              .single as Uri;
      expect(uri.path, endsWith('/admin/orders/ord99'));
    });
  });

  group('updateOrderStatus', () {
    test('PATCH em /admin/orders/{id}/status com body JSON', () async {
      when(() => http_.patch(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => _singleResponse('ord1'));

      await datasource.updateOrderStatus(
          'ord1', AdminOrderStatus.confirmed,
          notes: 'Aprovado');

      final calls = verify(() => http_.patch(
            captureAny(),
            headers: any(named: 'headers'),
            body: captureAny(named: 'body'),
          )).captured;

      final uri = calls[0] as Uri;
      final body = jsonDecode(calls[1] as String) as Map<String, dynamic>;

      expect(uri.path, endsWith('/admin/orders/ord1/status'));
      expect(body['status'], 'confirmed');
      expect(body['notes'], 'Aprovado');
    });

    test('omite notes quando null', () async {
      when(() => http_.patch(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => _singleResponse('ord1'));

      await datasource.updateOrderStatus('ord1', AdminOrderStatus.cancelled);

      final bodyStr =
          verify(() => http_.patch(any(),
                  headers: any(named: 'headers'),
                  body: captureAny(named: 'body')))
              .captured
              .single as String;
      final body = jsonDecode(bodyStr) as Map<String, dynamic>;
      expect(body.containsKey('notes'), isFalse);
    });
  });

  group('addOrderItem', () {
    test('POST em /admin/orders/{id}/items com product_id e quantity', () async {
      when(() => http_.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => _singleResponse('ord1'));

      await datasource.addOrderItem('ord1',
          productId: 'prod5', quantity: 3);

      final calls = verify(() => http_.post(
            captureAny(),
            headers: any(named: 'headers'),
            body: captureAny(named: 'body'),
          )).captured;

      final uri = calls[0] as Uri;
      final body = jsonDecode(calls[1] as String) as Map<String, dynamic>;

      expect(uri.path, endsWith('/admin/orders/ord1/items'));
      expect(body['product_id'], 'prod5');
      expect(body['quantity'], 3);
    });

    test('lança ValidationException em 422', () async {
      when(() => http_.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'message': 'Estoque insuficiente.',
            'errors': {
              'quantity': ['Sem estoque.']
            },
          }),
          422,
        ),
      );

      await expectLater(
        () => datasource.addOrderItem('ord1',
            productId: 'prod5', quantity: 999),
        throwsA(isA<ValidationException>()),
      );
    });
  });

  group('updateOrderItem', () {
    test('PUT em /admin/orders/{id}/items/{itemId}', () async {
      when(() => http_.put(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => _singleResponse('ord1'));

      await datasource.updateOrderItem('ord1', 'item2', quantity: 5);

      final calls = verify(() => http_.put(
            captureAny(),
            headers: any(named: 'headers'),
            body: captureAny(named: 'body'),
          )).captured;

      final uri = calls[0] as Uri;
      final body = jsonDecode(calls[1] as String) as Map<String, dynamic>;

      expect(uri.path, endsWith('/admin/orders/ord1/items/item2'));
      expect(body['quantity'], 5);
    });
  });

  group('removeOrderItem', () {
    test('DELETE em /admin/orders/{id}/items/{itemId} sem body', () async {
      when(() => http_.delete(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => _singleResponse('ord1'));

      final result = await datasource.removeOrderItem('ord1', 'item3');
      expect(result.id, 'ord1');

      final uri =
          verify(() => http_.delete(captureAny(),
                  headers: any(named: 'headers')))
              .captured
              .single as Uri;
      expect(uri.path, endsWith('/admin/orders/ord1/items/item3'));
    });
  });
}
