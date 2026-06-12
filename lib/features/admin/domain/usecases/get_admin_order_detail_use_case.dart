library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_order.dart';
import '../repositories/admin_orders_repository.dart';

class GetAdminOrderDetailUseCase {
  const GetAdminOrderDetailUseCase(this._repository);
  final AdminOrdersRepository _repository;

  Future<Either<Failure, AdminOrder>> call(String id) =>
      _repository.getOrderDetail(id);
}
