library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class GetCartUseCase {
  const GetCartUseCase(this._repository);
  final CartRepository _repository;

  Future<Either<Failure, Cart>> call() => _repository.getCart();
}
