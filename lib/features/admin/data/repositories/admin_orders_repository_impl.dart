library;

import 'dart:async';
import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/admin_order.dart';
import '../../domain/entities/page_meta.dart';
import '../../domain/repositories/admin_orders_repository.dart';
import '../datasources/admin_orders_remote_datasource.dart';

class AdminOrdersRepositoryImpl implements AdminOrdersRepository {
  const AdminOrdersRepositoryImpl(this._datasource);
  final AdminOrdersRemoteDatasource _datasource;

  @override
  Future<Either<Failure, (List<AdminOrder>, PageMeta)>> getOrders({
    AdminOrderStatus? status,
    String? deliveryType,
    DateTime? dateFrom,
    DateTime? dateTo,
    int page = 1,
  }) =>
      _guard(() async {
        final (models, meta) = await _datasource.getOrders(
          status: status,
          deliveryType: deliveryType,
          dateFrom: dateFrom,
          dateTo: dateTo,
          page: page,
        );
        return (models.map((m) => m.toEntity()).toList(), meta);
      });

  @override
  Future<Either<Failure, AdminOrder>> getOrderDetail(String id) =>
      _guard(() async {
        final model = await _datasource.getOrderDetail(id);
        return model.toEntity();
      });

  @override
  Future<Either<Failure, AdminOrder>> updateOrderStatus(
    String id,
    AdminOrderStatus status, {
    String? notes,
  }) =>
      _guard(() async {
        final model =
            await _datasource.updateOrderStatus(id, status, notes: notes);
        return model.toEntity();
      });

  @override
  Future<Either<Failure, AdminOrder>> addOrderItem(
    String orderId, {
    required String productId,
    required int quantity,
  }) =>
      _guard(() async {
        final model = await _datasource.addOrderItem(
          orderId,
          productId: productId,
          quantity: quantity,
        );
        return model.toEntity();
      });

  @override
  Future<Either<Failure, AdminOrder>> updateOrderItem(
    String orderId,
    String itemId, {
    required int quantity,
  }) =>
      _guard(() async {
        final model = await _datasource.updateOrderItem(
          orderId,
          itemId,
          quantity: quantity,
        );
        return model.toEntity();
      });

  @override
  Future<Either<Failure, AdminOrder>> removeOrderItem(
    String orderId,
    String itemId,
  ) =>
      _guard(() async {
        final model = await _datasource.removeOrderItem(orderId, itemId);
        return model.toEntity();
      });

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on ValidationException catch (e) {
      return Left(
        e.errors.isNotEmpty
            ? ValidationFailure(e.errors)
            : UnknownFailure(e.message),
      );
    } on TimeoutException {
      return const Left(TimeoutFailure());
    } on SocketException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
