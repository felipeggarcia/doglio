/// Favorites repository implementation
library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/favorite.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_datasource.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  const FavoritesRepositoryImpl(this._datasource);
  final FavoritesRemoteDatasource _datasource;

  @override
  Future<Either<Failure, List<Favorite>>> getFavorites() async {
    try {
      final result = await _datasource.getFavorites();
      return Right(result.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Favorite>> addFavorite({
    required String productId,
    bool notifyOnRestock = false,
  }) async {
    try {
      final result = await _datasource.addFavorite(
        productId: productId,
        notifyOnRestock: notifyOnRestock,
      );
      return Right(result.toEntity());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(String favoriteId) async {
    try {
      await _datasource.removeFavorite(favoriteId);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
