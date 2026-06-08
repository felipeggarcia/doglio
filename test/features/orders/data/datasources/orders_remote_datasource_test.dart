import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:doglio/core/storage/secure_storage.dart';
import 'package:doglio/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:doglio/features/orders/domain/entities/order.dart';

class MockHttpClient extends Mock implements http.Client {}
class MockSecureStorage extends Mock implements SecureStorage {}

Map<String, dynamic> _orderJson({Map<String, dynamic>? payment}) {
  final map = <String, dynamic>{
    'id': 42,
    'order_number': '00020',
    'status': 'pending',
    'total_amount': '45.90',
    'created_at': '2026-06-08T14:09:00.000Z',
    'updated_at': '2026-06-08T14:09:00.000Z',
    'items': <dynamic>[],
  };
  if (payment != null) map['payment'] = payment;
  return map;
}

void main() {
  late MockHttpClient mockHttpClient;
  late MockSecureStorage mockSecureStorage;
  late OrdersRemoteDatasource datasource;

  setUpAll(() {
    registerFallbackValue(Uri.parse('http://example.com'));
    registerFallbackValue(<String, String>{});
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockSecureStorage = MockSecureStorage();
    datasource = OrdersRemoteDatasource(
      httpClient: mockHttpClient,
      secureStorage: mockSecureStorage,
    );
    when(() => mockSecureStorage.getToken()).thenAnswer((_) async => 'test_token');
  });

  group('getOrders', () {
    test('retorna lista de pares (model, orderNumber)', () async {
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                jsonEncode({
                  'data': [_orderJson()],
                }),
                200,
              ));

      final result = await datasource.getOrders();

      expect(result.length, 1);
      final (model, orderNumber) = result.first;
      expect(model.id, '42');
      expect(model.status, OrderStatus.pending);
      expect(orderNumber, '00020');
    });

    test('lança exceção quando status != 200', () async {
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{"error":"Unauthorized"}', 401));

      expect(() => datasource.getOrders(), throwsException);
    });
  });

  group('getOrderDetail', () {
    test('retorna 4-tuple com paymentRaw quando pedido tem pagamento PIX', () async {
      final pixPayment = {
        'type': 'pix',
        'status': 'pending',
        'pix_code': 'EMV_CODE_123',
        'pix_qr_code': 'base64imgdata',
        'pix_expires_at': '2026-06-09T14:09:00.000Z',
      };
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                jsonEncode({'data': _orderJson(payment: pixPayment)}),
                200,
              ));

      final result = await datasource.getOrderDetail('42');
      final (model, orderNumber, historyRaw, paymentRaw) = result;

      expect(model.id, '42');
      expect(orderNumber, '00020');
      expect(historyRaw, isEmpty);
      expect(paymentRaw, isNotNull);
      expect(paymentRaw!['type'], 'pix');
      expect(paymentRaw['pix_code'], 'EMV_CODE_123');
      expect(paymentRaw['pix_qr_code'], 'base64imgdata');
    });

    test('retorna paymentRaw nulo quando pedido não tem campo "payment"', () async {
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                jsonEncode({'data': _orderJson()}),
                200,
              ));

      final (_, _, _, paymentRaw) = await datasource.getOrderDetail('42');

      expect(paymentRaw, isNull);
    });

    test('retorna status_history quando presente na resposta', () async {
      final orderWithHistory = {
        ..._orderJson(),
        'status_history': [
          {'status': 'pending', 'created_at': '2026-06-08T14:09:00.000Z'},
          {'status': 'processing', 'created_at': '2026-06-08T15:00:00.000Z'},
        ],
      };
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                jsonEncode({'data': orderWithHistory}),
                200,
              ));

      final (_, _, historyRaw, _) = await datasource.getOrderDetail('42');

      expect(historyRaw.length, 2);
      expect(historyRaw.first['status'], 'pending');
      expect(historyRaw.last['status'], 'processing');
    });

    test('normaliza id inteiro para string', () async {
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                jsonEncode({'data': _orderJson()}),
                200,
              ));

      final (model, _, _, _) = await datasource.getOrderDetail('42');

      expect(model.id, '42');
      expect(model.id, isA<String>());
    });

    test('lança exceção quando status != 200', () async {
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{"error":"Not Found"}', 404));

      expect(() => datasource.getOrderDetail('99'), throwsException);
    });
  });
}
