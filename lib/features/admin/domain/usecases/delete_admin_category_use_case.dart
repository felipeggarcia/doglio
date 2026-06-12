library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/admin_categories_repository.dart';

class DeleteAdminCategoryUseCase {
  const DeleteAdminCategoryUseCase(this._repository);
  final AdminCategoriesRepository _repository;

  Future<Either<Failure, Unit>> call(String id) =>
      _repository.deleteCategory(id);
}
