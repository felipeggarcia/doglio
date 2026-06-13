library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_order.dart';
import '../entities/page_meta.dart';

abstract interface class AdminOrdersRepository {
  Future<Either<Failure, (List<AdminOrder>, PageMeta)>> getOrders({
    String? search,
    AdminOrderStatus? status,
    String? deliveryType,
    DateTime? dateFrom,
    DateTime? dateTo,
    int page = 1,
  });

  Future<Either<Failure, AdminOrder>> getOrderDetail(String id);

  Future<Either<Failure, AdminOrder>> updateOrderStatus(
    String id,
    AdminOrderStatus status, {
    String? notes,
  });

  Future<Either<Failure, AdminOrder>> addOrderItem(
    String orderId, {
    required String productId,
    required int quantity,
  });

  Future<Either<Failure, AdminOrder>> updateOrderItem(
    String orderId,
    String itemId, {
    required int quantity,
  });

  Future<Either<Failure, AdminOrder>> removeOrderItem(
    String orderId,
    String itemId,
  );
}
