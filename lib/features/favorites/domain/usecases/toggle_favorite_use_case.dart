/// Toggle favorite use case (add or remove)
library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/favorites_repository.dart';

class RemoveFavoriteUseCase {
  const RemoveFavoriteUseCase(this._repository);
  final FavoritesRepository _repository;

  Future<Either<Failure, void>> call(String favoriteId) =>
      _repository.removeFavorite(favoriteId);
}

class AddFavoriteUseCase {
  const AddFavoriteUseCase(this._repository);
  final FavoritesRepository _repository;

  Future<Either<Failure, dynamic>> call(String productId) =>
      _repository.addFavorite(productId: productId);
}
