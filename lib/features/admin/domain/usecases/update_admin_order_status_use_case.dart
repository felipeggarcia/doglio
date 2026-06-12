library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_order.dart';
import '../repositories/admin_orders_repository.dart';

class UpdateAdminOrderStatusUseCase {
  const UpdateAdminOrderStatusUseCase(this._repository);
  final AdminOrdersRepository _repository;

  Future<Either<Failure, AdminOrder>> call(
    String id,
    AdminOrderStatus status, {
    String? notes,
  }) =>
      _repository.updateOrderStatus(id, status, notes: notes);
}
