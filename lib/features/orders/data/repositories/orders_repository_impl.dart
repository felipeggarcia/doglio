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
      final result = await _datasource.getOrders();
      return Right(result);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> getOrderDetail(String orderId) async {
    try {
      final result = await _datasource.getOrderDetail(orderId);
      return Right(result);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
