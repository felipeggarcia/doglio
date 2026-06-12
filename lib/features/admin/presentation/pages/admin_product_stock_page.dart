library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../domain/entities/admin_product.dart';
import '../../domain/entities/stock_movement.dart';
import '../providers/admin_product_stock_provider.dart';
import '../widgets/stock_adjust_sheet.dart';

/// Histórico e movimentação de estoque de um produto (`/admin/products/:id/stock`).
class AdminProductStockPage extends ConsumerWidget {
  const AdminProductStockPage({
    super.key,
    required this.productId,
    this.product,
  });

  final String productId;

  /// Entidade passada via `extra` na navegação — usada para o nome e o
  /// estoque inicial antes do histórico carregar.
  final AdminProduct? product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminProductStockProvider(productId));
    final notifier = ref.read(adminProductStockProvider(productId).notifier);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminProductStockHistory)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _handleAdjust(context, ref),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.swap_vert),
        label: Text(l10n.adminProductStockMove),
      ),
      body: Column(
        children: [
          _Header(
            productName: product?.name,
            currentStock: state.currentStock ?? product?.stockQuantity,
          ),
          const Divider(height: 1),
          Expanded(child: _Body(state: state, notifier: notifier)),
        ],
      ),
    );
  }

  Future<void> _handleAdjust(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet<StockAdjustResult>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const StockAdjustSheet(),
    );
    if (result == null || !context.mounted) return;

    final either =
        await ref.read(adminProductStockProvider(productId).notifier).adjust(
              type: result.type,
              quantity: result.quantity,
              absolute: result.absolute,
              reason: result.reason,
              notes: result.notes,
            );
    if (!context.mounted) return;

    either.fold(
      (failure) => _snack(context, failure.userMessage, isError: true),
      (_) => _snack(context, context.l10n.adminProductStockSaved),
    );
  }

  void _snack(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }
}

/// Cabeçalho fixo com o nome do produto e o estoque atual.
class _Header extends StatelessWidget {
  const _Header({required this.productName, required this.currentStock});

  final String? productName;
  final int? currentStock;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.secondaryContainer,
            child: Icon(
              Icons.inventory_2_outlined,
              color: theme.colorScheme.onSecondaryContainer,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (productName != null)
                  Text(
                    productName!,
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                Text(
                  currentStock != null
                      ? '${l10n.adminProductStockCurrent}: '
                          '${l10n.adminProductStockCount(currentStock!)}'
                      : l10n.adminProductStockCurrent,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state, required this.notifier});

  final AdminProductStockState state;
  final AdminProductStockNotifier notifier;

  @override
  Widget build(BuildContext context) {
    // Loading inicial (sem dados ainda)
    if (state.isLoading && state.movements.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Erro sem dados → mensagem + tentar novamente
    if (state.errorMessage != null && state.movements.isEmpty) {
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

    // Histórico vazio
    if (state.movements.isEmpty) {
      return Center(child: Text(context.l10n.adminProductStockEmpty));
    }

    // Lista + botão "carregar mais"
    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: ListView.separated(
        itemCount: state.movements.length + (state.hasMore ? 1 : 0),
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          if (index >= state.movements.length) {
            return _LoadMoreButton(state: state, notifier: notifier);
          }
          return _MovementTile(movement: state.movements[index]);
        },
      ),
    );
  }
}

class _MovementTile extends StatelessWidget {
  const _MovementTile({required this.movement});

  final StockMovement movement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isIn = movement.type == StockMovementType.stockIn;
    final color = isIn ? Colors.green : theme.colorScheme.error;

    final reasonLabel = switch (movement.reason) {
      StockMovementReason.purchase => l10n.adminProductReasonPurchase,
      StockMovementReason.productReturn => l10n.adminProductReasonReturn,
      StockMovementReason.manualAdjustment => l10n.adminProductReasonManual,
      StockMovementReason.loss => l10n.adminProductReasonLoss,
    };

    final details = <String>[
      l10n.adminProductStockBeforeAfter(
          movement.stockBefore, movement.stockAfter),
      if (movement.createdAt != null) movement.createdAt!,
      if (movement.performedBy != null) movement.performedBy!,
      if (movement.notes != null && movement.notes!.isNotEmpty)
        movement.notes!,
    ];

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.12),
        child: Icon(
          isIn ? Icons.arrow_downward : Icons.arrow_upward,
          color: color,
          size: 20,
        ),
      ),
      title: Text(
        '${isIn ? '+' : '-'}${movement.quantity} · $reasonLabel',
        style: theme.textTheme.titleSmall,
      ),
      subtitle: Text(
        details.join(' · '),
        style: theme.textTheme.bodySmall,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _LoadMoreButton extends StatelessWidget {
  const _LoadMoreButton({required this.state, required this.notifier});

  final AdminProductStockState state;
  final AdminProductStockNotifier notifier;

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
