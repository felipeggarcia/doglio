/// Bottom sheet de movimentação de estoque.
///
/// Só coleta os valores e devolve um [StockAdjustResult] via
/// `Navigator.pop`; quem executa o ajuste é a página de estoque.
library;

import 'package:flutter/material.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../domain/entities/stock_movement.dart';

class StockAdjustResult {
  const StockAdjustResult({
    this.type,
    this.quantity,
    this.absolute,
    required this.reason,
    this.notes,
  });

  /// Modo delta: type + quantity. Modo absoluto: absolute.
  final StockMovementType? type;
  final int? quantity;
  final int? absolute;
  final StockMovementReason reason;
  final String? notes;
}

class StockAdjustSheet extends StatefulWidget {
  const StockAdjustSheet({super.key});

  @override
  State<StockAdjustSheet> createState() => _StockAdjustSheetState();
}

class _StockAdjustSheetState extends State<StockAdjustSheet> {
  final _formKey = GlobalKey<FormState>();
  final _quantity = TextEditingController();
  final _notes = TextEditingController();
  bool _absoluteMode = false;
  StockMovementType _type = StockMovementType.stockIn;
  StockMovementReason _reason = StockMovementReason.manualAdjustment;

  @override
  void dispose() {
    _quantity.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Padding(
      // Sobe junto com o teclado.
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.adminProductStockMove,
                    style: theme.textTheme.titleLarge),
                const SizedBox(height: 16),
                SegmentedButton<bool>(
                  segments: [
                    ButtonSegment(
                      value: false,
                      label: Text(l10n.adminProductStockModeDelta),
                      icon: const Icon(Icons.swap_vert, size: 16),
                    ),
                    ButtonSegment(
                      value: true,
                      label: Text(l10n.adminProductStockModeAbsolute),
                      icon: const Icon(Icons.exposure, size: 16),
                    ),
                  ],
                  selected: {_absoluteMode},
                  onSelectionChanged: (s) =>
                      setState(() => _absoluteMode = s.first),
                ),
                const SizedBox(height: 16),
                if (!_absoluteMode) ...[
                  SegmentedButton<StockMovementType>(
                    segments: [
                      ButtonSegment(
                        value: StockMovementType.stockIn,
                        label: Text(l10n.adminProductStockTypeIn),
                        icon: const Icon(Icons.arrow_downward, size: 16),
                      ),
                      ButtonSegment(
                        value: StockMovementType.stockOut,
                        label: Text(l10n.adminProductStockTypeOut),
                        icon: const Icon(Icons.arrow_upward, size: 16),
                      ),
                    ],
                    selected: {_type},
                    onSelectionChanged: (s) => setState(() => _type = s.first),
                  ),
                  const SizedBox(height: 16),
                ],
                TextFormField(
                  controller: _quantity,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.adminProductStockQuantityField,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    isDense: true,
                  ),
                  validator: _validateQuantity,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<StockMovementReason>(
                  initialValue: _reason,
                  decoration: InputDecoration(
                    labelText: l10n.adminProductStockReason,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    isDense: true,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: StockMovementReason.manualAdjustment,
                      child: Text(l10n.adminProductReasonManual),
                    ),
                    DropdownMenuItem(
                      value: StockMovementReason.purchase,
                      child: Text(l10n.adminProductReasonPurchase),
                    ),
                    DropdownMenuItem(
                      value: StockMovementReason.productReturn,
                      child: Text(l10n.adminProductReasonReturn),
                    ),
                    DropdownMenuItem(
                      value: StockMovementReason.loss,
                      child: Text(l10n.adminProductReasonLoss),
                    ),
                  ],
                  onChanged: (v) => setState(() => _reason = v ?? _reason),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notes,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: l10n.adminProductStockNotes,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _confirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: Text(l10n.confirm),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validateQuantity(String? value) {
    final parsed = int.tryParse(value?.trim() ?? '');
    // Delta exige >= 1; absoluto aceita 0.
    final min = _absoluteMode ? 0 : 1;
    if (parsed == null || parsed < min) {
      return context.l10n.adminProductStockQuantityInvalid;
    }
    return null;
  }

  void _confirm() {
    if (!_formKey.currentState!.validate()) return;
    final value = int.parse(_quantity.text.trim());
    final notes = _notes.text.trim();

    Navigator.pop(
      context,
      StockAdjustResult(
        type: _absoluteMode ? null : _type,
        quantity: _absoluteMode ? null : value,
        absolute: _absoluteMode ? value : null,
        reason: _reason,
        notes: notes.isEmpty ? null : notes,
      ),
    );
  }
}
