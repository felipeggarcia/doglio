library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_order.dart';
import '../repositories/admin_orders_repository.dart';

class UpdateOrderItemUseCase {
  const UpdateOrderItemUseCase(this._repository);
  final AdminOrdersRepository _repository;

  Future<Either<Failure, AdminOrder>> call(
    String orderId,
    String itemId, {
    required int quantity,
  }) =>
      _repository.updateOrderItem(orderId, itemId, quantity: quantity);
}
