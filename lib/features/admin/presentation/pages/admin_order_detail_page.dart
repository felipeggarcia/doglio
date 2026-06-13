library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../domain/entities/admin_order.dart';
import '../providers/admin_orders_provider.dart';
import '../widgets/admin_order_add_item_sheet.dart';
import '../widgets/admin_order_item_edit_sheet.dart';
import '../widgets/admin_order_status_sheet.dart';

class AdminOrderDetailPage extends ConsumerWidget {
  const AdminOrderDetailPage({
    super.key,
    required this.orderId,
    this.order,
  });

  final String orderId;
  final AdminOrder? order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminOrderDetailProvider(orderId));
    final notifier = ref.read(adminOrderDetailProvider(orderId).notifier);
    final current = state.order ?? order;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          current?.orderNumber != null
              ? context.l10n.adminOrderDetailTitle(
                  current!.orderNumber!)
              : context.l10n.adminOrdersTitle,
        ),
        actions: [
          if (current != null && !current.status.isFinal)
            IconButton(
              icon: const Icon(Icons.edit_note_outlined),
              tooltip: context.l10n.adminOrderUpdateStatus,
              onPressed: () =>
                  _openStatusSheet(context, notifier, current.status),
            ),
        ],
      ),
      floatingActionButton: current != null && !current.status.isFinal
          ? FloatingActionButton.extended(
              onPressed: () =>
                  _openStatusSheet(context, notifier, current.status),
              icon: const Icon(Icons.swap_horiz),
              label: Text(context.l10n.adminOrderUpdateStatus),
            )
          : null,
      body: _buildBody(context, state, notifier, current),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AdminOrderDetailState state,
    AdminOrderDetailNotifier notifier,
    AdminOrder? current,
  ) {
    if (state.isLoading && current == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && current == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: notifier.refresh,
              child: Text(context.l10n.retry),
            ),
          ],
        ),
      );
    }

    if (current == null) return const SizedBox.shrink();

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: notifier.refresh,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            children: [
              if (state.errorMessage != null)
                _ErrorBanner(message: state.errorMessage!),
              _CustomerSection(customer: current.customer),
              const _SectionDivider(),
              _ItemsSection(
                order: current,
                notifier: notifier,
              ),
              const _SectionDivider(),
              _FinancialSection(order: current),
              const _SectionDivider(),
              _DeliverySection(order: current),
              if (current.payment != null) ...[
                const _SectionDivider(),
                _PaymentSection(payment: current.payment!),
              ],
              const _SectionDivider(),
              _HistorySection(
                  history: current.statusHistory),
            ],
          ),
        ),
        if (state.isMutating)
          const Positioned.fill(
            child: ColoredBox(
              color: Color(0x55000000),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }

  Future<void> _openStatusSheet(
    BuildContext context,
    AdminOrderDetailNotifier notifier,
    AdminOrderStatus currentStatus,
  ) async {
    final result = await showModalBottomSheet<
        ({AdminOrderStatus status, String? notes})>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) =>
          AdminOrderStatusSheet(currentStatus: currentStatus),
    );
    if (result == null || !context.mounted) return;

    final either = await notifier.updateStatus(
      result.status,
      notes: result.notes,
    );
    if (!context.mounted) return;
    either.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(f.userMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      ),
      (_) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.adminOrderStatusUpdated)),
      ),
    );
  }
}

// ─── Sections ─────────────────────────────────────────────────────────────────

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) =>
      const Divider(height: 32, thickness: 1);
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      );
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(message,
          style: TextStyle(color: scheme.onErrorContainer)),
    );
  }
}

// ─── Customer ─────────────────────────────────────────────────────────────────

class _CustomerSection extends StatelessWidget {
  const _CustomerSection({required this.customer});
  final AdminOrderCustomer customer;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(context.l10n.adminOrderCustomerSection),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(customer.name,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(customer.email,
                style: TextStyle(
                    color: scheme.onSurfaceVariant, fontSize: 13)),
          ],
        ),
      ],
    );
  }
}

// ─── Items ────────────────────────────────────────────────────────────────────

class _ItemsSection extends StatelessWidget {
  const _ItemsSection({required this.order, required this.notifier});
  final AdminOrder order;
  final AdminOrderDetailNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(context.l10n.adminOrderItemsSection),
        for (final item in order.items)
          _ItemTile(
            item: item,
            canEdit: !order.status.isFinal,
            notifier: notifier,
          ),
        if (!order.status.isFinal) ...[
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () =>
                _openAddItemSheet(context, notifier),
            icon: const Icon(Icons.add, size: 18),
            label: Text(context.l10n.adminOrderAddItem),
          ),
        ],
      ],
    );
  }

  Future<void> _openAddItemSheet(
    BuildContext context,
    AdminOrderDetailNotifier notifier,
  ) async {
    final result = await showModalBottomSheet<AddItemResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const AdminOrderAddItemSheet(),
    );
    if (result == null || !context.mounted) return;
    final either = await notifier.addItem(
      productId: result.productId,
      quantity: result.quantity,
    );
    if (!context.mounted) return;
    either.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(f.userMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      ),
      (_) {},
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({
    required this.item,
    required this.canEdit,
    required this.notifier,
  });
  final AdminOrderItem item;
  final bool canEdit;
  final AdminOrderDetailNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _thumbnail(item.productImageUrl),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.productName,
                    style:
                        const TextStyle(fontWeight: FontWeight.w600)),
                Text(
                  '${item.quantity} × R\$ ${item.unitPrice} = R\$ ${item.subtotal}',
                  style: TextStyle(
                      color: scheme.onSurfaceVariant, fontSize: 13),
                ),
              ],
            ),
          ),
          if (canEdit)
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: () => _openEditSheet(context),
            ),
        ],
      ),
    );
  }

  Widget _thumbnail(String? url) {
    if (url == null || url.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: const SizedBox(
          width: 48,
          height: 48,
          child: Icon(Icons.inventory_2_outlined),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: CachedNetworkImage(
        imageUrl: ApiConfig.normalizeImageUrl(url),
        httpHeaders: const {'Host': ApiConfig.virtualHost},
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        errorWidget: (_, _, _) =>
            const Icon(Icons.inventory_2_outlined, size: 48),
      ),
    );
  }

  Future<void> _openEditSheet(BuildContext context) async {
    final result = await showModalBottomSheet<ItemEditResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => AdminOrderItemEditSheet(item: item),
    );
    if (result == null || !context.mounted) return;

    if (result.remove) {
      await notifier.removeItem(item.id);
    } else if (result.quantity != null) {
      final either = await notifier.updateItem(
        item.id,
        quantity: result.quantity!,
      );
      if (!context.mounted) return;
      either.fold(
        (f) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(f.userMessage),
            backgroundColor:
                Theme.of(context).colorScheme.error,
          ),
        ),
        (_) {},
      );
    }
  }
}

// ─── Financial ────────────────────────────────────────────────────────────────

class _FinancialSection extends StatelessWidget {
  const _FinancialSection({required this.order});
  final AdminOrder order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(context.l10n.adminOrderSubtotal),
        if (order.hasDiscount) ...[
          _row(
            context,
            context.l10n.adminOrderDiscount,
            '- R\$ ${order.discountAmount}',
            valueColor: Colors.green.shade700,
          ),
        ],
        _row(
          context,
          context.l10n.adminOrderTotal,
          'R\$ ${order.totalAmount}',
          valueStyle: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: scheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _row(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
    TextStyle? valueStyle,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: scheme.onSurfaceVariant)),
          Text(
            value,
            style: valueStyle ??
                TextStyle(
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? scheme.onSurface),
          ),
        ],
      ),
    );
  }
}

// ─── Delivery ─────────────────────────────────────────────────────────────────

class _DeliverySection extends StatelessWidget {
  const _DeliverySection({required this.order});
  final AdminOrder order;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(context.l10n.adminOrderDeliverySection),
        Row(
          children: [
            Icon(
              order.isDelivery
                  ? Icons.local_shipping_outlined
                  : Icons.store_outlined,
              size: 18,
              color: scheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              order.isDelivery
                  ? context.l10n.adminOrderDeliveryLabel
                  : context.l10n.adminOrderPickupLabel,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        if (order.isDelivery && order.shippingAddress != null) ...[
          const SizedBox(height: 8),
          Text(
            order.shippingAddress!.formatted,
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}

// ─── Payment ──────────────────────────────────────────────────────────────────

class _PaymentSection extends StatelessWidget {
  const _PaymentSection({required this.payment});
  final AdminOrderPaymentInfo payment;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(context.l10n.adminOrderPaymentSection),
        Row(
          children: [
            if (payment.paymentMethodName != null) ...[
              Text(payment.paymentMethodName!,
                  style:
                      const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
            ],
            _PaymentStatusBadge(status: payment.status),
          ],
        ),
        if (payment.amount != null) ...[
          const SizedBox(height: 4),
          Text(
            'R\$ ${payment.amount}',
            style: TextStyle(
                color: scheme.onSurfaceVariant, fontSize: 13),
          ),
        ],
        if (payment.isPix && payment.pixCode != null) ...[
          const SizedBox(height: 12),
          Text(context.l10n.adminOrderPixCode,
              style:
                  const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          _PixCodeRow(code: payment.pixCode!),
          if (payment.pixExpiresAt != null) ...[
            const SizedBox(height: 4),
            Text(
              context.l10n.adminOrderPixExpires(
                DateFormat('dd/MM/yyyy HH:mm')
                    .format(payment.pixExpiresAt!),
              ),
              style: TextStyle(
                  fontSize: 12, color: scheme.onSurfaceVariant),
            ),
          ],
        ],
      ],
    );
  }
}

class _PaymentStatusBadge extends StatelessWidget {
  const _PaymentStatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final label = switch (status) {
      'paid' => l10n.adminOrderPaymentPaid,
      'approved' => l10n.adminOrderPaymentApproved,
      _ => l10n.adminOrderPaymentPending,
    };
    final color = switch (status) {
      'paid' || 'approved' => Colors.green,
      _ => Colors.orange,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600)),
    );
  }
}

class _PixCodeRow extends StatelessWidget {
  const _PixCodeRow({required this.code});
  final String code;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              code,
              style: const TextStyle(
                  fontSize: 12, fontFamily: 'monospace'),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 18),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: code));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Código PIX copiado')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

// ─── History ──────────────────────────────────────────────────────────────────

class _HistorySection extends StatelessWidget {
  const _HistorySection({required this.history});
  final List<AdminOrderStatusEntry> history;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(context.l10n.adminOrderHistorySection),
        for (int i = 0; i < history.length; i++)
          _HistoryEntryTile(
            entry: history[i],
            isLast: i == history.length - 1,
          ),
      ],
    );
  }
}

class _HistoryEntryTile extends StatelessWidget {
  const _HistoryEntryTile({
    required this.entry,
    required this.isLast,
  });
  final AdminOrderStatusEntry entry;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: VerticalDivider(
                      color: scheme.outlineVariant,
                      thickness: 1.5,
                      width: 1.5,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _statusLabel(context, entry.status),
                    style: const TextStyle(
                        fontWeight: FontWeight.w600),
                  ),
                  if (entry.notes != null && entry.notes!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        entry.notes!,
                        style: TextStyle(
                            color: scheme.onSurfaceVariant,
                            fontSize: 13),
                      ),
                    ),
                  Text(
                    DateFormat('dd/MM/yyyy HH:mm')
                        .format(entry.createdAt),
                    style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(BuildContext context, AdminOrderStatus status) {
    final l10n = context.l10n;
    return switch (status) {
      AdminOrderStatus.pending => l10n.adminOrderStatusPending,
      AdminOrderStatus.confirmed => l10n.adminOrderStatusConfirmed,
      AdminOrderStatus.preparing => l10n.adminOrderStatusPreparing,
      AdminOrderStatus.outForDelivery =>
        l10n.adminOrderStatusOutForDelivery,
      AdminOrderStatus.delivered => l10n.adminOrderStatusDelivered,
      AdminOrderStatus.cancelled => l10n.adminOrderStatusCancelled,
    };
  }
}
