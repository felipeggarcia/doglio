library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_order.dart';
import '../repositories/admin_orders_repository.dart';

class AddOrderItemUseCase {
  const AddOrderItemUseCase(this._repository);
  final AdminOrdersRepository _repository;

  Future<Either<Failure, AdminOrder>> call(
    String orderId, {
    required String productId,
    required int quantity,
  }) =>
      _repository.addOrderItem(orderId,
          productId: productId, quantity: quantity);
}
