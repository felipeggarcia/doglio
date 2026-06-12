library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../domain/entities/admin_category.dart';
import '../providers/admin_categories_provider.dart';

/// Listagem de categorias (admin) com busca e filtro de status.
class AdminCategoriesPage extends ConsumerStatefulWidget {
  const AdminCategoriesPage({super.key});

  @override
  ConsumerState<AdminCategoriesPage> createState() =>
      _AdminCategoriesPageState();
}

class _AdminCategoriesPageState extends ConsumerState<AdminCategoriesPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminCategoriesProvider);
    final notifier = ref.read(adminCategoriesProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.adminCategories)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('admin-category-create'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(context.l10n.adminCategoryNew),
      ),
      body: Column(
        children: [
          _SearchField(
            controller: _searchController,
            hint: context.l10n.adminCategoriesSearchHint,
            onChanged: notifier.setSearch,
          ),
          _Filters(state: state, notifier: notifier),
          const Divider(height: 1),
          Expanded(child: _Body(state: state, notifier: notifier)),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          isDense: true,
        ),
      ),
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({required this.state, required this.notifier});

  final AdminCategoriesState state;
  final AdminCategoriesNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _chip(context, l10n.adminFilterAll, state.activeFilter == null,
              () => notifier.setActiveFilter(null)),
          _chip(
            context,
            l10n.adminStatusActive,
            state.activeFilter == true,
            () => notifier
                .setActiveFilter(state.activeFilter == true ? null : true),
          ),
          _chip(
            context,
            l10n.adminStatusInactive,
            state.activeFilter == false,
            () => notifier
                .setActiveFilter(state.activeFilter == false ? null : false),
          ),
        ],
      ),
    );
  }

  Widget _chip(
    BuildContext context,
    String label,
    bool selected,
    VoidCallback onTap,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: scheme.primary,
      backgroundColor: scheme.surfaceContainerHighest,
      labelStyle: TextStyle(
        color: selected ? scheme.onPrimary : scheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide(color: selected ? scheme.primary : scheme.outline),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state, required this.notifier});

  final AdminCategoriesState state;
  final AdminCategoriesNotifier notifier;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && state.categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: notifier.refresh,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(context.l10n.retry),
            ),
          ],
        ),
      );
    }

    if (state.categories.isEmpty) {
      return Center(child: Text(context.l10n.adminCategoriesEmpty));
    }

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: ListView.separated(
        itemCount: state.categories.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) =>
            _CategoryTile(category: state.categories[index]),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});

  final AdminCategory category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.secondaryContainer,
        child: Icon(
          Icons.category_outlined,
          color: theme.colorScheme.onSecondaryContainer,
          size: 20,
        ),
      ),
      title: Text(category.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        l10n.adminCategoryProductsCount(category.productsCount),
        style: theme.textTheme.bodySmall,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (category.isHighlighted)
            Icon(Icons.star, size: 16, color: theme.colorScheme.tertiary),
          const SizedBox(width: 6),
          Icon(
            category.isActive ? Icons.circle : Icons.circle_outlined,
            size: 12,
            color: category.isActive ? Colors.green : theme.disabledColor,
          ),
        ],
      ),
      onTap: () => context.pushNamed(
        'admin-category-edit',
        pathParameters: {'id': category.id},
        extra: category,
      ),
    );
  }
}
