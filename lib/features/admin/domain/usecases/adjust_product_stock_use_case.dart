library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/stock_movement.dart';
import '../repositories/admin_products_repository.dart';

/// Movimenta o estoque de um produto (modo delta ou absoluto).
class AdjustProductStockUseCase {
  const AdjustProductStockUseCase(this._repository);
  final AdminProductsRepository _repository;

  Future<Either<Failure, StockMovement>> call(
    String productId, {
    StockMovementType? type,
    int? quantity,
    int? absolute,
    StockMovementReason reason = StockMovementReason.manualAdjustment,
    String? notes,
  }) =>
      _repository.adjustStock(
        productId,
        type: type,
        quantity: quantity,
        absolute: absolute,
        reason: reason,
        notes: notes,
      );
}
