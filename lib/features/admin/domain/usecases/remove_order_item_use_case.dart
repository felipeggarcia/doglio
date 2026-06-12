library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_order.dart';
import '../repositories/admin_orders_repository.dart';

class RemoveOrderItemUseCase {
  const RemoveOrderItemUseCase(this._repository);
  final AdminOrdersRepository _repository;

  Future<Either<Failure, AdminOrder>> call(
    String orderId,
    String itemId,
  ) =>
      _repository.removeOrderItem(orderId, itemId);
}
