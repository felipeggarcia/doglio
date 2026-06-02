/// Get orders use case
library;

import 'package:fpdart/fpdart.dart' hide Order;
import '../../../../core/errors/failures.dart';
import '../entities/order.dart';
import '../repositories/orders_repository.dart';

class GetOrdersUseCase {
  const GetOrdersUseCase(this._repository);
  final OrdersRepository _repository;

  Future<Either<Failure, List<Order>>> call() => _repository.getOrders();
}

class GetOrderDetailUseCase {
  const GetOrderDetailUseCase(this._repository);
  final OrdersRepository _repository;

  Future<Either<Failure, Order>> call(String orderId) =>
      _repository.getOrderDetail(orderId);
}
