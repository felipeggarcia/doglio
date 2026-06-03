library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../../domain/entities/product.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<String> get _allImages {
    final images = <String>[];
    for (var image in widget.product.images) {
      if (image.imagePath.isNotEmpty) images.add(image.imagePath);
    }
    if (images.isEmpty && widget.product.primaryImage != null) {
      images.add(widget.product.primaryImage!.imagePath);
    }
    return images;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final images = _allImages;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // AppBar verde — oculta ao rolar, volta ao rolar para cima
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo/logo.png',
                  height: 28,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Doglio',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              _FavoriteButton(product: widget.product),
            ],
          ),

          // Espaçamento entre AppBar e galeria
          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // Galeria de imagens
          SliverToBoxAdapter(
            child: SizedBox(height: 320, child: _buildImageGallery(images)),
          ),

          // Conteúdo do produto
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(theme),
                const Divider(height: 1),
                _buildDescriptionSection(theme),
                const Divider(height: 1),
                if (widget.product.categories.isNotEmpty) ...[
                  _buildCategoriesSection(theme),
                ],
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(theme),
    );
  }

  Widget _buildImageGallery(List<String> images) {
    if (images.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: Center(
          child: Icon(Icons.pets, size: 120, color: Colors.grey[400]),
        ),
      );
    }

    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) => setState(() => _currentImageIndex = index),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return CachedNetworkImage(
              imageUrl: ApiConfig.normalizeImageUrl(images[index]),
              fit: BoxFit.cover,
              httpHeaders: const {'Host': ApiConfig.virtualHost},
              placeholder: (_, _) => Container(
                color: Colors.grey[200],
                child: Center(
                  child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              errorWidget: (_, _, _) => Container(
                color: Colors.grey[200],
                child: Center(
                  child: Icon(Icons.pets, size: 120, color: Colors.grey[400]),
                ),
              ),
            );
          },
        ),

        // Indicadores de página
        if (images.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (index) => GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentImageIndex == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: _currentImageIndex == index
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[400],
                    ),
                  ),
                ),
              ),
            ),
          ),

        // Setas de navegação
        if (images.length > 1) ...[
          if (_currentImageIndex > 0)
            Positioned(
              left: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: Material(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () => _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (_currentImageIndex < images.length - 1)
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: Material(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () => _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildHeaderSection(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (widget.product.hasPromotion) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'R\$ ${widget.product.price}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.grey[500],
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.grey[500],
                      ),
                    ),
                    Text(
                      'R\$ ${widget.product.displayPrice}',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ] else
                Text(
                  'R\$ ${widget.product.displayPrice}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              const Spacer(),
              if (widget.product.isHighlighted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 4),
                      Text(
                        context.l10n.featured,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.categories,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.product.categories.map((category) {
              return Chip(
                label: Text(category.name),
                backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
                side: BorderSide.none,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.description,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.product.description.isNotEmpty
                ? widget.product.description
                : context.l10n.noDescriptionAvailable,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.black87,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: widget.product.inStock
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.l10n.addToCart),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            disabledBackgroundColor: Colors.grey[300],
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.grey[600],
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_cart_outlined, size: 20),
              const SizedBox(width: 8),
              Text(
                widget.product.inStock
                    ? context.l10n.addToCart
                    : context.l10n.unavailable,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoriteButton extends ConsumerWidget {
  const _FavoriteButton({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(
      favoritesProvider.select(
        (state) =>
            state.valueOrNull?.any((f) => f.product.id == product.id) ?? false,
      ),
    );

    return IconButton(
      icon: Icon(
        isFav ? Icons.favorite : Icons.favorite_border,
        color: Colors.white,
      ),
      onPressed: () async {
        try {
          await ref.read(favoritesProvider.notifier).toggle(product.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isFav ? context.l10n.favoriteRemoved : context.l10n.favoriteAdded,
                ),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } catch (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.favoriteUpdateError),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      },
    );
  }
}
