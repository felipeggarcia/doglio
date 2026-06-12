library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_order.dart';
import '../entities/page_meta.dart';
import '../repositories/admin_orders_repository.dart';

class GetAdminOrdersUseCase {
  const GetAdminOrdersUseCase(this._repository);
  final AdminOrdersRepository _repository;

  Future<Either<Failure, (List<AdminOrder>, PageMeta)>> call({
    AdminOrderStatus? status,
    String? deliveryType,
    DateTime? dateFrom,
    DateTime? dateTo,
    int page = 1,
  }) =>
      _repository.getOrders(
        status: status,
        deliveryType: deliveryType,
        dateFrom: dateFrom,
        dateTo: dateTo,
        page: page,
      );
}
