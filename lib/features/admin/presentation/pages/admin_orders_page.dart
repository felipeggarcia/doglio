library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../domain/entities/admin_order.dart';
import '../providers/admin_orders_provider.dart';

/// Listagem de pedidos admin com filtros de status, tipo de entrega e período.
class AdminOrdersPage extends ConsumerWidget {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminOrdersProvider);
    final notifier = ref.read(adminOrdersProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.adminOrdersTitle)),
      body: Column(
        children: [
          _Filters(state: state, notifier: notifier),
          const Divider(height: 1),
          Expanded(child: _Body(state: state, notifier: notifier)),
        ],
      ),
    );
  }
}

// ─── Filtros ─────────────────────────────────────────────────────────────────

class _Filters extends StatelessWidget {
  const _Filters({required this.state, required this.notifier});

  final AdminOrdersState state;
  final AdminOrdersNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 8,
              children: [
                _chip(
                  context,
                  l10n.adminOrdersFilterAll,
                  state.statusFilter == null,
                  () => notifier.setStatusFilter(null),
                ),
                for (final s in AdminOrderStatus.values)
                  _chip(
                    context,
                    _statusLabel(context, s),
                    state.statusFilter == s,
                    () => notifier.setStatusFilter(
                        state.statusFilter == s ? null : s),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 8,
              children: [
                _chip(
                  context,
                  l10n.adminOrdersFilterAll,
                  state.deliveryTypeFilter == null,
                  () => notifier.setDeliveryTypeFilter(null),
                ),
                _chip(
                  context,
                  l10n.adminOrdersFilterDelivery,
                  state.deliveryTypeFilter == 'delivery',
                  () => notifier.setDeliveryTypeFilter(
                    state.deliveryTypeFilter == 'delivery' ? null : 'delivery',
                  ),
                ),
                _chip(
                  context,
                  l10n.adminOrdersFilterPickup,
                  state.deliveryTypeFilter == 'pickup',
                  () => notifier.setDeliveryTypeFilter(
                    state.deliveryTypeFilter == 'pickup' ? null : 'pickup',
                  ),
                ),
                _PeriodChip(state: state, notifier: notifier),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
      side: BorderSide(color: selected ? scheme.primary : scheme.outline),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  const _PeriodChip({required this.state, required this.notifier});

  final AdminOrdersState state;
  final AdminOrdersNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasRange = state.dateRange != null;

    return ActionChip(
      avatar: Icon(
        Icons.calendar_today_outlined,
        size: 16,
        color: hasRange ? scheme.onPrimary : scheme.onSurface,
      ),
      label: Text(
        hasRange
            ? '${DateFormat('dd/MM').format(state.dateRange!.start)} – '
                '${DateFormat('dd/MM').format(state.dateRange!.end)}'
            : context.l10n.adminOrdersFilterPeriod,
      ),
      backgroundColor:
          hasRange ? scheme.primary : scheme.surfaceContainerHighest,
      labelStyle: TextStyle(
        color: hasRange ? scheme.onPrimary : scheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide(color: hasRange ? scheme.primary : scheme.outline),
      onPressed: () async {
        final now = DateTime.now();
        final range = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: now,
          initialDateRange: state.dateRange,
        );
        notifier.setDateRange(range);
      },
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _Body extends StatelessWidget {
  const _Body({required this.state, required this.notifier});

  final AdminOrdersState state;
  final AdminOrdersNotifier notifier;

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
          return _OrderTile(order: state.orders[index]);
        },
      ),
    );
  }
}

// ─── Tile ─────────────────────────────────────────────────────────────────────

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order});
  final AdminOrder order;

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
      onTap: () => context.pushNamed(
        'admin-order-detail',
        pathParameters: {'id': order.id},
        extra: order,
      ),
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
