/// Order detail page
library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/order.dart';
import '../providers/orders_provider.dart';
import '../../../../core/utils/l10n_helper.dart';

class OrderDetailPage extends ConsumerWidget {
  const OrderDetailPage({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final orderAsync = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          context.l10n.orderNumber(orderId), // orderId usado na rota; detail mostra order_number no body
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: orderAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(e.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => ref.invalidate(orderDetailProvider(orderId)),
                  icon: const Icon(Icons.refresh),
                  label: Text(context.l10n.tryAgain),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        data: (order) => _OrderDetailBody(order: order),
      ),
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _OrderDetailBody extends StatelessWidget {
  const _OrderDetailBody({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        _StatusCard(order: order),
        const SizedBox(height: 12),
        if (order.statusHistory.isNotEmpty) ...[
          _StatusTimeline(
            history: order.statusHistory,
            currentStatus: order.status,
          ),
          const SizedBox(height: 12),
        ],
        // Informações de pagamento enquanto pedido pendente
        if (order.status == OrderStatus.pending && order.payment != null) ...[
          _PaymentCard(payment: order.payment!),
          const SizedBox(height: 12),
        ],
        _ItemsCard(order: order),
        const SizedBox(height: 12),
        _OrderInfoCard(order: order),
        if (order.shippingAddress != null) ...[
          const SizedBox(height: 12),
          _ShippingCard(address: order.shippingAddress!),
        ],
        if (order.trackingCode != null) ...[
          const SizedBox(height: 12),
          _TrackingCard(code: order.trackingCode!),
        ],
      ],
    );
  }
}

// ─── Card de status atual ──────────────────────────────────────────────────────

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _statusColor(order.status);

    return _SectionCard(
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(_statusIcon(order.status), color: color, size: 26),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.orderStatusTitle,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.black45,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _statusLabel(order.status, context),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
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
        OrderStatus.pending => Icons.hourglass_empty_rounded,
        OrderStatus.processing => Icons.autorenew_rounded,
        OrderStatus.shipped => Icons.local_shipping_outlined,
        OrderStatus.delivered => Icons.check_circle_outline_rounded,
        OrderStatus.cancelled => Icons.cancel_outlined,
      };

  String _statusLabel(OrderStatus status, BuildContext context) =>
      switch (status) {
        OrderStatus.pending => context.l10n.orderStatusPending,
        OrderStatus.processing => context.l10n.orderStatusProcessing,
        OrderStatus.shipped => context.l10n.orderStatusShipped,
        OrderStatus.delivered => context.l10n.orderStatusDelivered,
        OrderStatus.cancelled => context.l10n.orderStatusCancelled,
      };
}

// ─── Timeline de histórico ────────────────────────────────────────────────────

class _StatusTimeline extends StatelessWidget {
  const _StatusTimeline({
    required this.history,
    required this.currentStatus,
  });
  final List<StatusHistoryEntry> history;
  final OrderStatus currentStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.orderStatusHistory,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black54,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(history.length, (i) {
            final entry = history[i];
            final isLast = i == history.length - 1;
            final color = _statusColor(entry.status);

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Linha vertical + círculo
                  SizedBox(
                    width: 24,
                    child: Column(
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: color.withValues(alpha: 0.3), width: 2),
                          ),
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2,
                              margin:
                                  const EdgeInsets.symmetric(vertical: 2),
                              color: Colors.grey[200],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Texto
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _statusLabel(entry.status, context),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: color,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatDateTime(entry.occurredAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$d/$m/${dt.year} às $h:$min';
  }

  Color _statusColor(OrderStatus status) => switch (status) {
        OrderStatus.pending => Colors.orange,
        OrderStatus.processing => Colors.blue,
        OrderStatus.shipped => Colors.purple,
        OrderStatus.delivered => Colors.green,
        OrderStatus.cancelled => Colors.red,
      };

  String _statusLabel(OrderStatus status, BuildContext context) =>
      switch (status) {
        OrderStatus.pending => context.l10n.orderStatusPending,
        OrderStatus.processing => context.l10n.orderStatusProcessing,
        OrderStatus.shipped => context.l10n.orderStatusShipped,
        OrderStatus.delivered => context.l10n.orderStatusDelivered,
        OrderStatus.cancelled => context.l10n.orderStatusCancelled,
      };
}

// ─── Card de itens ────────────────────────────────────────────────────────────

class _ItemsCard extends StatelessWidget {
  const _ItemsCard({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = order.items.fold<double>(
      0,
      (sum, i) => sum + (double.tryParse(i.price) ?? 0) * i.quantity,
    );
    final total = double.tryParse(order.total) ?? base;
    final shipping = total - base;

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.orderItems,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black54,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 12),
          ...order.items.map((item) => _ItemRow(item: item)),
          const Divider(height: 20),
          if (shipping > 0.01) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(context.l10n.checkoutShippingFee,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                Text('R\$ ${shipping.toStringAsFixed(2)}',
                    style:
                        const TextStyle(fontSize: 13, color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 6),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.total,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'R\$ ${total.toStringAsFixed(2)}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});
  final OrderItem item;

  @override
  Widget build(BuildContext context) {
    final subtotal =
        (double.tryParse(item.price) ?? 0) * item.quantity;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Nome + qty
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => context.pushNamed(
                    'product-detail',
                    pathParameters: {'id': item.productId},
                  ),
                  child: Text(
                    item.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.black87,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.black54,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.quantity} × R\$ ${double.tryParse(item.price)?.toStringAsFixed(2) ?? item.price}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Subtotal
          Text(
            'R\$ ${subtotal.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

}

// ─── Card de informações do pedido ────────────────────────────────────────────

class _OrderInfoCard extends StatelessWidget {
  const _OrderInfoCard({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.orderDetails,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black54,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 10),
          _InfoRow(
            icon: Icons.tag_rounded,
            label: 'Nº do pedido',
            value: order.orderNumber != null
                ? '#${order.orderNumber}'
                : order.id,
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.calendar_today_outlined,
            label: context.l10n.orderDate,
            value: _formatDateTime(order.createdAt),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$d/$m/${dt.year} às $h:$min';
  }
}

// ─── Card de endereço ──────────────────────────────────────────────────────────

class _ShippingCard extends StatelessWidget {
  const _ShippingCard({required this.address});
  final String address;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.shippingAddress,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black54,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_outlined,
                  size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  address,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Card de rastreio ──────────────────────────────────────────────────────────

class _TrackingCard extends StatelessWidget {
  const _TrackingCard({required this.code});
  final String code;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _SectionCard(
      child: Row(
        children: [
          Icon(Icons.local_shipping_outlined,
              size: 22, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.trackingCodeLabel(code),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Row de info ──────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[400]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ─── Card de pagamento (pendente) ─────────────────────────────────────────────

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.payment});
  final OrderPayment payment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.payment_outlined,
                  size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Informações de Pagamento',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                  letterSpacing: 0.4,
                ),
              ),
              const Spacer(),
              _PaymentStatusBadge(status: payment.status),
            ],
          ),
          const SizedBox(height: 14),
          if (payment.isPix) _PixPaymentInfo(payment: payment),
          if (payment.isBoleto) _BoletoPaymentInfo(payment: payment),
          if (payment.isCreditCard) _CardPaymentInfo(payment: payment),
        ],
      ),
    );
  }
}

class _PaymentStatusBadge extends StatelessWidget {
  const _PaymentStatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final isPaid = status == 'paid' || status == 'approved';
    final color = isPaid ? Colors.green : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isPaid ? 'Pago' : 'Aguardando',
        style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}

// PIX ─────────────────────────────────────────────────────────────────────────

class _PixPaymentInfo extends StatelessWidget {
  const _PixPaymentInfo({required this.payment});
  final OrderPayment payment;

  @override
  Widget build(BuildContext context) {
    final qr = payment.pixQrCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (qr != null) ...[
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Builder(builder: (_) {
                try {
                  return Image.memory(
                    base64Decode(qr),
                    width: 180,
                    height: 180,
                    fit: BoxFit.contain,
                  );
                } catch (_) {
                  return const SizedBox.shrink();
                }
              }),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (payment.pixCode != null) ...[
          Text('Código PIX (copia e cola)',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          _CopyableCode(text: payment.pixCode!, maxLines: 2),
          const SizedBox(height: 8),
        ],
        if (payment.pixExpiresAt != null)
          _ExpiryText(
              label: 'Válido até',
              dateTime: payment.pixExpiresAt!),
      ],
    );
  }
}

// Boleto ──────────────────────────────────────────────────────────────────────

class _BoletoPaymentInfo extends StatelessWidget {
  const _BoletoPaymentInfo({required this.payment});
  final OrderPayment payment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(Icons.receipt_long_outlined,
              size: 20, color: Colors.brown[400]),
          const SizedBox(width: 8),
          Text('Boleto Bancário',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.brown[700])),
        ]),
        const SizedBox(height: 10),
        if (payment.boletoCode != null) ...[
          Text('Linha digitável',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          _CopyableCode(text: payment.boletoCode!, maxLines: 3),
          const SizedBox(height: 8),
        ],
        if (payment.boletoExpiresAt != null)
          _ExpiryText(
              label: 'Vencimento',
              dateTime: payment.boletoExpiresAt!),
      ],
    );
  }
}

// Cartão ──────────────────────────────────────────────────────────────────────

class _CardPaymentInfo extends StatelessWidget {
  const _CardPaymentInfo({required this.payment});
  final OrderPayment payment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final installments = payment.installments ?? 1;
    return Row(
      children: [
        Container(
          width: 48,
          height: 32,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.2)),
          ),
          child: Icon(Icons.credit_card_outlined,
              size: 20, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${payment.cardBrand ?? 'Cartão'} •••• ${payment.cardLastFour ?? '****'}',
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87),
              ),
              const SizedBox(height: 2),
              Text(
                installments == 1
                    ? 'À vista'
                    : '$installments× sem juros',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Helpers ─────────────────────────────────────────────────────────────────────

class _CopyableCode extends StatelessWidget {
  const _CopyableCode({required this.text, this.maxLines = 1});
  final String text;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Código copiado!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Icon(Icons.copy_outlined,
                size: 18, color: theme.colorScheme.primary),
          ),
        ],
      ),
    );
  }
}

class _ExpiryText extends StatelessWidget {
  const _ExpiryText({required this.label, required this.dateTime});
  final String label;
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    final d = dateTime.day.toString().padLeft(2, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final h = dateTime.hour.toString().padLeft(2, '0');
    final min = dateTime.minute.toString().padLeft(2, '0');
    return Text(
      '$label: $d/$m/${dateTime.year} às $h:$min',
      style: TextStyle(
          fontSize: 12,
          color: Colors.orange[700],
          fontWeight: FontWeight.w500),
    );
  }
}

// ─── Card genérico ────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
