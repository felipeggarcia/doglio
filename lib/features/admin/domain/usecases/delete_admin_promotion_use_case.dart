library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/admin_promotions_repository.dart';

class DeleteAdminPromotionUseCase {
  const DeleteAdminPromotionUseCase(this._repository);
  final AdminPromotionsRepository _repository;

  Future<Either<Failure, Unit>> call(String id) =>
      _repository.deletePromotion(id);
}
