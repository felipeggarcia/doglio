library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_promotion.dart';
import '../repositories/admin_promotions_repository.dart';

class UpdateAdminPromotionUseCase {
  const UpdateAdminPromotionUseCase(this._repository);
  final AdminPromotionsRepository _repository;

  Future<Either<Failure, AdminPromotion>> call(AdminPromotion promotion) =>
      _repository.updatePromotion(promotion);
}
