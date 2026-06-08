library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/checkout_repository.dart';

class ValidateCartUseCase {
  const ValidateCartUseCase(this._repository);
  final CheckoutRepository _repository;

  Future<Either<Failure, bool>> call() => _repository.validateCart();
}
