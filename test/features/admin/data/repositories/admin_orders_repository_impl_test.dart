import 'dart:async';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doglio/core/errors/exceptions.dart';
import 'package:doglio/core/errors/failures.dart';
import 'package:doglio/features/admin/data/datasources/admin_orders_remote_datasource.dart';
import 'package:doglio/features/admin/data/models/admin_order_model.dart';
import 'package:doglio/features/admin/data/repositories/admin_orders_repository_impl.dart';
import 'package:doglio/features/admin/domain/entities/admin_order.dart';
import 'package:doglio/features/admin/domain/entities/page_meta.dart';

class MockDatasource extends Mock implements AdminOrdersRemoteDatasource {}

AdminOrderModel _model(String id) => AdminOrderModel(
      id: id,
      status: AdminOrderStatus.pending,
      totalAmount: '50.00',
      deliveryType: 'pickup',
      customer: const AdminOrderCustomer(
          id: 'c1', name: 'Ana', email: 'ana@x.com'),
      items: const [],
      statusHistory: const [],
      createdAt: DateTime(2026, 6, 10),
    );

void main() {
  late MockDatasource datasource;
  late AdminOrdersRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(AdminOrderStatus.pending);
    registerFallbackValue(DateTime(2020));
  });

  setUp(() {
    datasource = MockDatasource();
    repository = AdminOrdersRepositoryImpl(datasource);
  });

  group('getOrders', () {
    test('Right com lista e meta no sucesso', () async {
      when(() => datasource.getOrders(
            status: any(named: 'status'),
            deliveryType: any(named: 'deliveryType'),
            dateFrom: any(named: 'dateFrom'),
            dateTo: any(named: 'dateTo'),
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
          )).thenAnswer(
        (_) async => ([_model('o1'), _model('o2')], PageMeta.empty),
      );

      final result = await repository.getOrders();

      expect(result.isRight(), isTrue);
      final (orders, meta) = result.getRight().toNullable()!;
      expect(orders.length, 2);
      expect(meta, PageMeta.empty);
    });

    test('Left(UnknownFailure) quando datasource lança', () async {
      when(() => datasource.getOrders(
            status: any(named: 'status'),
            deliveryType: any(named: 'deliveryType'),
            dateFrom: any(named: 'dateFrom'),
            dateTo: any(named: 'dateTo'),
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
          )).thenThrow(Exception('server error'));

      final result = await repository.getOrders();
      expect(result.isLeft(), isTrue);
      expect(result.getLeft().toNullable(), isA<UnknownFailure>());
    });

    test('Left(TimeoutFailure) em TimeoutException', () async {
      when(() => datasource.getOrders(
            status: any(named: 'status'),
            deliveryType: any(named: 'deliveryType'),
            dateFrom: any(named: 'dateFrom'),
            dateTo: any(named: 'dateTo'),
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
          )).thenThrow(TimeoutException('timeout'));

      final result = await repository.getOrders();
      expect(result.getLeft().toNullable(), isA<TimeoutFailure>());
    });

    test('Left(NetworkFailure) em SocketException', () async {
      when(() => datasource.getOrders(
            status: any(named: 'status'),
            deliveryType: any(named: 'deliveryType'),
            dateFrom: any(named: 'dateFrom'),
            dateTo: any(named: 'dateTo'),
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
          )).thenThrow(const SocketException('sem rede'));

      final result = await repository.getOrders();
      expect(result.getLeft().toNullable(), isA<NetworkFailure>());
    });
  });

  group('getOrderDetail', () {
    test('Right com entidade no sucesso', () async {
      when(() => datasource.getOrderDetail(any()))
          .thenAnswer((_) async => _model('ord1'));

      final result = await repository.getOrderDetail('ord1');
      expect(result.isRight(), isTrue);
      expect(result.getRight().toNullable()!.id, 'ord1');
    });

    test('Left quando datasource lança', () async {
      when(() => datasource.getOrderDetail(any()))
          .thenThrow(Exception('not found'));

      final result = await repository.getOrderDetail('ord1');
      expect(result.isLeft(), isTrue);
    });
  });

  group('updateOrderStatus', () {
    test('Right no sucesso', () async {
      when(() => datasource.updateOrderStatus(
            any(),
            any(),
            notes: any(named: 'notes'),
          )).thenAnswer((_) async => _model('ord1'));

      final result = await repository.updateOrderStatus(
          'ord1', AdminOrderStatus.confirmed);
      expect(result.isRight(), isTrue);
    });
  });

  group('addOrderItem', () {
    test('Right no sucesso', () async {
      when(() => datasource.addOrderItem(
            any(),
            productId: any(named: 'productId'),
            quantity: any(named: 'quantity'),
          )).thenAnswer((_) async => _model('ord1'));

      final result = await repository.addOrderItem(
          'ord1', productId: 'p1', quantity: 2);
      expect(result.isRight(), isTrue);
    });

    test('Left(ValidationFailure) em ValidationException com errors', () async {
      when(() => datasource.addOrderItem(
            any(),
            productId: any(named: 'productId'),
            quantity: any(named: 'quantity'),
          )).thenThrow(
        const ValidationException('Sem estoque.', errors: {
          'quantity': ['Insuficiente'],
        }),
      );

      final result = await repository.addOrderItem(
          'ord1', productId: 'p1', quantity: 999);
      expect(result.getLeft().toNullable(), isA<ValidationFailure>());
    });

    test('Left(UnknownFailure) em ValidationException sem errors estruturados',
        () async {
      when(() => datasource.addOrderItem(
            any(),
            productId: any(named: 'productId'),
            quantity: any(named: 'quantity'),
          )).thenThrow(
        const ValidationException('Sem estoque.'),
      );

      final result = await repository.addOrderItem(
          'ord1', productId: 'p1', quantity: 999);
      expect(result.getLeft().toNullable(), isA<UnknownFailure>());
    });
  });

  group('updateOrderItem', () {
    test('Right no sucesso', () async {
      when(() => datasource.updateOrderItem(any(), any(),
              quantity: any(named: 'quantity')))
          .thenAnswer((_) async => _model('ord1'));

      final result =
          await repository.updateOrderItem('ord1', 'item1', quantity: 5);
      expect(result.isRight(), isTrue);
    });
  });

  group('removeOrderItem', () {
    test('Right no sucesso', () async {
      when(() => datasource.removeOrderItem(any(), any()))
          .thenAnswer((_) async => _model('ord1'));

      final result = await repository.removeOrderItem('ord1', 'item1');
      expect(result.isRight(), isTrue);
    });

    test('Left quando datasource lança', () async {
      when(() => datasource.removeOrderItem(any(), any()))
          .thenThrow(Exception('item não encontrado'));

      final result = await repository.removeOrderItem('ord1', 'item1');
      expect(result.isLeft(), isTrue);
    });
  });
}
