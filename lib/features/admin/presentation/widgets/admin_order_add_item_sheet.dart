library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../domain/entities/admin_product.dart';
import '../providers/admin_products_provider.dart';

/// Bottom sheet para adicionar um produto ao pedido.
///
/// Retorna via [Navigator.pop] um [AddItemResult] com productId e quantity.
class AdminOrderAddItemSheet extends ConsumerStatefulWidget {
  const AdminOrderAddItemSheet({super.key});

  @override
  ConsumerState<AdminOrderAddItemSheet> createState() =>
      _AdminOrderAddItemSheetState();
}

class _AdminOrderAddItemSheetState
    extends ConsumerState<AdminOrderAddItemSheet> {
  final _search = TextEditingController();
  AdminProduct? _selected;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    // Limpa o filtro de busca ao abrir (não altera outros filtros do provider).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminProductsProvider.notifier).setSearch('');
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final productsState = ref.watch(adminProductsProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.adminOrderAddItem,
                    style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                if (_selected == null) ...[
                  TextField(
                    controller: _search,
                    autofocus: true,
                    onChanged: (v) =>
                        ref.read(adminProductsProvider.notifier).setSearch(v),
                    decoration: InputDecoration(
                      hintText: l10n.adminOrderSearchProduct,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (productsState.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: productsState.products.length,
                        separatorBuilder: (_, _) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final product = productsState.products[index];
                          return _ProductSearchTile(
                            product: product,
                            onTap: () =>
                                setState(() => _selected = product),
                          );
                        },
                      ),
                    ),
                ] else ...[
                  _SelectedProductCard(
                    product: _selected!,
                    onClear: () => setState(() => _selected = null),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filled(
                        icon: const Icon(Icons.remove),
                        onPressed: _quantity > 1
                            ? () => setState(() => _quantity--)
                            : null,
                        style: IconButton.styleFrom(
                          backgroundColor: scheme.surfaceContainerHighest,
                          foregroundColor: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Text(
                        '$_quantity',
                        style: theme.textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 24),
                      IconButton.filled(
                        icon: const Icon(Icons.add),
                        onPressed: () => setState(() => _quantity++),
                        style: IconButton.styleFrom(
                          backgroundColor: scheme.primary,
                          foregroundColor: scheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(
                        context,
                        AddItemResult(
                          productId: _selected!.id,
                          quantity: _quantity,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: scheme.primary,
                        foregroundColor: scheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(l10n.adminOrderAddItem),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductSearchTile extends StatelessWidget {
  const _ProductSearchTile({required this.product, required this.onTap});
  final AdminProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.primaryImage?.url ?? product.images.firstOrNull?.url;
    return ListTile(
      leading: _thumbnail(imageUrl),
      title: Text(product.name),
      subtitle: Text('R\$ ${product.price}'),
      trailing: product.inStock
          ? null
          : Icon(Icons.block,
              color: Theme.of(context).colorScheme.error, size: 18),
      onTap: onTap,
    );
  }

  Widget _thumbnail(String? url) {
    if (url == null || url.isEmpty) {
      return const SizedBox(
        width: 40,
        height: 40,
        child: Icon(Icons.inventory_2_outlined),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: CachedNetworkImage(
        imageUrl: ApiConfig.normalizeImageUrl(url),
        httpHeaders: const {'Host': ApiConfig.virtualHost},
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorWidget: (_, _, _) =>
            const Icon(Icons.inventory_2_outlined, size: 40),
      ),
    );
  }
}

class _SelectedProductCard extends StatelessWidget {
  const _SelectedProductCard(
      {required this.product, required this.onClear});
  final AdminProduct product;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('R\$ ${product.price}',
                    style: TextStyle(color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClear,
          ),
        ],
      ),
    );
  }
}

class AddItemResult {
  const AddItemResult({required this.productId, required this.quantity});
  final String productId;
  final int quantity;
}
