library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/cart_repository.dart';

class ClearCartUseCase {
  const ClearCartUseCase(this._repository);
  final CartRepository _repository;

  Future<Either<Failure, void>> call() => _repository.clearCart();
}
