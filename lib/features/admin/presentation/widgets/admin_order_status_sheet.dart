library;

import 'package:flutter/material.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../domain/entities/admin_order.dart';

/// Bottom sheet para atualizar o status de um pedido.
///
/// Exibe apenas as transições válidas a partir de [currentStatus] e um campo
/// de observações opcional. Retorna o [AdminOrderStatus] escolhido e as notas
/// via [Navigator.pop].
class AdminOrderStatusSheet extends StatefulWidget {
  const AdminOrderStatusSheet({
    super.key,
    required this.currentStatus,
  });

  final AdminOrderStatus currentStatus;

  @override
  State<AdminOrderStatusSheet> createState() => _AdminOrderStatusSheetState();
}

class _AdminOrderStatusSheetState extends State<AdminOrderStatusSheet> {
  final _notes = TextEditingController();
  AdminOrderStatus? _selected;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final nextStatuses = widget.currentStatus.nextAllowed;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.adminOrderUpdateStatus,
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: 16),
              RadioGroup<AdminOrderStatus>(
                groupValue: _selected,
                onChanged: (v) => setState(() => _selected = v),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: nextStatuses
                      .map(
                        (status) => RadioListTile<AdminOrderStatus>(
                          value: status,
                          title: Text(_statusLabel(context, status)),
                          contentPadding: EdgeInsets.zero,
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notes,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: l10n.adminOrderStatusNotes,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selected == null
                      ? null
                      : () {
                          final notes = _notes.text.trim();
                          Navigator.pop(context, (
                            status: _selected!,
                            notes: notes.isEmpty ? null : notes,
                          ));
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.primary,
                    foregroundColor: scheme.onPrimary,
                    disabledBackgroundColor:
                        scheme.surfaceContainerHighest,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(l10n.confirm),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _statusLabel(BuildContext context, AdminOrderStatus status) {
    final l10n = context.l10n;
    return switch (status) {
      AdminOrderStatus.pending => l10n.adminOrderStatusPending,
      AdminOrderStatus.confirmed => l10n.adminOrderConfirm,
      AdminOrderStatus.preparing => l10n.adminOrderStartPreparing,
      AdminOrderStatus.outForDelivery => l10n.adminOrderSendOut,
      AdminOrderStatus.delivered => l10n.adminOrderMarkDelivered,
      AdminOrderStatus.cancelled => l10n.adminOrderCancel,
    };
  }
}
