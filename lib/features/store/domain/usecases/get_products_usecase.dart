/// Use case for getting products (Domain layer)
///
/// This use case encapsulates the business logic for retrieving products.
/// It depends only on the repository interface, not on implementations.
library;

import '../entities/product.dart';
import '../repositories/store_repository.dart';

class GetProductsUseCase {
  final StoreRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<Product>> call({
    String? categoryId,
    bool? isHighlighted,
    String? search,
    int? perPage,
  }) async {
    return await repository.getProducts(
      categoryId: categoryId,
      isHighlighted: isHighlighted,
      search: search,
      perPage: perPage,
    );
  }
}
