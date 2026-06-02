/// Favorites Riverpod provider
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/favorite.dart';
import '../../data/datasources/favorites_remote_datasource.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../../domain/usecases/get_favorites_use_case.dart';
import '../../domain/usecases/toggle_favorite_use_case.dart';

final favoritesProvider =
    AsyncNotifierProvider<FavoritesNotifier, List<Favorite>>(
  FavoritesNotifier.new,
);

class FavoritesNotifier extends AsyncNotifier<List<Favorite>> {
  late final GetFavoritesUseCase _getFavorites;
  late final AddFavoriteUseCase _addFavorite;
  late final RemoveFavoriteUseCase _removeFavorite;

  @override
  Future<List<Favorite>> build() async {
    final repo = FavoritesRepositoryImpl(FavoritesRemoteDatasource());
    _getFavorites = GetFavoritesUseCase(repo);
    _addFavorite = AddFavoriteUseCase(repo);
    _removeFavorite = RemoveFavoriteUseCase(repo);
    return _load();
  }

  Future<List<Favorite>> _load() async {
    final result = await _getFavorites();
    return result.fold(
      (failure) => throw Exception(failure.userMessage),
      (favorites) => favorites,
    );
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  bool isFavorite(String productId) {
    return state.valueOrNull?.any((f) => f.product.id == productId) ?? false;
  }

  String? favoriteId(String productId) {
    return state.valueOrNull
        ?.where((f) => f.product.id == productId)
        .firstOrNull
        ?.id;
  }

  Future<void> add(String productId) async {
    final result = await _addFavorite(productId);
    result.fold(
      (failure) => throw Exception(failure.userMessage),
      (favorite) {
        final current = state.valueOrNull ?? [];
        state = AsyncData([...current, favorite]);
      },
    );
  }

  Future<void> remove(String favoriteId) async {
    final result = await _removeFavorite(favoriteId);
    result.fold(
      (failure) => throw Exception(failure.userMessage),
      (_) {
        final current = state.valueOrNull ?? [];
        state = AsyncData(
          current.where((f) => f.id != favoriteId).toList(),
        );
      },
    );
  }

  Future<void> toggle(String productId) async {
    if (isFavorite(productId)) {
      final fId = favoriteId(productId);
      if (fId != null) await remove(fId);
    } else {
      await add(productId);
    }
  }
}
