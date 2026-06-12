library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_product.dart';
import '../entities/admin_product_filters.dart';
import '../entities/page_meta.dart';
import '../repositories/admin_products_repository.dart';

/// Busca a lista paginada de produtos com filtros.
class GetAdminProductsUseCase {
  const GetAdminProductsUseCase(this._repository);
  final AdminProductsRepository _repository;

  Future<Either<Failure, (List<AdminProduct>, PageMeta)>> call({
    AdminProductFilters filters = AdminProductFilters.empty,
    int page = 1,
  }) =>
      _repository.getProducts(filters: filters, page: page);
}
