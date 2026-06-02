/// Store home page - Main marketplace landing page
///
/// This page displays the product catalog with categories,
/// search functionality, and authentication options.
library;

import 'package:flutter/material.dart';
import '../../../../core/config/router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/product.dart';
import '../providers/store_provider.dart';
import '../widgets/app_drawer.dart';

class StoreHomePage extends StatefulWidget {
  const StoreHomePage({super.key});

  @override
  State<StoreHomePage> createState() => _StoreHomePageState();
}

class _StoreHomePageState extends State<StoreHomePage> {
  final TextEditingController _searchController = TextEditingController();
  late final StoreProvider _storeProvider;

  @override
  void initState() {
    super.initState();
    _storeProvider = StoreProvider.instance;
    // Load data after the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _storeProvider.loadInitialData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _storeProvider,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          endDrawer: ListenableBuilder(
            listenable: AuthProvider.instance,
            builder: (context, _) =>
                AuthProvider.instance.isAuthenticated
                    ? const AppDrawer()
                    : const SizedBox.shrink(),
          ),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.primary,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo/logo.png',
                  height: 32,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(width: 8),
                const Text(
                  'Doglio',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
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
                onPressed: () {
                  // TODO: Navigate to cart
                },
              ),
              Builder(
                builder: (innerContext) => IconButton(
                  icon: const Icon(Icons.person_outline, color: Colors.white),
                  onPressed: () {
                    if (AuthProvider.instance.isAuthenticated) {
                      Scaffold.of(innerContext).openEndDrawer();
                    } else {
                      innerContext.pushLogin();
                    }
                  },
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // Search bar
              Container(
                color: AppColors.primary,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: context.l10n.searchProducts,
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onSubmitted: (value) {
                    _storeProvider.searchProducts(value);
                  },
                ),
              ),

              // Categories Section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        context.l10n.categories,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 36,
                      child: _storeProvider.isLoadingCategories
                          ? const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : _storeProvider.categories.isEmpty
                          ? Center(
                              child: Text(context.l10n.noCategoriesAvailable),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              itemCount: _storeProvider.categories.length,
                              itemBuilder: (context, index) {
                                final category =
                                    _storeProvider.categories[index];
                                final isSelected =
                                    _storeProvider.selectedCategoryId ==
                                    category.id;
                                return _buildCategoryChip(
                                  category.name,
                                  isSelected: isSelected,
                                  onTap: () {
                                    if (isSelected) {
                                      _storeProvider.clearFilters();
                                    } else {
                                      _storeProvider.filterByCategory(
                                        category.id,
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Products Section
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await _storeProvider.refresh();
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverToBoxAdapter(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.l10n.featuredProducts,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  _storeProvider.clearFilters();
                                },
                                icon: const Icon(Icons.arrow_forward),
                                label: Text(context.l10n.viewAll),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_storeProvider.isLoadingProducts)
                        const SliverFillRemaining(
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (_storeProvider.error != null)
                        SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 16),
                                Text(_storeProvider.error!),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => _storeProvider.refresh(),
                                  child: Text(context.l10n.tryAgain),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (_storeProvider.products.isEmpty)
                        SliverFillRemaining(
                          child: Center(
                            child: Text(context.l10n.noProductsAvailable),
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          sliver: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 0.62,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final product = _storeProvider.products[index];
                              return _buildProductCard(product);
                            }, childCount: _storeProvider.products.length),
                          ),
                        ),
                      const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip(
    String name, {
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
          ),
        ),
        child: Text(
          name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    final imageUrl = product.primaryImage?.imagePath;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          context.pushProductDetail(product);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem com badges
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Builder(
                              builder: (context) {
                                final fullUrl = ApiConfig.normalizeImageUrl(
                                  imageUrl,
                                );
                                return Image.network(
                                  fullUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  headers: const {
                                    'Host': ApiConfig.virtualHost,
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Icon(
                                        Icons.pets,
                                        size: 48,
                                        color: Colors.grey[400],
                                      ),
                                    );
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Icon(
                              Icons.pets,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                          ),
                  ),
                  // Badge: Fora de estoque
                  if (!product.inStock)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          context.l10n.outOfStock,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  // Badge: Promoção
                  if (product.hasPromotion)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '-${product.promotion!.discountValue.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Info do produto
            Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  // Preço com promoção
                  if (product.hasPromotion) ...[
                    Text(
                      'R\$ ${product.price}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    Text(
                      'R\$ ${product.displayPrice}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ] else
                    Text(
                      'R\$ ${product.displayPrice}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  // Rating
                  if (product.averageRating != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 11),
                        const SizedBox(width: 2),
                        Text(
                          product.averageRating!.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          ' (${product.reviewsCount})',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
