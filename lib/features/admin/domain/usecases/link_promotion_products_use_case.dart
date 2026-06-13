library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_promotion.dart';
import '../repositories/admin_promotions_repository.dart';

class LinkPromotionProductsUseCase {
  const LinkPromotionProductsUseCase(this._repository);
  final AdminPromotionsRepository _repository;

  Future<Either<Failure, AdminPromotion>> call(
    String id,
    List<({String productId, int? useLimit})> products,
  ) =>
      _repository.linkProducts(id, products);
}
