/// Bottom sheet de filtros avançados da listagem de produtos admin.
///
/// Coleta os valores e devolve o [AdminProductFilters] novo via
/// `Navigator.pop(context, filters)`; quem aplica é a página.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../domain/entities/admin_product_filters.dart';
import '../providers/admin_categories_provider.dart';
import 'admin_category_picker_sheet.dart';

class AdminProductFiltersSheet extends ConsumerStatefulWidget {
  const AdminProductFiltersSheet({super.key, required this.initial});

  final AdminProductFilters initial;

  @override
  ConsumerState<AdminProductFiltersSheet> createState() =>
      _AdminProductFiltersSheetState();
}

class _AdminProductFiltersSheetState
    extends ConsumerState<AdminProductFiltersSheet> {
  late final TextEditingController _priceMin;
  late final TextEditingController _priceMax;
  late Set<String> _categoryIds;
  DateTime? _dateFrom;
  DateTime? _dateTo;
  late AdminProductSort _sortBy;
  late bool _sortDesc;

  @override
  void initState() {
    super.initState();
    final f = widget.initial;
    _priceMin = TextEditingController(text: f.priceMin ?? '');
    _priceMax = TextEditingController(text: f.priceMax ?? '');
    _categoryIds = {...f.categoryIds};
    _dateFrom = f.dateFrom;
    _dateTo = f.dateTo;
    _sortBy = f.sortBy;
    _sortDesc = f.sortDesc;
  }

  @override
  void dispose() {
    _priceMin.dispose();
    _priceMax.dispose();
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.adminProductFiltersTitle,
                  style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
              _CategoryPickerField(
                selectedIds: _categoryIds,
                onApply: (ids) => setState(() => _categoryIds = ids),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _priceMin,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: InputDecoration(
                        labelText: l10n.adminProductFilterPriceMin,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _priceMax,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: InputDecoration(
                        labelText: l10n.adminProductFilterPriceMax,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _DateField(
                      label: l10n.adminProductFilterDateFrom,
                      value: _dateFrom,
                      onChanged: (d) => setState(() => _dateFrom = d),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DateField(
                      label: l10n.adminProductFilterDateTo,
                      value: _dateTo,
                      onChanged: (d) => setState(() => _dateTo = d),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<AdminProductSort>(
                initialValue: _sortBy,
                decoration: InputDecoration(
                  labelText: l10n.adminProductSortBy,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  isDense: true,
                ),
                items: [
                  DropdownMenuItem(
                    value: AdminProductSort.createdAt,
                    child: Text(l10n.adminProductSortCreated),
                  ),
                  DropdownMenuItem(
                    value: AdminProductSort.updatedAt,
                    child: Text(l10n.adminProductSortUpdated),
                  ),
                  DropdownMenuItem(
                    value: AdminProductSort.name,
                    child: Text(l10n.adminProductSortName),
                  ),
                  DropdownMenuItem(
                    value: AdminProductSort.price,
                    child: Text(l10n.adminProductSortPrice),
                  ),
                  DropdownMenuItem(
                    value: AdminProductSort.stockQuantity,
                    child: Text(l10n.adminProductSortStock),
                  ),
                ],
                onChanged: (v) => setState(() => _sortBy = v ?? _sortBy),
              ),
              const SizedBox(height: 12),
              SegmentedButton<bool>(
                segments: [
                  ButtonSegment(
                    value: false,
                    label: Text(l10n.adminProductSortAsc),
                    icon: const Icon(Icons.arrow_upward, size: 16),
                  ),
                  ButtonSegment(
                    value: true,
                    label: Text(l10n.adminProductSortDesc),
                    icon: const Icon(Icons.arrow_downward, size: 16),
                  ),
                ],
                selected: {_sortDesc},
                onSelectionChanged: (s) =>
                    setState(() => _sortDesc = s.first),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  TextButton(
                    onPressed: _clear,
                    child: Text(l10n.adminProductFiltersClear),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _apply,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(l10n.adminProductFiltersApply),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Limpa só os filtros avançados, preservando busca e chips rápidos.
  void _clear() {
    final cleared = AdminProductFilters(
      search: widget.initial.search,
      isActive: widget.initial.isActive,
      isHighlighted: widget.initial.isHighlighted,
      outOfStock: widget.initial.outOfStock,
    );
    Navigator.pop(context, cleared);
  }

  void _apply() {
    String? normalizePrice(String raw) {
      final value = raw.trim().replaceAll(',', '.');
      return value.isEmpty || double.tryParse(value) == null ? null : value;
    }

    final filters = widget.initial.copyWith(
      categoryIds: _categoryIds.toList(),
      priceMin: normalizePrice(_priceMin.text),
      priceMax: normalizePrice(_priceMax.text),
      dateFrom: _dateFrom,
      dateTo: _dateTo,
      sortBy: _sortBy,
      sortDesc: _sortDesc,
    );
    Navigator.pop(context, filters);
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    final text = value == null
        ? ''
        : '${value!.day.toString().padLeft(2, '0')}/'
            '${value!.month.toString().padLeft(2, '0')}/${value!.year}';

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          isDense: true,
          suffixIcon: value == null
              ? const Icon(Icons.calendar_today_outlined, size: 18)
              : IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () => onChanged(null),
                ),
        ),
        child: Text(text.isEmpty ? ' ' : text),
      ),
    );
  }
}

class _CategoryPickerField extends ConsumerWidget {
  const _CategoryPickerField({
    required this.selectedIds,
    required this.onApply,
  });

  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onApply;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final categories = ref.watch(adminCategoriesProvider).categories;
    final names = categories
        .where((c) => selectedIds.contains(c.id))
        .map((c) => c.name)
        .toList();

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final result = await showModalBottomSheet<Set<String>>(
          context: context,
          isScrollControlled: true,
          builder: (_) => AdminCategoryPickerSheet(initial: selectedIds),
        );
        if (result != null) onApply(result);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.adminProductFilterCategories,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: const Icon(Icons.expand_more),
          isDense: true,
        ),
        child: Text(
          names.isEmpty
              ? l10n.adminCategoryNoneSelected
              : names.join(', '),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: names.isEmpty
              ? TextStyle(color: theme.colorScheme.onSurfaceVariant)
              : null,
        ),
      ),
    );
  }
}
