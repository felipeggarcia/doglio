library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../domain/entities/cart_item.dart';
import '../providers/cart_provider.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          context.l10n.cart,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (!cart.isEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white),
              tooltip: context.l10n.clearCart,
              onPressed: () => _confirmClear(context, ref),
            ),
        ],
      ),
      body: cart.isLoading
          ? const Center(child: CircularProgressIndicator())
          : cart.isEmpty
              ? _EmptyCart(onBrowse: () => context.go('/'))
              : _CartContent(cart: cart),
      bottomNavigationBar: cart.isEmpty || cart.isLoading
          ? null
          : _CheckoutBar(total: cart.computedTotal),
    );
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.clearCart),
        content: Text(context.l10n.clearCartConfirm),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(false),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => ctx.pop(true),
            child: Text(
              context.l10n.confirm,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(cartProvider.notifier).clear();
    }
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyCart extends StatelessWidget {
  const _EmptyCart({required this.onBrowse});
  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 96,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.cartEmpty,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.cartEmptySubtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onBrowse,
              icon: const Icon(Icons.storefront_outlined),
              label: Text(context.l10n.continueShopping),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Lista de itens ───────────────────────────────────────────────────────────

class _CartContent extends ConsumerWidget {
  const _CartContent({required this.cart});
  final CartState cart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Banners de aviso
        if (cart.hasStockWarning) _WarningBanner(message: context.l10n.stockWarning, color: Colors.orange),
        if (cart.hasPriceChange) _WarningBanner(message: context.l10n.priceChanged, color: Colors.blue),

        // Indicador de sincronização
        if (cart.isSyncing)
          LinearProgressIndicator(
            minHeight: 2,
            color: Theme.of(context).colorScheme.primary,
            backgroundColor: Colors.transparent,
          ),

        // Lista de itens
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: cart.items.length,
            separatorBuilder: (_, _) => const Divider(height: 1, indent: 16, endIndent: 16),
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return _CartItemTile(
                item: item,
                onRemove: () => ref.read(cartProvider.notifier).removeItem(item.productId),
                onDecrement: () => ref.read(cartProvider.notifier).updateQuantity(
                      item.productId,
                      item.quantity - 1,
                    ),
                onIncrement: () => ref.read(cartProvider.notifier).updateQuantity(
                      item.productId,
                      item.quantity + 1,
                    ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─── Banner de aviso ─────────────────────────────────────────────────────────

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.message, required this.color});
  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: color.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Tile de item do carrinho ─────────────────────────────────────────────────

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({
    required this.item,
    required this.onRemove,
    required this.onDecrement,
    required this.onIncrement,
  });

  final CartItem item;
  final VoidCallback onRemove;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imagePath = item.product.bestImagePath;

    return Dismissible(
      key: ValueKey(item.productId),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red[50],
        child: const Icon(Icons.delete_outline, color: Colors.red, size: 28),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do produto
            _ProductThumbnail(imagePath: imagePath),
            const SizedBox(width: 12),

            // Detalhes
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome
                  Text(
                    item.product.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Preço unitário
                  if (item.hasPromotion) ...[
                    Text(
                      'R\$ ${item.unitPrice}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    Text(
                      'R\$ ${item.displayUnitPrice}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ] else
                    Text(
                      'R\$ ${item.displayUnitPrice}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                  const SizedBox(height: 8),

                  // Controles de quantidade + subtotal
                  Row(
                    children: [
                      // Stepper
                      _QuantityStepper(
                        quantity: item.quantity,
                        onDecrement: onDecrement,
                        onIncrement: onIncrement,
                        primaryColor: theme.colorScheme.primary,
                      ),
                      const Spacer(),
                      // Subtotal
                      Text(
                        'R\$ ${item.subtotal}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Botão remover
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(Icons.close, size: 18, color: Colors.grey[400]),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Thumbnail ────────────────────────────────────────────────────────────────

class _ProductThumbnail extends StatelessWidget {
  const _ProductThumbnail({this.imagePath});
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 72,
        height: 72,
        child: imagePath != null && imagePath!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: ApiConfig.normalizeImageUrl(imagePath!),
                httpHeaders: const {'Host': ApiConfig.virtualHost},
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(color: Colors.grey[100]),
                errorWidget: (_, _, _) => _placeholder(),
              )
            : _placeholder(),
      ),
    );
  }

  Widget _placeholder() => Container(
        color: Colors.grey[100],
        child: Icon(Icons.pets, size: 32, color: Colors.grey[300]),
      );
}

// ─── Stepper de quantidade ────────────────────────────────────────────────────

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
    required this.primaryColor,
  });

  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: Icons.remove,
            onPressed: onDecrement,
            color: quantity <= 1 ? Colors.grey[400]! : primaryColor,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '$quantity',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          _StepButton(icon: Icons.add, onPressed: onIncrement, color: primaryColor),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(7),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

// ─── Barra de checkout ────────────────────────────────────────────────────────

class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar({required this.total});
  final String total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.total,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.black54,
                  ),
                ),
                Text(
                  'R\$ $total',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: navegar para checkout
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  context.l10n.checkout,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
