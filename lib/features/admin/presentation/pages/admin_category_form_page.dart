library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/widgets/auth_form.dart';
import '../../domain/entities/admin_category.dart';
import '../providers/admin_categories_provider.dart';

/// Formulário compartilhado de criação/edição de categoria.
///
/// `category == null` → modo criação.
/// `category != null` → modo edição (AppBar com ação de excluir).
class AdminCategoryFormPage extends ConsumerStatefulWidget {
  const AdminCategoryFormPage({super.key, this.category});

  final AdminCategory? category;

  @override
  ConsumerState<AdminCategoryFormPage> createState() =>
      _AdminCategoryFormPageState();
}

class _AdminCategoryFormPageState
    extends ConsumerState<AdminCategoryFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late bool _isHighlighted;
  late bool _isActive;
  bool _saving = false;

  bool get _isEditing => widget.category != null;

  @override
  void initState() {
    super.initState();
    final c = widget.category;
    _name = TextEditingController(text: c?.name ?? '');
    _isHighlighted = c?.isHighlighted ?? false;
    _isActive = c?.isActive ?? true;
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? l10n.adminCategoryEditTitle : l10n.adminCategoryCreateTitle,
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
              AuthFormField(
                controller: _name,
                label: l10n.adminFieldName,
                prefixIcon: Icons.label_outline,
                validator: (v) => Validators.name(v, context),
                enabled: !_saving,
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.adminFieldHighlighted),
                secondary: const Icon(Icons.star_outline),
                value: _isHighlighted,
                onChanged:
                    _saving ? null : (v) => setState(() => _isHighlighted = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.adminFieldActive),
                secondary: const Icon(Icons.toggle_on_outlined),
                value: _isActive,
                onChanged:
                    _saving ? null : (v) => setState(() => _isActive = v),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _saving ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
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

  AdminCategory _buildCategory() => AdminCategory(
        id: widget.category?.id ?? '',
        name: _name.text.trim(),
        slug: widget.category?.slug ?? '',
        isHighlighted: _isHighlighted,
        isActive: _isActive,
        productsCount: widget.category?.productsCount ?? 0,
      );

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final notifier = ref.read(adminCategoriesProvider.notifier);
    final category = _buildCategory();
    final result = _isEditing
        ? await notifier.updateCategory(category)
        : await notifier.createCategory(category);

    if (!mounted) return;
    setState(() => _saving = false);

    result.fold(
      (failure) => _snack(failure.userMessage, isError: true),
      (_) {
        _snack(_isEditing
            ? context.l10n.adminCategorySaved
            : context.l10n.adminCategoryCreated);
        context.pop();
      },
    );
  }

  Future<void> _handleDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.delete),
        content: Text(ctx.l10n.adminCategoryDeleteConfirm),
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
        .read(adminCategoriesProvider.notifier)
        .deleteCategory(widget.category!.id);
    if (!mounted) return;
    setState(() => _saving = false);

    result.fold(
      (failure) => _snack(failure.userMessage, isError: true),
      (_) {
        _snack(context.l10n.adminCategoryDeleted);
        context.pop();
      },
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
