library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../domain/entities/admin_product.dart';
import '../../domain/entities/admin_product_filters.dart';
import '../providers/admin_products_provider.dart';
import '../widgets/admin_product_filters_sheet.dart';

/// Listagem de produtos (admin) com busca, filtros e paginação.
class AdminProductsPage extends ConsumerStatefulWidget {
  const AdminProductsPage({super.key});

  @override
  ConsumerState<AdminProductsPage> createState() => _AdminProductsPageState();
}

class _AdminProductsPageState extends ConsumerState<AdminProductsPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminProductsProvider);
    final notifier = ref.read(adminProductsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.adminProducts)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('admin-product-create'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(context.l10n.adminProductNew),
      ),
      body: Column(
        children: [
          _SearchField(
            controller: _searchController,
            hint: context.l10n.adminProductsSearchHint,
            onChanged: notifier.setSearch,
          ),
          _Filters(state: state, notifier: notifier),
          const Divider(height: 1),
          Expanded(child: _Body(state: state, notifier: notifier)),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          isDense: true,
        ),
      ),
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({required this.state, required this.notifier});

  final AdminProductsState state;
  final AdminProductsNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final filters = state.filters;
    // Linha 1: status. Linha 2: chips rápidos + botão de filtros avançados.
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip(context, l10n.adminFilterAll, filters.isActive == null,
                  () => notifier.setActiveFilter(null)),
              _chip(context, l10n.adminStatusActive, filters.isActive == true,
                  () => notifier
                      .setActiveFilter(filters.isActive == true ? null : true)),
              _chip(context, l10n.adminStatusInactive,
                  filters.isActive == false,
                  () => notifier.setActiveFilter(
                      filters.isActive == false ? null : false)),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip(context, l10n.adminProductFilterHighlighted,
                  filters.isHighlighted == true,
                  notifier.toggleHighlightedFilter),
              _chip(context, l10n.adminProductFilterOutOfStock,
                  filters.outOfStock == true, notifier.toggleOutOfStockFilter),
              _AdvancedFiltersChip(state: state, notifier: notifier),
            ],
          ),
        ],
      ),
    );
  }

  /// Chip de filtro com contraste forte: selecionado = preenchido com a cor
  /// primária; não-selecionado = fundo neutro com borda visível.
  Widget _chip(
    BuildContext context,
    String label,
    bool selected,
    VoidCallback onTap,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: scheme.primary,
      backgroundColor: scheme.surfaceContainerHighest,
      labelStyle: TextStyle(
        color: selected ? scheme.onPrimary : scheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide(
        color: selected ? scheme.primary : scheme.outline,
      ),
    );
  }
}

/// Botão "Filtros" que abre o bottom sheet de filtros avançados; fica
/// destacado quando há algum filtro avançado ativo.
class _AdvancedFiltersChip extends StatelessWidget {
  const _AdvancedFiltersChip({required this.state, required this.notifier});

  final AdminProductsState state;
  final AdminProductsNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final active = state.filters.hasAdvancedFilters;

    return ActionChip(
      avatar: Icon(
        Icons.tune,
        size: 18,
        color: active ? scheme.onPrimary : scheme.onSurface,
      ),
      label: Text(context.l10n.adminProductFiltersButton),
      backgroundColor: active ? scheme.primary : scheme.surfaceContainerHighest,
      labelStyle: TextStyle(
        color: active ? scheme.onPrimary : scheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide(color: active ? scheme.primary : scheme.outline),
      onPressed: () async {
        final result = await showModalBottomSheet<AdminProductFilters>(
          context: context,
          isScrollControlled: true,
          builder: (_) => AdminProductFiltersSheet(initial: state.filters),
        );
        if (result == null) return;
        notifier.applyFilters(result);
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state, required this.notifier});

  final AdminProductsState state;
  final AdminProductsNotifier notifier;

  @override
  Widget build(BuildContext context) {
    // Loading inicial (sem dados ainda)
    if (state.isLoading && state.products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Erro sem dados → mensagem + tentar novamente
    if (state.errorMessage != null && state.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: notifier.refresh,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(context.l10n.retry),
            ),
          ],
        ),
      );
    }

    // Lista vazia
    if (state.products.isEmpty) {
      return Center(child: Text(context.l10n.adminProductsEmpty));
    }

    // Lista + botão "carregar mais"
    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: ListView.separated(
        itemCount: state.products.length + (state.hasMore ? 1 : 0),
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          if (index >= state.products.length) {
            return _LoadMoreButton(state: state, notifier: notifier);
          }
          return _ProductTile(product: state.products[index]);
        },
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final AdminProduct product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: _Thumbnail(product: product),
      title: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        'R\$ ${product.price.replaceAll('.', ',')}',
        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StockBadge(quantity: product.stockQuantity),
          const SizedBox(width: 8),
          if (product.isHighlighted)
            Icon(Icons.star, size: 16, color: theme.colorScheme.tertiary),
          const SizedBox(width: 6),
          // Indicador de ativo/inativo
          Icon(
            product.isActive ? Icons.circle : Icons.circle_outlined,
            size: 12,
            color: product.isActive ? Colors.green : theme.disabledColor,
          ),
        ],
      ),
      onTap: () => context.pushNamed(
        'admin-product-edit',
        pathParameters: {'id': product.id},
        extra: product,
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.product});

  final AdminProduct product;

  @override
  Widget build(BuildContext context) {
    final image = product.primaryImage ??
        (product.images.isNotEmpty ? product.images.first : null);
    final scheme = Theme.of(context).colorScheme;

    final fallback = Container(
      width: 48,
      height: 48,
      color: scheme.secondaryContainer,
      child: Icon(
        Icons.inventory_2_outlined,
        size: 22,
        color: scheme.onSecondaryContainer,
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: image == null || image.url.isEmpty
          ? fallback
          : CachedNetworkImage(
              imageUrl: ApiConfig.normalizeImageUrl(image.url),
              httpHeaders: const {'Host': ApiConfig.virtualHost},
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorWidget: (_, _, _) => fallback,
            ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.quantity});

  final int quantity;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = quantity == 0 ? scheme.error : const Color(0xFF0891B2);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        context.l10n.adminProductStockCount(quantity),
        style:
            TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _LoadMoreButton extends StatelessWidget {
  const _LoadMoreButton({required this.state, required this.notifier});

  final AdminProductsState state;
  final AdminProductsNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: state.isLoadingMore
            ? const CircularProgressIndicator()
            : OutlinedButton(
                onPressed: notifier.loadMore,
                child: Text(context.l10n.adminLoadMore),
              ),
      ),
    );
  }
}
