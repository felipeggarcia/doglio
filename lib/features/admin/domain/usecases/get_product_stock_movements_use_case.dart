library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/page_meta.dart';
import '../entities/stock_movement.dart';
import '../repositories/admin_products_repository.dart';

/// Busca o histórico paginado de movimentações de estoque de um produto.
class GetProductStockMovementsUseCase {
  const GetProductStockMovementsUseCase(this._repository);
  final AdminProductsRepository _repository;

  Future<Either<Failure, (List<StockMovement>, PageMeta)>> call(
    String productId, {
    int page = 1,
  }) =>
      _repository.getStockMovements(productId, page: page);
}
