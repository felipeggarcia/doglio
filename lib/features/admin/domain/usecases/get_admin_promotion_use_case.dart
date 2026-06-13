library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_promotion.dart';
import '../repositories/admin_promotions_repository.dart';

class GetAdminPromotionUseCase {
  const GetAdminPromotionUseCase(this._repository);
  final AdminPromotionsRepository _repository;

  Future<Either<Failure, AdminPromotion>> call(String id) =>
      _repository.getPromotion(id);
}
