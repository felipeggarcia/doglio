/// Order detail page
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/order.dart';
import '../providers/orders_provider.dart';
import '../../../../core/utils/l10n_helper.dart';

class OrderDetailPage extends ConsumerWidget {
  const OrderDetailPage({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.orderNumber(orderId)),
      ),
      body: orderAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(e.toString(), textAlign: TextAlign.center),
            ],
          ),
        ),
        data: (order) => _OrderDetailBody(order: order),
      ),
    );
  }
}

class _OrderDetailBody extends StatelessWidget {
  const _OrderDetailBody({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Status card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.orderStatusTitle, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      _statusIcon(order.status),
                      color: _statusColor(order.status),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _statusLabel(order.status, context),
                      style: TextStyle(
                        color: _statusColor(order.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                if (order.trackingCode != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.trackingCodeLabel(order.trackingCode!),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Items
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.orderItems, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                ...order.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.productName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('x${item.quantity}'),
                        const SizedBox(width: 8),
                        Text(
                          'R\$ ${(double.tryParse(item.price)! * item.quantity).toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.l10n.total,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'R\$ ${double.tryParse(order.total)?.toStringAsFixed(2) ?? order.total}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (order.shippingAddress != null) ...[
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.shippingAddress,
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(order.shippingAddress!),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Color _statusColor(OrderStatus status) => switch (status) {
        OrderStatus.pending => Colors.orange,
        OrderStatus.processing => Colors.blue,
        OrderStatus.shipped => Colors.purple,
        OrderStatus.delivered => Colors.green,
        OrderStatus.cancelled => Colors.red,
      };

  IconData _statusIcon(OrderStatus status) => switch (status) {
        OrderStatus.pending => Icons.hourglass_empty,
        OrderStatus.processing => Icons.settings_outlined,
        OrderStatus.shipped => Icons.local_shipping_outlined,
        OrderStatus.delivered => Icons.check_circle_outline,
        OrderStatus.cancelled => Icons.cancel_outlined,
      };

  String _statusLabel(OrderStatus status, BuildContext context) => switch (status) {
        OrderStatus.pending => context.l10n.orderStatusPending,
        OrderStatus.processing => context.l10n.orderStatusProcessing,
        OrderStatus.shipped => context.l10n.orderStatusShipped,
        OrderStatus.delivered => context.l10n.orderStatusDelivered,
        OrderStatus.cancelled => context.l10n.orderStatusCancelled,
      };
}
