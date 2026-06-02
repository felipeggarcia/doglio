/// Use case for getting products (Domain layer)
library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';
import '../repositories/store_repository.dart';

class GetProductsUseCase {
  final StoreRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<Product>>> call({
    String? categoryId,
    bool? isHighlighted,
    String? search,
    int? perPage,
  }) => repository.getProducts(
    categoryId: categoryId,
    isHighlighted: isHighlighted,
    search: search,
    perPage: perPage,
  );
}
