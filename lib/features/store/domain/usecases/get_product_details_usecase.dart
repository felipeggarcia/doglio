/// Use case for getting product details by ID (Domain layer)
library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';
import '../repositories/store_repository.dart';

class GetProductDetailsUseCase {
  final StoreRepository repository;

  GetProductDetailsUseCase(this.repository);

  Future<Either<Failure, Product?>> call(String productId) async {
    final result = await repository.getProducts();
    return result.map((products) {
      try {
        return products.firstWhere((p) => p.id == productId);
      } catch (_) {
        return null;
      }
    });
  }
}
