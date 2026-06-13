library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../../auth/presentation/widgets/auth_form.dart';
import '../../domain/entities/admin_product.dart';
import '../../domain/entities/admin_promotion.dart';
import '../providers/admin_promotions_provider.dart';
import '../widgets/admin_promotion_link_product_sheet.dart';

class AdminPromotionFormPage extends ConsumerStatefulWidget {
  const AdminPromotionFormPage({
    super.key,
    this.promotion,
    this.initialLinkedProduct,
  });

  final AdminPromotion? promotion;
  final AdminProduct? initialLinkedProduct;

  @override
  ConsumerState<AdminPromotionFormPage> createState() =>
      _AdminPromotionFormPageState();
}

class _AdminPromotionFormPageState
    extends ConsumerState<AdminPromotionFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _discountValue;
  late final TextEditingController _minQuantity;
  late DiscountType _type;
  DateTime? _startsAt;
  DateTime? _endsAt;
  late bool _isActive;
  late List<_LinkedProduct> _linkedProducts;
  bool _saving = false;

  bool get _isEditing => widget.promotion != null;
  bool get _hasInitialProduct =>
      !_isEditing && widget.initialLinkedProduct != null;

  @override
  void initState() {
    super.initState();
    final p = widget.promotion;
    _name = TextEditingController(text: p?.name ?? '');
    _description = TextEditingController(text: p?.description ?? '');
    _discountValue =
        TextEditingController(text: p?.discountValue ?? '');
    _minQuantity =
        TextEditingController(text: '${p?.minQuantity ?? 1}');
    _type = p?.type ?? DiscountType.percentage;
    _startsAt = p?.startsAt;
    _endsAt = p?.endsAt;
    _isActive = p?.isActive ?? true;

    // In edit mode: populate linked products from existing promotion.
    // In create-from-product context: pre-populate with the initial product.
    if (_isEditing && p != null) {
      _linkedProducts = p.products
          .map((pp) => _LinkedProduct(
                id: pp.id,
                name: pp.name,
                useLimitController:
                    TextEditingController(text: pp.useLimit?.toString() ?? ''),
                usesCount: pp.usesCount,
              ))
          .toList();
    } else if (_hasInitialProduct) {
      final ip = widget.initialLinkedProduct!;
      _linkedProducts = [
        _LinkedProduct(
          id: ip.id,
          name: ip.name,
          useLimitController: TextEditingController(),
          usesCount: 0,
          locked: true,
        ),
      ];
    } else {
      _linkedProducts = [];
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _discountValue.dispose();
    _minQuantity.dispose();
    for (final p in _linkedProducts) {
      p.useLimitController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? l10n.adminPromotionEditTitle : l10n.adminPromotionCreateTitle,
        ),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: l10n.delete,
              onPressed: _saving ? null : _handleDelete,
            ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // ─── Campos básicos ───────────────────────────────────────────
              AuthFormField(
                controller: _name,
                label: l10n.adminFieldName,
                prefixIcon: Icons.label_outline,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l10n.nameRequired : null,
                enabled: !_saving,
              ),
              const SizedBox(height: 12),
              AuthFormField(
                controller: _description,
                label: l10n.adminFieldDescription,
                prefixIcon: Icons.notes_outlined,
                enabled: !_saving,
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<DiscountType>(
                initialValue: _type,
                decoration: InputDecoration(
                  labelText: l10n.adminPromotionTypeLabel,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  isDense: true,
                ),
                items: [
                  DropdownMenuItem(
                    value: DiscountType.percentage,
                    child: Text(l10n.adminPromotionTypePercentage),
                  ),
                  DropdownMenuItem(
                    value: DiscountType.fixed,
                    child: Text(l10n.adminPromotionTypeFixed),
                  ),
                ],
                onChanged: _saving
                    ? null
                    : (v) => setState(() => _type = v ?? DiscountType.percentage),
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.adminPromotionDiscountValue,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _discountValue,
                    enabled: !_saving,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) => _validateDiscount(v, l10n),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: !_saving
                              ? scheme.onSurface
                              : scheme.onSurfaceVariant,
                        ),
                    decoration: InputDecoration(
                      prefixIcon: _type == DiscountType.percentage
                          ? Icon(Icons.percent_outlined,
                              color: scheme.onSurfaceVariant)
                          : Padding(
                              padding: const EdgeInsets.all(14),
                              child: Text(
                                'R\$',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: scheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                      filled: true,
                      fillColor: !_saving
                          ? scheme.surfaceContainerHighest
                          : scheme.surfaceContainerHighest
                              .withValues(alpha: 0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: scheme.outline),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: scheme.outline),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: scheme.primary, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: scheme.error),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: scheme.error, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _DateField(
                      label: l10n.adminPromotionStartsAt,
                      value: _startsAt,
                      onChanged: _saving
                          ? null
                          : (d) => setState(() => _startsAt = d),
                      required: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DateField(
                      label: l10n.adminPromotionEndsAt,
                      value: _endsAt,
                      onChanged: _saving
                          ? null
                          : (d) => setState(() => _endsAt = d),
                      required: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AuthFormField(
                controller: _minQuantity,
                label: l10n.adminPromotionMinQuantity,
                prefixIcon: Icons.shopping_cart_outlined,
                keyboardType: TextInputType.number,
                validator: (v) => _validateMinQty(v, l10n),
                enabled: !_saving,
              ),
              const SizedBox(height: 4),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.adminFieldActive),
                secondary: const Icon(Icons.toggle_on_outlined),
                value: _isActive,
                onChanged: _saving
                    ? null
                    : (v) => setState(() => _isActive = v),
              ),
              // ─── Produtos vinculados ──────────────────────────────────────
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                l10n.adminPromotionLinkedProducts,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ..._linkedProducts.map((lp) => _LinkedProductTile(
                    lp: lp,
                    saving: _saving,
                    onRemove: lp.locked
                        ? null
                        : () => setState(() => _linkedProducts.remove(lp)),
                    onUnlink: _isEditing && !lp.locked
                        ? () => _handleUnlink(lp)
                        : null,
                  )),
              if (_linkedProducts.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    l10n.adminProductPromotionsEmpty,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              // Botão adicionar: disponível em criação pura e edição (não quando produto inicial bloqueado)
              if (!_hasInitialProduct)
                TextButton.icon(
                  onPressed: _saving ? null : _handleAddProduct,
                  icon: const Icon(Icons.add),
                  label: Text(l10n.adminPromotionAddProduct),
                ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _saving ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Text(l10n.save),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Validação ─────────────────────────────────────────────────────────────

  String? _validateDiscount(String? v, dynamic l10n) {
    if (v == null || v.trim().isEmpty) return l10n.priceRequired;
    final val = double.tryParse(v.trim().replaceAll(',', '.'));
    if (val == null) return l10n.priceInvalid;
    if (_type == DiscountType.percentage && (val <= 0 || val > 100)) {
      return 'Informe um valor entre 0.01 e 100';
    }
    if (_type == DiscountType.fixed && val <= 0) {
      return 'Informe um valor maior que zero';
    }
    return null;
  }

  String? _validateMinQty(String? v, dynamic l10n) {
    if (v == null || v.trim().isEmpty) return l10n.quantityRequired;
    final qty = int.tryParse(v.trim());
    if (qty == null || qty < 1) return l10n.quantityInvalid;
    return null;
  }

  // ─── Save / Delete ─────────────────────────────────────────────────────────

  AdminPromotion _buildPromotion() {
    // Em criação (todos os contextos), produtos vêm do estado local e são enviados no POST.
    // Em edição, produtos são gerenciados via API (link/unlink); não incluídos no PUT.
    final products = _isEditing
        ? (widget.promotion!.products)
        : _linkedProducts
            .map((lp) => AdminPromotionProduct(
                  id: lp.id,
                  name: lp.name,
                  useLimit: int.tryParse(lp.useLimitController.text.trim()),
                  usesCount: lp.usesCount,
                ))
            .toList();

    return AdminPromotion(
      id: widget.promotion?.id ?? '',
      name: _name.text.trim(),
      description: _description.text.trim().isEmpty
          ? null
          : _description.text.trim(),
      type: _type,
      discountValue:
          _discountValue.text.trim().replaceAll(',', '.'),
      startsAt: _startsAt ?? DateTime.now(),
      endsAt: _endsAt,
      isActive: _isActive,
      isCurrentlyActive: widget.promotion?.isCurrentlyActive ?? false,
      minQuantity: int.tryParse(_minQuantity.text.trim()) ?? 1,
      products: products,
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startsAt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.adminPromotionStartsAt),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    setState(() => _saving = true);

    final notifier = ref.read(adminPromotionsProvider.notifier);
    final promo = _buildPromotion();
    final result = _isEditing
        ? await notifier.updatePromotion(promo)
        : await notifier.createPromotion(promo);

    if (!mounted) return;
    setState(() => _saving = false);

    result.fold(
      (failure) => _snack(failure.userMessage, isError: true),
      (_) {
        _snack(_isEditing
            ? context.l10n.adminPromotionSaved
            : context.l10n.adminPromotionCreated);
        context.pop();
      },
    );
  }

  Future<void> _handleDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.delete),
        content: Text(ctx.l10n.adminPromotionDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(ctx.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(ctx.l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _saving = true);
    final result = await ref
        .read(adminPromotionsProvider.notifier)
        .deletePromotion(widget.promotion!.id);
    if (!mounted) return;
    setState(() => _saving = false);

    result.fold(
      (failure) => _snack(failure.userMessage, isError: true),
      (_) {
        _snack(context.l10n.adminPromotionDeleted);
        context.pop();
      },
    );
  }

  Future<void> _handleAddProduct() async {
    if (_isEditing) {
      // Modo edição: chama a API linkProducts via sheet.
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => AdminPromotionLinkProductSheet(
          promotionId: widget.promotion!.id,
          linkedProductIds: _linkedProducts.map((lp) => lp.id).toSet(),
        ),
      );
      if (!mounted) return;
      await ref.read(adminPromotionsProvider.notifier).refresh();
      final updated = ref
          .read(adminPromotionsProvider)
          .promotions
          .where((p) => p.id == widget.promotion!.id)
          .firstOrNull;
      if (updated != null && mounted) {
        setState(() {
          _linkedProducts = updated.products
              .map((pp) => _LinkedProduct(
                    id: pp.id,
                    name: pp.name,
                    useLimitController: TextEditingController(
                        text: pp.useLimit?.toString() ?? ''),
                    usesCount: pp.usesCount,
                  ))
              .toList();
        });
      }
    } else {
      // Modo criação: adiciona produto ao estado local sem chamar a API.
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => AdminPromotionLinkProductSheet(
          linkedProductIds: _linkedProducts.map((lp) => lp.id).toSet(),
          onProductPicked: (product, useLimit) {
            setState(() {
              _linkedProducts.add(_LinkedProduct(
                id: product.id,
                name: product.name,
                useLimitController:
                    TextEditingController(text: useLimit?.toString() ?? ''),
                usesCount: 0,
              ));
            });
          },
        ),
      );
    }
  }

  Future<void> _handleUnlink(_LinkedProduct lp) async {
    setState(() => _saving = true);
    final result = await ref
        .read(adminPromotionsProvider.notifier)
        .unlinkProducts(widget.promotion!.id, [lp.id]);
    if (!mounted) return;
    setState(() => _saving = false);

    result.fold(
      (failure) => _snack(failure.userMessage, isError: true),
      (updated) => setState(() {
        _linkedProducts =
            updated.products
                .map((pp) => _LinkedProduct(
                      id: pp.id,
                      name: pp.name,
                      useLimitController: TextEditingController(
                          text: pp.useLimit?.toString() ?? ''),
                      usesCount: pp.usesCount,
                    ))
                .toList();
      }),
    );
  }

  void _snack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            isError ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }
}

// ─── Data class for linked product state ─────────────────────────────────────

class _LinkedProduct {
  _LinkedProduct({
    required this.id,
    required this.name,
    required this.useLimitController,
    required this.usesCount,
    this.locked = false,
  });

  final String id;
  final String name;
  final TextEditingController useLimitController;
  final int usesCount;
  final bool locked;
}

// ─── Linked product tile ──────────────────────────────────────────────────────

class _LinkedProductTile extends StatelessWidget {
  const _LinkedProductTile({
    required this.lp,
    required this.saving,
    this.onRemove,
    this.onUnlink,
  });

  final _LinkedProduct lp;
  final bool saving;
  final VoidCallback? onRemove;
  final VoidCallback? onUnlink;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lp.name,
                      style:
                          const TextStyle(fontWeight: FontWeight.w600)),
                  if (!lp.locked) ...[
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: lp.useLimitController,
                        enabled: !saving,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: context.l10n.adminPromotionUseLimit,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                  if (lp.usesCount > 0)
                    Text(
                      context.l10n.adminPromotionUsesCount(lp.usesCount),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
            if (lp.locked)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.lock_outline,
                    size: 16, color: Theme.of(context).disabledColor),
              )
            else if (onUnlink != null)
              IconButton(
                icon: const Icon(Icons.link_off, size: 20),
                tooltip: context.l10n.delete,
                onPressed: saving ? null : onUnlink,
              )
            else if (onRemove != null)
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: saving ? null : onRemove,
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Date field ───────────────────────────────────────────────────────────────

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.required,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?>? onChanged;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final text = value == null
        ? ''
        : DateFormat('dd/MM/yyyy').format(value!);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onChanged == null
          ? null
          : () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: value ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (picked != null) onChanged!(picked);
            },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          isDense: true,
          suffixIcon: value == null
              ? const Icon(Icons.calendar_today_outlined, size: 18)
              : !required
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed:
                          onChanged == null ? null : () => onChanged!(null),
                    )
                  : const Icon(Icons.calendar_today_outlined, size: 18),
        ),
        child: Text(text.isEmpty ? ' ' : text),
      ),
    );
  }
}
