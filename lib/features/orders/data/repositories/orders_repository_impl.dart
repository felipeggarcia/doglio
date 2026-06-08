/// Orders repository implementation
library;

import 'package:fpdart/fpdart.dart' hide Order;
import '../../../../core/errors/failures.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_remote_datasource.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  const OrdersRepositoryImpl(this._datasource);
  final OrdersRemoteDatasource _datasource;

  @override
  Future<Either<Failure, List<Order>>> getOrders() async {
    try {
      final pairs = await _datasource.getOrders();
      return Right(
        pairs
            .map((pair) {
              final (model, orderNumber) = pair;
              return model.toEntity(orderNumber: orderNumber);
            })
            .toList(),
      );
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> getOrderDetail(String orderId) async {
    try {
      final (model, orderNumber, historyRaw, paymentRaw) =
          await _datasource.getOrderDetail(orderId);
      final statusHistory = historyRaw
          .map(
            (e) => StatusHistoryEntry(
              status: _parseStatus(e['status'] as String? ?? 'pending'),
              occurredAt:
                  DateTime.tryParse(e['created_at'] as String? ?? '') ??
                      DateTime.now(),
            ),
          )
          .toList();
      final base = model.toEntity(
        orderNumber: orderNumber,
        payment: _parsePayment(paymentRaw),
      );
      return Right(
        Order(
          id: base.id,
          orderNumber: base.orderNumber,
          status: base.status,
          items: base.items,
          total: base.total,
          createdAt: base.createdAt,
          updatedAt: base.updatedAt,
          shippingAddress: base.shippingAddress,
          trackingCode: base.trackingCode,
          statusHistory: statusHistory,
          payment: base.payment,
        ),
      );
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  OrderStatus _parseStatus(String value) => switch (value.toLowerCase()) {
        'processing' => OrderStatus.processing,
        'shipped' => OrderStatus.shipped,
        'delivered' => OrderStatus.delivered,
        'cancelled' => OrderStatus.cancelled,
        _ => OrderStatus.pending,
      };

  OrderPayment? _parsePayment(Map<String, dynamic>? raw) {
    if (raw == null) return null;
    final methodData = raw['payment_method'] as Map<String, dynamic>?;
    final type =
        (methodData?['type'] ?? raw['type'] ?? 'pix') as String;
    return OrderPayment(
      type: type,
      status: raw['status'] as String? ?? 'pending',
      amount: raw['amount']?.toString(),
      pixCode: raw['pix_code'] as String?,
      pixQrCode: raw['pix_qr_code'] as String?,
      pixExpiresAt: _parseDate(raw['pix_expires_at']),
      boletoCode: raw['boleto_code'] as String?,
      boletoExpiresAt: _parseDate(raw['boleto_expires_at']),
      cardLastFour: raw['card_last_four'] as String?,
      cardBrand: raw['card_brand'] as String?,
      installments: raw['installments'] as int?,
    );
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
