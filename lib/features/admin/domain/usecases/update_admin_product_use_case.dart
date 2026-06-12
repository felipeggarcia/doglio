library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_product.dart';
import '../repositories/admin_products_repository.dart';

/// Atualiza um produto, anexando imagens novas e removendo existentes.
class UpdateAdminProductUseCase {
  const UpdateAdminProductUseCase(this._repository);
  final AdminProductsRepository _repository;

  Future<Either<Failure, AdminProduct>> call(
    AdminProduct product, {
    List<String> newImagePaths = const [],
    List<String> removeImageIds = const [],
    List<String> imageOrder = const [],
  }) =>
      _repository.updateProduct(
        product,
        newImagePaths: newImagePaths,
        removeImageIds: removeImageIds,
        imageOrder: imageOrder,
      );
}
