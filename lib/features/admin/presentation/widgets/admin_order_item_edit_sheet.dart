library;

import 'package:flutter/material.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../domain/entities/admin_order.dart';

/// Bottom sheet para editar a quantidade de um item existente ou removê-lo.
///
/// Retorna via [Navigator.pop]:
/// - `_ItemEditResult(quantity: n)` para atualizar a qtd
/// - `_ItemEditResult(remove: true)` para remover
class AdminOrderItemEditSheet extends StatefulWidget {
  const AdminOrderItemEditSheet({super.key, required this.item});

  final AdminOrderItem item;

  @override
  State<AdminOrderItemEditSheet> createState() =>
      _AdminOrderItemEditSheetState();
}

class _AdminOrderItemEditSheetState
    extends State<AdminOrderItemEditSheet> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.item.quantity;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.adminOrderEditItem,
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                widget.item.productName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.filled(
                    icon: const Icon(Icons.remove),
                    onPressed: _quantity > 1
                        ? () => setState(() => _quantity--)
                        : null,
                    style: IconButton.styleFrom(
                      backgroundColor: scheme.surfaceContainerHighest,
                      foregroundColor: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Text(
                    '$_quantity',
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 24),
                  IconButton.filled(
                    icon: const Icon(Icons.add),
                    onPressed: () => setState(() => _quantity++),
                    style: IconButton.styleFrom(
                      backgroundColor: scheme.primary,
                      foregroundColor: scheme.onPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(
                    context,
                    _ItemEditResult(quantity: _quantity),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.primary,
                    foregroundColor: scheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(l10n.save),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: scheme.error,
                  ),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(ctx.l10n.adminOrderRemoveItem),
                        content:
                            Text(ctx.l10n.adminOrderRemoveItemConfirm),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text(ctx.l10n.cancel),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: Text(ctx.l10n.adminOrderRemoveItem),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true && context.mounted) {
                      Navigator.pop(
                          context, const _ItemEditResult(remove: true));
                    }
                  },
                  child: Text(l10n.adminOrderRemoveItem),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemEditResult {
  const _ItemEditResult({this.quantity, this.remove = false});
  final int? quantity;
  final bool remove;
}

typedef ItemEditResult = _ItemEditResult;
