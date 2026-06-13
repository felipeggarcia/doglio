library;

import 'dart:async';
import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/admin_promotion.dart';
import '../../domain/entities/page_meta.dart';
import '../../domain/repositories/admin_promotions_repository.dart';
import '../datasources/admin_promotions_remote_datasource.dart';
import '../models/admin_promotion_model.dart';

class AdminPromotionsRepositoryImpl implements AdminPromotionsRepository {
  const AdminPromotionsRepositoryImpl(this._datasource);
  final AdminPromotionsRemoteDatasource _datasource;

  @override
  Future<Either<Failure, (List<AdminPromotion>, PageMeta)>> getPromotions({
    bool? isActive,
    bool? expired,
    String? search,
    List<String>? productIds,
    int page = 1,
  }) =>
      _guard(() async {
        final (models, meta) = await _datasource.getPromotions(
          isActive: isActive,
          expired: expired,
          search: search,
          productIds: productIds,
          page: page,
        );
        return (models.map((m) => m.toEntity()).toList(), meta);
      });

  @override
  Future<Either<Failure, AdminPromotion>> getPromotion(String id) =>
      _guard(() async {
        final model = await _datasource.getPromotion(id);
        return model.toEntity();
      });

  @override
  Future<Either<Failure, AdminPromotion>> createPromotion(
    AdminPromotion promotion,
  ) =>
      _guard(() async {
        final model = await _datasource.createPromotion(
          AdminPromotionModel.fromEntity(promotion),
          initialProducts: promotion.products.isNotEmpty
              ? promotion.products
                  .map((p) => (productId: p.id, useLimit: p.useLimit))
                  .toList()
              : null,
        );
        return model.toEntity();
      });

  @override
  Future<Either<Failure, AdminPromotion>> updatePromotion(
    AdminPromotion promotion,
  ) =>
      _guard(() async {
        final model = await _datasource
            .updatePromotion(AdminPromotionModel.fromEntity(promotion));
        return model.toEntity();
      });

  @override
  Future<Either<Failure, Unit>> deletePromotion(String id) =>
      _guard(() async {
        await _datasource.deletePromotion(id);
        return unit;
      });

  @override
  Future<Either<Failure, AdminPromotion>> linkProducts(
    String id,
    List<({String productId, int? useLimit})> products,
  ) =>
      _guard(() async {
        final model = await _datasource.linkProducts(id, products);
        return model.toEntity();
      });

  @override
  Future<Either<Failure, AdminPromotion>> unlinkProducts(
    String id,
    List<String> productIds,
  ) =>
      _guard(() async {
        final model = await _datasource.unlinkProducts(id, productIds);
        return model.toEntity();
      });

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
