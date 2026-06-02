/// Get favorites use case
library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/favorite.dart';
import '../repositories/favorites_repository.dart';

class GetFavoritesUseCase {
  const GetFavoritesUseCase(this._repository);
  final FavoritesRepository _repository;

  Future<Either<Failure, List<Favorite>>> call() =>
      _repository.getFavorites();
}
