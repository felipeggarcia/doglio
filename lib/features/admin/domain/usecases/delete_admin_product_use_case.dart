library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/admin_products_repository.dart';

/// Remove (soft delete) um produto.
class DeleteAdminProductUseCase {
  const DeleteAdminProductUseCase(this._repository);
  final AdminProductsRepository _repository;

  Future<Either<Failure, Unit>> call(String id) =>
      _repository.deleteProduct(id);
}
