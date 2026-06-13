library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_promotion.dart';
import '../entities/page_meta.dart';
import '../repositories/admin_promotions_repository.dart';

class GetAdminPromotionsUseCase {
  const GetAdminPromotionsUseCase(this._repository);
  final AdminPromotionsRepository _repository;

  Future<Either<Failure, (List<AdminPromotion>, PageMeta)>> call({
    bool? isActive,
    bool? expired,
    String? search,
    List<String>? productIds,
    int page = 1,
  }) =>
      _repository.getPromotions(
        isActive: isActive,
        expired: expired,
        search: search,
        productIds: productIds,
        page: page,
      );
}
