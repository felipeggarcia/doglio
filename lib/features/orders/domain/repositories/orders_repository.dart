/// Orders repository interface
library;

import 'package:fpdart/fpdart.dart' hide Order;
import '../../../../core/errors/failures.dart';
import '../entities/order.dart';

abstract interface class OrdersRepository {
  Future<Either<Failure, List<Order>>> getOrders();
  Future<Either<Failure, Order>> getOrderDetail(String orderId);
}
