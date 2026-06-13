library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../domain/entities/admin_order.dart';
import '../../domain/entities/admin_order_filters.dart';
import '../providers/admin_orders_provider.dart';
import '../widgets/admin_order_filters_sheet.dart';

/// Listagem de pedidos admin com busca, filtro avançado e paginação.
class AdminOrdersPage extends ConsumerStatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  ConsumerState<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends ConsumerState<AdminOrdersPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openDetail(AdminOrder order) async {
    await context.pushNamed(
      'admin-order-detail',
      pathParameters: {'id': order.id},
      extra: order,
    );
    if (!mounted) return;
    await ref.read(adminOrdersProvider.notifier).refresh();
  }

  Future<void> _openFilters(AdminOrdersState state) async {
    final result = await showModalBottomSheet<AdminOrderFilters>(
      context: context,
      isScrollControlled: true,
      builder: (_) => AdminOrderFiltersSheet(initial: state.filters),
    );
    if (!mounted || result == null) return;
    ref.read(adminOrdersProvider.notifier).applyFilters(result);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminOrdersProvider);
    final notifier = ref.read(adminOrdersProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.adminOrdersTitle)),
      body: Column(
        children: [
          _SearchField(
            controller: _searchController,
            hint: context.l10n.adminOrdersSearchHint,
            onChanged: notifier.setSearch,
          ),
          _FiltersRow(
            state: state,
            onFiltersPressed: () => _openFilters(state),
            onClear: () => notifier.applyFilters(
              AdminOrderFilters(search: state.filters.search),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _Body(
              state: state,
              notifier: notifier,
              onOrderTap: _openDetail,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Busca ────────────────────────────────────────────────────────────────────

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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          isDense: true,
        ),
      ),
    );
  }
}

// ─── Linha de filtros ─────────────────────────────────────────────────────────

class _FiltersRow extends StatelessWidget {
  const _FiltersRow({
    required this.state,
    required this.onFiltersPressed,
    required this.onClear,
  });

  final AdminOrdersState state;
  final VoidCallback onFiltersPressed;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final count = state.filters.activeFilterCount;
    final active = count > 0;
    final label = active
        ? '${context.l10n.adminOrdersFiltersButton} ($count)'
        : context.l10n.adminOrdersFiltersButton;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
      child: Row(
        children: [
          ActionChip(
            avatar: Icon(
              Icons.tune,
              size: 18,
              color: active ? scheme.onPrimary : scheme.onSurface,
            ),
            label: Text(label),
            backgroundColor:
                active ? scheme.primary : scheme.surfaceContainerHighest,
            labelStyle: TextStyle(
              color: active ? scheme.onPrimary : scheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            side: BorderSide(color: active ? scheme.primary : scheme.outline),
            onPressed: onFiltersPressed,
          ),
          if (active) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: onClear,
              child: Text(context.l10n.clearFilters),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _Body extends StatelessWidget {
  const _Body({
    required this.state,
    required this.notifier,
    required this.onOrderTap,
  });

  final AdminOrdersState state;
  final AdminOrdersNotifier notifier;
  final void Function(AdminOrder) onOrderTap;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && state.orders.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.orders.isEmpty) {
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
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(context.l10n.retry),
            ),
          ],
        ),
      );
    }

    if (state.orders.isEmpty) {
      return Center(child: Text(context.l10n.adminOrdersEmpty));
    }

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: ListView.separated(
        itemCount: state.orders.length + (state.hasMore ? 1 : 0),
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          if (index == state.orders.length) {
            return _LoadMoreButton(
              isLoading: state.isLoadingMore,
              onPressed: notifier.loadMore,
            );
          }
          return _OrderTile(
            order: state.orders[index],
            onTap: () => onOrderTap(state.orders[index]),
          );
        },
      ),
    );
  }
}

// ─── Tile ─────────────────────────────────────────────────────────────────────

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order, required this.onTap});
  final AdminOrder order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final label =
        order.orderNumber != null ? '#${order.orderNumber}' : order.id;

    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          _StatusBadge(status: order.status),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(order.customer.name),
          Row(
            children: [
              Text(
                'R\$ ${order.totalAmount}',
                style: TextStyle(
                    color: scheme.primary, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 8),
              Icon(
                order.isDelivery
                    ? Icons.local_shipping_outlined
                    : Icons.store_outlined,
                size: 14,
                color: scheme.onSurfaceVariant,
              ),
              const SizedBox(width: 2),
              Text(
                order.isDelivery
                    ? context.l10n.adminOrdersFilterDelivery
                    : context.l10n.adminOrdersFilterPickup,
                style: TextStyle(
                    fontSize: 11, color: scheme.onSurfaceVariant),
              ),
            ],
          ),
          Text(
            DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt),
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
      trailing: const Icon(Icons.chevron_right),
      isThreeLine: true,
      onTap: onTap,
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final AdminOrderStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    final label = _statusLabel(context, status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 11, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  Color _statusColor(AdminOrderStatus status) => switch (status) {
        AdminOrderStatus.pending => Colors.orange,
        AdminOrderStatus.confirmed => Colors.blue,
        AdminOrderStatus.preparing => Colors.purple,
        AdminOrderStatus.outForDelivery => Colors.cyan.shade700,
        AdminOrderStatus.delivered => Colors.green,
        AdminOrderStatus.cancelled => Colors.red,
      };
}

class _LoadMoreButton extends StatelessWidget {
  const _LoadMoreButton(
      {required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : OutlinedButton(
                onPressed: onPressed,
                child: Text(context.l10n.loadMore),
              ),
      ),
    );
  }
}

// ─── Helper ───────────────────────────────────────────────────────────────────

String _statusLabel(BuildContext context, AdminOrderStatus status) {
  final l10n = context.l10n;
  return switch (status) {
    AdminOrderStatus.pending => l10n.adminOrderStatusPending,
    AdminOrderStatus.confirmed => l10n.adminOrderStatusConfirmed,
    AdminOrderStatus.preparing => l10n.adminOrderStatusPreparing,
    AdminOrderStatus.outForDelivery => l10n.adminOrderStatusOutForDelivery,
    AdminOrderStatus.delivered => l10n.adminOrderStatusDelivered,
    AdminOrderStatus.cancelled => l10n.adminOrderStatusCancelled,
  };
}
