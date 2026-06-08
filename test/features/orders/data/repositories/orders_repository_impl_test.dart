import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doglio/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:doglio/features/orders/data/models/order_model.dart';
import 'package:doglio/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:doglio/features/orders/domain/entities/order.dart';

class MockOrdersRemoteDatasource extends Mock implements OrdersRemoteDatasource {}

void main() {
  late MockOrdersRemoteDatasource mockDatasource;
  late OrdersRepositoryImpl repository;

  final tCreatedAt = DateTime(2026, 6, 8, 14, 9);

  final tModel = OrderModel(
    id: '42',
    status: OrderStatus.pending,
    items: const [],
    total: '45.90',
    createdAt: tCreatedAt,
  );

  setUp(() {
    mockDatasource = MockOrdersRemoteDatasource();
    repository = OrdersRepositoryImpl(mockDatasource);
  });

  group('getOrders', () {
    test('Right(List<Order>) quando datasource retorna pares', () async {
      when(() => mockDatasource.getOrders()).thenAnswer(
        (_) async => [(tModel, '00020')],
      );

      final result = await repository.getOrders();

      expect(result.isRight(), isTrue);
      final orders = result.fold((_) => <Order>[], (o) => o);
      expect(orders.length, 1);
      expect(orders.first.id, '42');
      expect(orders.first.orderNumber, '00020');
    });

    test('Left(UnknownFailure) quando datasource lança exceção', () async {
      when(() => mockDatasource.getOrders()).thenThrow(Exception('network error'));

      final result = await repository.getOrders();

      expect(result.isLeft(), isTrue);
    });
  });

  group('getOrderDetail', () {
    test('Right(Order) com payment PIX quando paymentRaw tem type "pix"', () async {
      when(() => mockDatasource.getOrderDetail('42')).thenAnswer(
        (_) async => (
          tModel,
          '00020',
          <Map<String, dynamic>>[],
          <String, dynamic>{
            'type': 'pix',
            'status': 'pending',
            'amount': '45.90',
            'pix_code': 'EMV_CODE_123',
            'pix_qr_code': 'base64imgdata',
            'pix_expires_at': '2026-06-09T14:09:00.000Z',
          },
        ),
      );

      final result = await repository.getOrderDetail('42');

      expect(result.isRight(), isTrue);
      final order = result.fold((_) => null, (o) => o)!;
      expect(order.payment, isNotNull);
      expect(order.payment!.isPix, isTrue);
      expect(order.payment!.pixCode, 'EMV_CODE_123');
      expect(order.payment!.pixQrCode, 'base64imgdata');
      expect(order.payment!.pixExpiresAt, isNotNull);
      expect(order.payment!.amount, '45.90');
    });

    test('Right(Order) com payment boleto quando paymentRaw tem type "boleto"', () async {
      when(() => mockDatasource.getOrderDetail('42')).thenAnswer(
        (_) async => (
          tModel,
          '00020',
          <Map<String, dynamic>>[],
          <String, dynamic>{
            'type': 'boleto',
            'status': 'pending',
            'boleto_code': '03399.12345 67890.01234 12345.00000 1',
            'boleto_expires_at': '2026-06-10T23:59:00.000Z',
          },
        ),
      );

      final result = await repository.getOrderDetail('42');

      expect(result.isRight(), isTrue);
      final order = result.fold((_) => null, (o) => o)!;
      expect(order.payment!.isBoleto, isTrue);
      expect(order.payment!.boletoCode, '03399.12345 67890.01234 12345.00000 1');
      expect(order.payment!.boletoExpiresAt, isNotNull);
    });

    test('Right(Order) com payment credit_card quando paymentRaw tem type "credit_card"', () async {
      when(() => mockDatasource.getOrderDetail('42')).thenAnswer(
        (_) async => (
          tModel,
          '00020',
          <Map<String, dynamic>>[],
          <String, dynamic>{
            'type': 'credit_card',
            'status': 'approved',
            'card_last_four': '4242',
            'card_brand': 'Visa',
            'installments': 3,
          },
        ),
      );

      final result = await repository.getOrderDetail('42');

      expect(result.isRight(), isTrue);
      final order = result.fold((_) => null, (o) => o)!;
      expect(order.payment!.isCreditCard, isTrue);
      expect(order.payment!.cardLastFour, '4242');
      expect(order.payment!.cardBrand, 'Visa');
      expect(order.payment!.installments, 3);
    });

    test('Right(Order) com payment null quando paymentRaw é null', () async {
      when(() => mockDatasource.getOrderDetail('42')).thenAnswer(
        (_) async => (
          tModel,
          '00020',
          <Map<String, dynamic>>[],
          null,
        ),
      );

      final result = await repository.getOrderDetail('42');

      expect(result.isRight(), isTrue);
      final order = result.fold((_) => null, (o) => o)!;
      expect(order.payment, isNull);
    });

    test('lê type de payment_method.type quando presente', () async {
      when(() => mockDatasource.getOrderDetail('42')).thenAnswer(
        (_) async => (
          tModel,
          '00020',
          <Map<String, dynamic>>[],
          <String, dynamic>{
            'payment_method': {'type': 'boleto'},
            'status': 'pending',
            'boleto_code': 'CODEX',
          },
        ),
      );

      final result = await repository.getOrderDetail('42');

      final order = result.fold((_) => null, (o) => o)!;
      expect(order.payment!.isBoleto, isTrue);
    });

    test('parseia status_history corretamente', () async {
      when(() => mockDatasource.getOrderDetail('42')).thenAnswer(
        (_) async => (
          tModel,
          '00020',
          <Map<String, dynamic>>[
            {'status': 'pending', 'created_at': '2026-06-08T14:09:00.000Z'},
            {'status': 'processing', 'created_at': '2026-06-08T15:00:00.000Z'},
          ],
          null,
        ),
      );

      final result = await repository.getOrderDetail('42');

      final order = result.fold((_) => null, (o) => o)!;
      expect(order.statusHistory.length, 2);
      expect(order.statusHistory.first.status, OrderStatus.pending);
      expect(order.statusHistory.last.status, OrderStatus.processing);
    });

    test('Left(UnknownFailure) quando datasource lança exceção', () async {
      when(() => mockDatasource.getOrderDetail('42')).thenThrow(Exception('timeout'));

      final result = await repository.getOrderDetail('42');

      expect(result.isLeft(), isTrue);
    });
  });
}
