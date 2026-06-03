library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class SyncCartUseCase {
  const SyncCartUseCase(this._repository);
  final CartRepository _repository;

  Future<Either<Failure, Cart>> call(List<Map<String, dynamic>> items) =>
      _repository.syncCart(items);
}
