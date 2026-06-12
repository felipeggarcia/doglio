/// Contrato do repositório de produtos admin.
///
/// Imagens novas trafegam como caminhos de arquivo (`List<String>`) para o
/// domínio não depender de image_picker; a página converte `XFile.path`.
library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_product.dart';
import '../entities/admin_product_filters.dart';
import '../entities/page_meta.dart';
import '../entities/stock_movement.dart';

abstract class AdminProductsRepository {
  /// Lista paginada de produtos (inclui inativos + estoque).
  Future<Either<Failure, (List<AdminProduct>, PageMeta)>> getProducts({
    AdminProductFilters filters,
    int page,
  });

  /// Cria um produto (multipart). Estoque inicial é sempre 0 no backend.
  Future<Either<Failure, AdminProduct>> createProduct(
    AdminProduct product, {
    required List<String> newImagePaths,
  });

  /// Atualiza um produto (multipart), podendo anexar imagens novas,
  /// remover existentes e reordenar por id (position 0 = capa).
  Future<Either<Failure, AdminProduct>> updateProduct(
    AdminProduct product, {
    required List<String> newImagePaths,
    required List<String> removeImageIds,
    List<String> imageOrder = const [],
  });

  /// Soft delete.
  Future<Either<Failure, Unit>> deleteProduct(String id);

  /// Histórico paginado de movimentações de estoque.
  Future<Either<Failure, (List<StockMovement>, PageMeta)>> getStockMovements(
    String productId, {
    int page,
  });

  /// Movimenta o estoque: modo delta (`type` + `quantity`) OU absoluto
  /// (`absolute`). Exatamente um dos modos deve ser informado.
  Future<Either<Failure, StockMovement>> adjustStock(
    String productId, {
    StockMovementType? type,
    int? quantity,
    int? absolute,
    StockMovementReason reason,
    String? notes,
  });
}
