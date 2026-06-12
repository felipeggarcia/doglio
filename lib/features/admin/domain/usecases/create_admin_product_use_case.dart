library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_product.dart';
import '../repositories/admin_products_repository.dart';

/// Cria um produto com imagens (multipart).
class CreateAdminProductUseCase {
  const CreateAdminProductUseCase(this._repository);
  final AdminProductsRepository _repository;

  Future<Either<Failure, AdminProduct>> call(
    AdminProduct product, {
    List<String> newImagePaths = const [],
  }) =>
      _repository.createProduct(product, newImagePaths: newImagePaths);
}
