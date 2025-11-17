/// Store repository implementation (Data layer)
///
/// This class implements the repository interface defined in the domain layer.
/// It bridges the domain layer with the data layer (datasources).
library;

import '../../domain/entities/product.dart';
import '../../domain/repositories/store_repository.dart';
import '../datasources/store_remote_datasource.dart';

class StoreRepositoryImpl implements StoreRepository {
  final StoreRemoteDatasource remoteDatasource;

  StoreRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<Product>> getProducts({
    String? categoryId,
    bool? isHighlighted,
    String? search,
    int? perPage,
  }) async {
    try {
      final products = await remoteDatasource.getProducts(
        categoryId: categoryId,
        isHighlighted: isHighlighted,
        search: search,
        perPage: perPage,
      );
      // Models extend entities, so they can be returned directly
      return products;
    } catch (e) {
      // In a real app, you might want to handle errors more gracefully
      // or convert them to domain-specific exceptions
      rethrow;
    }
  }

  @override
  Future<List<Category>> getCategories({
    bool? isHighlighted,
    bool withCount = false,
  }) async {
    try {
      final categories = await remoteDatasource.getCategories(
        isHighlighted: isHighlighted,
        withCount: withCount,
      );
      // Models extend entities, so they can be returned directly
      return categories;
    } catch (e) {
      rethrow;
    }
  }
}
