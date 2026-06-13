library;

import 'dart:async';
import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/admin_product.dart';
import '../../domain/entities/admin_product_filters.dart';
import '../../domain/entities/page_meta.dart';
import '../../domain/entities/stock_movement.dart';
import '../../domain/repositories/admin_products_repository.dart';
import '../datasources/admin_products_remote_datasource.dart';
import '../models/admin_product_model.dart';

class AdminProductsRepositoryImpl implements AdminProductsRepository {
  const AdminProductsRepositoryImpl(this._datasource);
  final AdminProductsRemoteDatasource _datasource;

  @override
  Future<Either<Failure, (List<AdminProduct>, PageMeta)>> getProducts({
    AdminProductFilters filters = AdminProductFilters.empty,
    int page = 1,
  }) async {
    return _guard(() async {
      final (models, meta) =
          await _datasource.getProducts(filters: filters, page: page);
      return (models.map((m) => m.toEntity()).toList(), meta);
    });
  }

  @override
  Future<Either<Failure, AdminProduct>> createProduct(
    AdminProduct product, {
    required List<String> newImagePaths,
  }) async {
    return _guard(() async {
      final result = await _datasource.createProduct(
        AdminProductModel.fromEntity(product),
        imagePaths: newImagePaths,
      );
      return result.toEntity();
    });
  }

  @override
  Future<Either<Failure, AdminProduct>> updateProduct(
    AdminProduct product, {
    required List<String> newImagePaths,
    required List<String> removeImageIds,
    List<String> imageOrder = const [],
  }) async {
    return _guard(() async {
      final result = await _datasource.updateProduct(
        AdminProductModel.fromEntity(product),
        imagePaths: newImagePaths,
        removeImageIds: removeImageIds,
        imageOrder: imageOrder,
      );
      return result.toEntity();
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteProduct(String id) async {
    return _guard(() async {
      await _datasource.deleteProduct(id);
      return unit;
    });
  }

  @override
  Future<Either<Failure, (List<StockMovement>, PageMeta)>> getStockMovements(
    String productId, {
    int page = 1,
  }) async {
    return _guard(() async {
      final (models, meta) =
          await _datasource.getStockMovements(productId, page: page);
      return (models.map((m) => m.toEntity()).toList(), meta);
    });
  }

  @override
  Future<Either<Failure, StockMovement>> adjustStock(
    String productId, {
    StockMovementType? type,
    int? quantity,
    int? absolute,
    StockMovementReason reason = StockMovementReason.manualAdjustment,
    String? notes,
  }) async {
    return _guard(() async {
      final result = await _datasource.adjustStock(
        productId,
        type: type?.toApi(),
        quantity: quantity,
        absolute: absolute,
        reason: reason.toApi(),
        notes: notes,
      );
      return result.toEntity();
    });
  }

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.errors));
    } on UnauthorizedException {
      return const Left(UnauthorizedFailure());
    } on ForbiddenException {
      return const Left(ForbiddenFailure());
    } on NotFoundException {
      return const Left(NotFoundFailure());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.statusCode, e.message));
    } on TimeoutException {
      return const Left(TimeoutFailure());
    } on SocketException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
