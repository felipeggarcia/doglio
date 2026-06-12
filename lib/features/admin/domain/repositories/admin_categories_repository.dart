library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_category.dart';

abstract class AdminCategoriesRepository {
  Future<Either<Failure, List<AdminCategory>>> getCategories({
    String? search,
    bool? isActive,
  });

  Future<Either<Failure, AdminCategory>> createCategory(
      AdminCategory category);

  Future<Either<Failure, AdminCategory>> updateCategory(
      AdminCategory category);

  Future<Either<Failure, Unit>> deleteCategory(String id);
}
