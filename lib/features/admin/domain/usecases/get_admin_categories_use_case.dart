library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_category.dart';
import '../repositories/admin_categories_repository.dart';

class GetAdminCategoriesUseCase {
  const GetAdminCategoriesUseCase(this._repository);
  final AdminCategoriesRepository _repository;

  Future<Either<Failure, List<AdminCategory>>> call({
    String? search,
    bool? isActive,
  }) =>
      _repository.getCategories(search: search, isActive: isActive);
}
