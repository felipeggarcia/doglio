/// Favorites page
library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorites_provider.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/config/router.dart';
import '../../../../core/utils/l10n_helper.dart';

Widget _buildProductImage(String? imagePath) {
  if (imagePath == null || imagePath.isEmpty) {
    return const Icon(Icons.pets, size: 56, color: Colors.grey);
  }
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: CachedNetworkImage(
      imageUrl: ApiConfig.normalizeImageUrl(imagePath),
      width: 56,
      height: 56,
      fit: BoxFit.cover,
      httpHeaders: const {'Host': ApiConfig.virtualHost},
      placeholder: (_, _) => const SizedBox(
        width: 56,
        height: 56,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      errorWidget: (_, _, _) =>
          const Icon(Icons.pets, size: 56, color: Colors.grey),
    ),
  );
}

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.myFavorites),
      ),
      body: favoritesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(e.toString(), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(favoritesProvider.notifier).reload(),
                child: Text(context.l10n.tryAgain),
              ),
            ],
          ),
        ),
        data: (favorites) {
          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.noFavorites,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(favoritesProvider.notifier).reload(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final favorite = favorites[index];
                final product = favorite.product;

                return Dismissible(
                  key: ValueKey(favorite.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    ref
                        .read(favoritesProvider.notifier)
                        .remove(favorite.id);
                  },
                  child: Card(
                    child: ListTile(
                      leading: _buildProductImage(product.bestImagePath),
                      title: Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        'R\$ ${double.tryParse(product.effectivePrice ?? product.price)?.toStringAsFixed(2) ?? product.price}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          ref
                              .read(favoritesProvider.notifier)
                              .remove(favorite.id);
                        },
                      ),
                      onTap: () => context.pushProductDetail(product),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
