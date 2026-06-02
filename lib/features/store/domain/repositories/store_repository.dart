/// Store repository interface (Domain layer)
library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';

abstract class StoreRepository {
  Future<Either<Failure, List<Product>>> getProducts({
    String? categoryId,
    bool? isHighlighted,
    String? search,
    int? perPage,
  });

  Future<Either<Failure, List<Category>>> getCategories({
    bool? isHighlighted,
    bool withCount = false,
  });
}
