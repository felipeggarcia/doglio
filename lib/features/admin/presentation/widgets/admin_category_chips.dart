/// Chips de seleção múltipla de categorias admin.
///
/// Alimentado pelo [adminCategoriesProvider] (lista completa, inclui
/// inativas). Usado no form de produto e no sheet de filtros.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../providers/admin_categories_provider.dart';

class AdminCategoryChips extends ConsumerWidget {
  const AdminCategoryChips({
    super.key,
    required this.selected,
    required this.onToggle,
    this.enabled = true,
  });

  final Set<String> selected;
  final ValueChanged<String> onToggle;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminCategoriesProvider);

    if (state.isLoading && state.categories.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    if (state.categories.isEmpty) {
      return Text(
        context.l10n.adminCategoriesEmpty,
        style: Theme.of(context).textTheme.bodySmall,
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final category in state.categories)
          FilterChip(
            label: Text(category.name),
            selected: selected.contains(category.id),
            onSelected: enabled ? (_) => onToggle(category.id) : null,
          ),
      ],
    );
  }
}
