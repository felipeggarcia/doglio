/// Use case for getting categories (Domain layer)
library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';
import '../repositories/store_repository.dart';

class GetCategoriesUseCase {
  final StoreRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<Either<Failure, List<Category>>> call({
    bool? isHighlighted,
    bool withCount = false,
  }) => repository.getCategories(
    isHighlighted: isHighlighted,
    withCount: withCount,
  );
}
