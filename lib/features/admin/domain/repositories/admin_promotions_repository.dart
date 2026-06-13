library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_promotion.dart';
import '../entities/page_meta.dart';

abstract interface class AdminPromotionsRepository {
  Future<Either<Failure, (List<AdminPromotion>, PageMeta)>> getPromotions({
    bool? isActive,
    bool? expired,
    String? search,
    List<String>? productIds,
    int page = 1,
  });

  Future<Either<Failure, AdminPromotion>> getPromotion(String id);

  Future<Either<Failure, AdminPromotion>> createPromotion(
      AdminPromotion promotion);

  Future<Either<Failure, AdminPromotion>> updatePromotion(
      AdminPromotion promotion);

  Future<Either<Failure, Unit>> deletePromotion(String id);

  Future<Either<Failure, AdminPromotion>> linkProducts(
    String id,
    List<({String productId, int? useLimit})> products,
  );

  Future<Either<Failure, AdminPromotion>> unlinkProducts(
    String id,
    List<String> productIds,
  );
}
