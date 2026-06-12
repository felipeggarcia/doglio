library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../providers/admin_categories_provider.dart';

/// Bottom sheet de seleção múltipla de categorias com busca por texto.
///
/// Devolve o [Set<String>] de ids selecionados via `Navigator.pop`.
class AdminCategoryPickerSheet extends ConsumerStatefulWidget {
  const AdminCategoryPickerSheet({super.key, required this.initial});

  final Set<String> initial;

  @override
  ConsumerState<AdminCategoryPickerSheet> createState() =>
      _AdminCategoryPickerSheetState();
}

class _AdminCategoryPickerSheetState
    extends ConsumerState<AdminCategoryPickerSheet> {
  late Set<String> _selected;
  final _search = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _selected = {...widget.initial};
    _search.addListener(() {
      setState(() => _query = _search.text.toLowerCase().trim());
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final state = ref.watch(adminCategoriesProvider);

    final filtered = state.categories
        .where(
            (c) => _query.isEmpty || c.name.toLowerCase().contains(_query))
        .toList();

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.72,
      child: Column(
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Text(
              l10n.adminFieldCategories,
              style: theme.textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _search,
              autofocus: true,
              decoration: InputDecoration(
                hintText: l10n.adminCategoriesSearchHint,
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const Divider(height: 1),
          if (state.isLoading && state.categories.isEmpty)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (filtered.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  l10n.adminCategoriesEmpty,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final category = filtered[index];
                  final selected = _selected.contains(category.id);
                  return CheckboxListTile(
                    title: Text(category.name),
                    value: selected,
                    onChanged: (_) => setState(() {
                      if (!_selected.remove(category.id)) {
                        _selected.add(category.id);
                      }
                    }),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: theme.colorScheme.primary,
                  );
                },
              ),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, _selected),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Text(l10n.adminProductFiltersApply),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
