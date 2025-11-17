/// Use case for getting product details by ID (Domain layer)
///
/// This use case encapsulates the business logic for retrieving a single product.
/// It depends only on the repository interface, not on implementations.
library;

import '../entities/product.dart';
import '../repositories/store_repository.dart';

class GetProductDetailsUseCase {
  final StoreRepository repository;

  GetProductDetailsUseCase(this.repository);

  Future<Product?> call(String productId) async {
    final products = await repository.getProducts();

    try {
      return products.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }
}
