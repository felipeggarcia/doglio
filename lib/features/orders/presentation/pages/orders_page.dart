/// Orders list page
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/order.dart';
import '../providers/orders_provider.dart';
import '../../../../core/config/router.dart';
import '../../../../core/utils/l10n_helper.dart';

class OrdersPage extends ConsumerWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.myOrders),
      ),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(e.toString(), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(ordersProvider.notifier).reload(),
                child: Text(context.l10n.tryAgain),
              ),
            ],
          ),
        ),
        data: (orders) {
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.noOrders,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(ordersProvider.notifier).reload(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final order = orders[index];
                return _OrderCard(order: order);
              },
            ),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              _statusColor(order.status).withValues(alpha: 0.15),
          child: Icon(
            _statusIcon(order.status),
            color: _statusColor(order.status),
          ),
        ),
        title: Text(context.l10n.orderNumber(order.id)),
        subtitle: Text(
          _statusLabel(order.status, context),
          style: TextStyle(color: _statusColor(order.status)),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'R\$ ${double.tryParse(order.total)?.toStringAsFixed(2) ?? order.total}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${order.createdAt.day.toString().padLeft(2, '0')}/'
              '${order.createdAt.month.toString().padLeft(2, '0')}/'
              '${order.createdAt.year}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        onTap: () => context.pushOrderDetail(order),
      ),
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
