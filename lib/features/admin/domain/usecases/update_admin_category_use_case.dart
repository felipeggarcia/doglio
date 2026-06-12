library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_category.dart';
import '../repositories/admin_categories_repository.dart';

class UpdateAdminCategoryUseCase {
  const UpdateAdminCategoryUseCase(this._repository);
  final AdminCategoriesRepository _repository;

  Future<Either<Failure, AdminCategory>> call(AdminCategory category) =>
      _repository.updateCategory(category);
}
