library;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../domain/entities/checkout_result.dart';
import '../../domain/entities/payment.dart';

class PixPage extends StatefulWidget {
  const PixPage({super.key, required this.result});
  final CheckoutResult result;

  @override
  State<PixPage> createState() => _PixPageState();
}

class _PixPageState extends State<PixPage> {
  bool _codeCopied = false;

  Future<void> _copyCode(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (!mounted) return;
    setState(() => _codeCopied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _codeCopied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final result = widget.result;
    final payment = result.payment;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        title: Text(
          context.l10n.pixTitle,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _SuccessHeader(total: result.orderTotal),
            const SizedBox(height: 20),
            _OrderInfoCard(
              displayId: result.displayId,
              total: result.orderTotal,
            ),
            const SizedBox(height: 16),
            if (payment == null)
              _PendingCard()
            else if (payment.isPix)
              _PixSection(
                payment: payment,
                isCopied: _codeCopied,
                onCopy: _copyCode,
              )
            else if (payment.isBoleto)
              _BoletoSection(
                payment: payment,
                isCopied: _codeCopied,
                onCopy: _copyCode,
              )
            else if (payment.isCreditCard)
              _CreditCardSection(payment: payment)
            else
              _PendingCard(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _PixActions(
        onViewOrders: () => context.go('/orders'),
        onContinueShopping: () => context.go('/'),
      ),
    );
  }
}

// ─── Header de sucesso ────────────────────────────────────────────────────────

class _SuccessHeader extends StatelessWidget {
  const _SuccessHeader({required this.total});
  final String total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: Colors.green[50],
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check_circle_outline,
              size: 40, color: Colors.green[600]),
        ),
        const SizedBox(height: 16),
        Text(
          context.l10n.pixSuccessTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.pixSuccessSubtitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54),
        ),
      ],
    );
  }
}

// ─── Card do pedido ───────────────────────────────────────────────────────────

class _OrderInfoCard extends StatelessWidget {
  const _OrderInfoCard({required this.displayId, required this.total});
  final String displayId;
  final String total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.l10n.orderNumber(displayId),
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          Text(
            'R\$ ${double.tryParse(total)?.toStringAsFixed(2) ?? total}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Seção PIX ────────────────────────────────────────────────────────────────

class _PixSection extends StatelessWidget {
  const _PixSection({
    required this.payment,
    required this.isCopied,
    required this.onCopy,
  });
  final Payment payment;
  final bool isCopied;
  final Future<void> Function(String) onCopy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pixCode = payment.pixCode;
    final qrBase64 = payment.pixQrCode;

    return Column(
      children: [
        // QR Code
        if (qrBase64 != null && qrBase64.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'QR Code PIX',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    base64Decode(qrBase64),
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey[100],
                      child: const Icon(Icons.qr_code, size: 80,
                          color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Código copia-e-cola
        if (pixCode != null && pixCode.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.pix,
                        color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      context.l10n.pixCodeLabel,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: SelectableText(
                    pixCode,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => onCopy(pixCode),
                    icon: Icon(isCopied ? Icons.check : Icons.copy_outlined,
                        size: 18),
                    label: Text(isCopied
                        ? context.l10n.pixCopied
                        : context.l10n.pixCopyCode),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCopied
                          ? Colors.green[600]
                          : theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Expiração
        if (payment.pixExpiresAt != null)
          _ExpiryRow(
            icon: Icons.timer_outlined,
            label: 'Expira em: ${_formatDate(payment.pixExpiresAt!)}',
          )
        else
          _ExpiryRow(
            icon: Icons.timer_outlined,
            label: context.l10n.pixExpiresIn,
          ),

        const SizedBox(height: 12),
        _InstructionsCard(text: context.l10n.pixInstructions),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    final d = dt.toLocal();
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')} às ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }
}

// ─── Seção Boleto ──────────────────────────────────────────────────────────────

class _BoletoSection extends StatelessWidget {
  const _BoletoSection({
    required this.payment,
    required this.isCopied,
    required this.onCopy,
  });
  final Payment payment;
  final bool isCopied;
  final Future<void> Function(String) onCopy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final code = payment.boletoCode;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.receipt_long_outlined,
                      color: Colors.blue[700], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Linha Digitável',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (code != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: SelectableText(
                    code,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => onCopy(code),
                    icon: Icon(isCopied ? Icons.check : Icons.copy_outlined,
                        size: 18),
                    label: Text(
                        isCopied ? context.l10n.pixCopied : 'Copiar código'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCopied
                          ? Colors.green[600]
                          : Colors.blue[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (payment.boletoExpiresAt != null) ...[
          const SizedBox(height: 12),
          _ExpiryRow(
            icon: Icons.calendar_today_outlined,
            label:
                'Vencimento: ${_formatDate(payment.boletoExpiresAt!)}',
            color: Colors.orange[700]!,
          ),
        ],
        const SizedBox(height: 12),
        _InstructionsCard(
          text: 'Pague o boleto no seu banco ou casa lotérica até a data de vencimento.',
          color: Colors.blue[50]!,
          iconColor: Colors.blue[700]!,
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    final d = dt.toLocal();
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }
}

// ─── Seção Cartão de Crédito ──────────────────────────────────────────────────

class _CreditCardSection extends StatelessWidget {
  const _CreditCardSection({required this.payment});
  final Payment payment;

  @override
  Widget build(BuildContext context) {
    final brand = payment.cardBrand ?? 'Cartão';
    final last4 = payment.cardLastFour ?? '****';
    final installments = payment.installments ?? 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[800]!, Colors.grey[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.credit_card_outlined,
                  color: Colors.white70, size: 28),
              Text(
                brand,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '**** **** **** $last4',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              letterSpacing: 2,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Parcelas',
                      style: TextStyle(
                          color: Colors.white60, fontSize: 11)),
                  Text(
                    installments == 1
                        ? 'À vista'
                        : '$installments× sem juros',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Status',
                      style: TextStyle(
                          color: Colors.white60, fontSize: 11)),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Pendente',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Card de pagamento pendente ───────────────────────────────────────────────

class _PendingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(Icons.hourglass_top_rounded,
                color: Colors.orange[700], size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pagamento sendo processado...',
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Acesse "Meus Pedidos" em alguns instantes para acompanhar o status do pagamento.',
                  style: TextStyle(color: Colors.orange[700], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Expiração ────────────────────────────────────────────────────────────────

class _ExpiryRow extends StatelessWidget {
  const _ExpiryRow({
    required this.icon,
    required this.label,
    this.color,
  });
  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Colors.grey[500]!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: c),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: c, fontSize: 13)),
      ],
    );
  }
}

// ─── Instruções ───────────────────────────────────────────────────────────────

class _InstructionsCard extends StatelessWidget {
  const _InstructionsCard({
    required this.text,
    this.color,
    this.iconColor,
  });
  final String text;
  final Color? color;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.smartphone_outlined,
              color: iconColor ?? Colors.blue[700], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style:
                  TextStyle(color: iconColor ?? Colors.blue[800], fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Ações finais ─────────────────────────────────────────────────────────────

class _PixActions extends StatelessWidget {
  const _PixActions({
    required this.onViewOrders,
    required this.onContinueShopping,
  });
  final VoidCallback onViewOrders;
  final VoidCallback onContinueShopping;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onViewOrders,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  context.l10n.myOrders,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: onContinueShopping,
                child: Text(context.l10n.continueShopping),
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
