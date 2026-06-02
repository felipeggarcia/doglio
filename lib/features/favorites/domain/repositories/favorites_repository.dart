/// Favorites repository interface
library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/favorite.dart';

abstract interface class FavoritesRepository {
  Future<Either<Failure, List<Favorite>>> getFavorites();
  Future<Either<Failure, Favorite>> addFavorite({
    required String productId,
    bool notifyOnRestock,
  });
  Future<Either<Failure, void>> removeFavorite(String favoriteId);
}
