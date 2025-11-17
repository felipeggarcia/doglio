/// Use case for getting categories (Domain layer)
///
/// This use case encapsulates the business logic for retrieving categories.
/// It depends only on the repository interface, not on implementations.
library;

import '../entities/product.dart';
import '../repositories/store_repository.dart';

class GetCategoriesUseCase {
  final StoreRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<Category>> call({
    bool? isHighlighted,
    bool withCount = false,
  }) async {
    return await repository.getCategories(
      isHighlighted: isHighlighted,
      withCount: withCount,
    );
  }
}
