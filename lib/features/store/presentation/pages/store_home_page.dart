library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/router.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../providers/store_notifier.dart';
import '../widgets/app_drawer.dart';
import '../widgets/product_card.dart';

class StoreHomePage extends ConsumerStatefulWidget {
  const StoreHomePage({super.key});

  @override
  ConsumerState<StoreHomePage> createState() => _StoreHomePageState();
}

class _StoreHomePageState extends ConsumerState<StoreHomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = ref.watch(storeProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: ref.watch(authProvider).valueOrNull is Authenticated
          ? const AppDrawer()
          : const SizedBox.shrink(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo/logo.png',
              height: 32,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
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
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {},
          ),
          Builder(
            builder: (innerContext) => IconButton(
              icon: const Icon(Icons.person_outline, color: Colors.white),
              onPressed: () {
                if (ref.read(authProvider).valueOrNull is Authenticated) {
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
            color: Theme.of(context).colorScheme.primary,
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
              onSubmitted: (value) =>
                  ref.read(storeProvider.notifier).searchProducts(value),
            ),
          ),

          // Categories
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
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 36,
                  child: store.isLoadingCategories
                      ? const Center(
                          child:
                              CircularProgressIndicator(strokeWidth: 2))
                      : store.categories.isEmpty
                          ? Center(
                              child: Text(context.l10n.noCategoriesAvailable))
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              itemCount: store.categories.length,
                              itemBuilder: (context, index) {
                                final category = store.categories[index];
                                final isSelected =
                                    store.selectedCategoryId == category.id;
                                return _buildCategoryChip(
                                  category.name,
                                  isSelected: isSelected,
                                  onTap: () {
                                    if (isSelected) {
                                      ref
                                          .read(storeProvider.notifier)
                                          .clearFilters();
                                    } else {
                                      ref
                                          .read(storeProvider.notifier)
                                          .filterByCategory(category.id);
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

          // Products
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(storeProvider.notifier).refresh(),
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
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          TextButton.icon(
                            onPressed: () =>
                                ref.read(storeProvider.notifier).clearFilters(),
                            icon: const Icon(Icons.arrow_forward),
                            label: Text(context.l10n.viewAll),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (store.isLoadingProducts)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (store.errorMessage != null)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                size: 48, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(store.errorMessage!),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () =>
                                  ref.read(storeProvider.notifier).refresh(),
                              child: Text(context.l10n.tryAgain),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (store.products.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                          child: Text(context.l10n.noProductsAvailable)),
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
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              ProductCard(product: store.products[index]),
                          childCount: store.products.length,
                        ),
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
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[300]!,
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
}
