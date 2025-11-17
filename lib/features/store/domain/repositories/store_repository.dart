/// Store repository interface (Domain layer)
///
/// This interface defines the contract for store data operations.
/// It belongs to the domain layer and should not depend on any implementation details.
library;

import '../entities/product.dart';

abstract class StoreRepository {
  /// Get products with optional filters
  Future<List<Product>> getProducts({
    String? categoryId,
    bool? isHighlighted,
    String? search,
    int? perPage,
  });

  /// Get categories with optional filters
  Future<List<Category>> getCategories({
    bool? isHighlighted,
    bool withCount = false,
  });
}
