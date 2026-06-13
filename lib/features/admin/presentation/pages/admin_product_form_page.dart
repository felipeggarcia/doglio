library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/widgets/auth_form.dart';
import '../../domain/entities/admin_category.dart';
import '../../domain/entities/admin_product.dart';
import '../providers/admin_categories_provider.dart';
import '../providers/admin_products_provider.dart';
import '../providers/admin_promotions_provider.dart';
import '../widgets/admin_category_picker_sheet.dart';
import '../widgets/admin_product_images_field.dart';

/// Formulário compartilhado de criação/edição de produto.
///
/// `product == null` → modo criação.
/// `product != null` → modo edição (AppBar com excluir, switch de ativo e
/// seção de estoque).
class AdminProductFormPage extends ConsumerStatefulWidget {
  const AdminProductFormPage({super.key, this.product, this.imagePicker});

  final AdminProduct? product;

  /// Injetável para testes; default ImagePicker real.
  final ImagePicker? imagePicker;

  @override
  ConsumerState<AdminProductFormPage> createState() =>
      _AdminProductFormPageState();
}

class _AdminProductFormPageState extends ConsumerState<AdminProductFormPage> {
  static const _maxImages = 6;

  final _formKey = GlobalKey<FormState>();
  late final ImagePicker _picker;
  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _price;
  late bool _isHighlighted;
  late bool _isActive;
  late Set<String> _selectedCategoryIds;
  // Lista unificada: AdminProductImage (existentes) | String (novos paths).
  // A posição 0 é a capa; a ordem é enviada ao backend como image_order[].
  late List<Object> _orderedImages;
  final Set<String> _removeImageIds = {};
  bool _saving = false;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    _picker = widget.imagePicker ?? ImagePicker();
    final p = widget.product;
    _name = TextEditingController(text: p?.name ?? '');
    _description = TextEditingController(text: p?.description ?? '');
    _price = TextEditingController(text: p?.price ?? '');
    _isHighlighted = p?.isHighlighted ?? false;
    _isActive = p?.isActive ?? true;
    _selectedCategoryIds = {...?p?.categories.map((c) => c.id)};
    _orderedImages = List<Object>.from(p?.images ?? const []);
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    final appBar = AppBar(
      title: Text(
        _isEditing ? l10n.adminProductEditTitle : l10n.adminProductCreateTitle,
      ),
      actions: [
        if (_isEditing)
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l10n.delete,
            onPressed: _saving ? null : _handleDelete,
          ),
      ],
      bottom: _isEditing
          ? TabBar(tabs: [
              Tab(text: l10n.adminProductTabData),
              Tab(text: l10n.adminProductTabPromotions),
            ])
          : null,
    );

    final formBody = SafeArea(
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
              const SizedBox(height: 16),
              AuthFormField(
                controller: _description,
                label: l10n.adminFieldDescription,
                prefixIcon: Icons.notes_outlined,
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                validator: (v) => Validators.productDescription(v, context),
                enabled: !_saving,
              ),
              const SizedBox(height: 16),
              AuthFormField(
                controller: _price,
                label: l10n.adminFieldPrice,
                prefixIcon: Icons.attach_money,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                // Input pt-BR usa vírgula; valida já normalizado para ponto.
                validator: (v) =>
                    Validators.price(v?.replaceAll(',', '.'), context),
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
              // POST não aceita is_active — só faz sentido na edição.
              if (_isEditing)
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.adminFieldActive),
                  secondary: const Icon(Icons.toggle_on_outlined),
                  value: _isActive,
                  onChanged:
                      _saving ? null : (v) => setState(() => _isActive = v),
                ),
              const SizedBox(height: 16),
              _CategoryField(
                selectedIds: _selectedCategoryIds,
                onApply: (ids) => setState(() => _selectedCategoryIds = ids),
                enabled: !_saving,
              ),
              const SizedBox(height: 20),
              Text(l10n.adminProductImages, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              AdminProductImagesField(
                orderedImages: _orderedImages,
                removedImageIds: _removeImageIds,
                enabled: !_saving,
                onToggleExisting: (id) => setState(() {
                  if (!_removeImageIds.remove(id)) _removeImageIds.add(id);
                }),
                onRemoveNew: (index) =>
                    setState(() => _orderedImages.removeAt(index)),
                onAddPressed: _handleAddImages,
                onReorder: (oldIndex, newIndex) => setState(() {
                  final item = _orderedImages.removeAt(oldIndex);
                  _orderedImages.insert(newIndex, item);
                }),
              ),
              if (_isEditing) ...[
                const SizedBox(height: 20),
                _StockSection(product: widget.product!, enabled: !_saving),
              ],
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _saving ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
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
      );

    if (_isEditing) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: appBar,
          body: TabBarView(
            children: [
              formBody,
              _ProductPromotionsTab(product: widget.product!),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: appBar,
      body: formBody,
    );
  }

  /// Total efetivo de imagens: todas na lista − marcadas para remoção.
  int get _effectiveImageCount =>
      _orderedImages.length - _removeImageIds.length;

  Future<void> _handleAddImages() async {
    try {
      final picked = await _picker.pickMultiImage(
        imageQuality: 85,
        maxWidth: 1600,
      );
      if (picked.isEmpty || !mounted) return;

      final remaining = _maxImages - _effectiveImageCount;
      if (remaining <= 0) {
        _snack(context.l10n.adminProductImageLimit(_maxImages), isError: true);
        return;
      }
      if (picked.length > remaining) {
        _snack(context.l10n.adminProductImageLimit(_maxImages), isError: true);
      }
      setState(() {
        _orderedImages.addAll(picked.take(remaining).map((x) => x.path));
      });
    } catch (e) {
      if (!mounted) return;
      _snack(e.toString(), isError: true);
    }
  }

  /// Resolve as categorias selecionadas: usa a entidade da lista carregada;
  /// para ids fora dela (ex.: lista falhou), mantém a categoria do produto.
  List<AdminCategory> _selectedCategories() {
    final loaded = ref.read(adminCategoriesProvider).categories;
    final original = widget.product?.categories ?? const <AdminCategory>[];
    return _selectedCategoryIds.map((id) {
      return loaded.firstWhere(
        (c) => c.id == id,
        orElse: () => original.firstWhere(
          (c) => c.id == id,
          orElse: () => AdminCategory(
            id: id,
            name: '',
            slug: '',
            isHighlighted: false,
            isActive: true,
            productsCount: 0,
          ),
        ),
      );
    }).toList();
  }

  AdminProduct _buildProduct() => AdminProduct(
        id: widget.product?.id ?? '',
        name: _name.text.trim(),
        description: _description.text.trim(),
        price: _price.text.trim().replaceAll(',', '.'),
        isHighlighted: _isHighlighted,
        isActive: _isActive,
        inStock: widget.product?.inStock ?? false,
        stockQuantity: widget.product?.stockQuantity ?? 0,
        images: widget.product?.images ?? const [],
        primaryImage: widget.product?.primaryImage,
        categories: _selectedCategories(),
        createdAt: widget.product?.createdAt,
        updatedAt: widget.product?.updatedAt,
      );

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final notifier = ref.read(adminProductsProvider.notifier);
    final product = _buildProduct();
    // Separa novos caminhos e extrai a ordem das existentes (excluindo removidas).
    final newImagePaths = _orderedImages.whereType<String>().toList();
    final imageOrder = _orderedImages
        .whereType<AdminProductImage>()
        .where((img) => !_removeImageIds.contains(img.id))
        .map((img) => img.id)
        .toList();
    final result = _isEditing
        ? await notifier.updateProduct(
            product,
            newImagePaths: newImagePaths,
            removeImageIds: _removeImageIds.toList(),
            imageOrder: imageOrder,
          )
        : await notifier.createProduct(product, newImagePaths: newImagePaths);

    if (!mounted) return;
    setState(() => _saving = false);

    result.fold(
      (failure) => _snack(failure.userMessage, isError: true),
      (_) {
        _snack(_isEditing
            ? context.l10n.adminProductSaved
            : context.l10n.adminProductCreated);
        context.pop();
      },
    );
  }

  Future<void> _handleDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.delete),
        content: Text(ctx.l10n.adminProductDeleteConfirm),
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
        .read(adminProductsProvider.notifier)
        .deleteProduct(widget.product!.id);
    if (!mounted) return;
    setState(() => _saving = false);

    result.fold(
      (failure) => _snack(failure.userMessage, isError: true),
      (_) {
        _snack(context.l10n.adminProductDeleted);
        context.pop();
      },
    );
  }

  void _snack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }
}

/// Campo de seleção de categorias: exibe as selecionadas e abre o picker.
class _CategoryField extends ConsumerWidget {
  const _CategoryField({
    required this.selectedIds,
    required this.onApply,
    this.enabled = true,
  });

  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onApply;
  final bool enabled;

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
      onTap: enabled
          ? () async {
              final result = await showModalBottomSheet<Set<String>>(
                context: context,
                isScrollControlled: true,
                builder: (_) =>
                    AdminCategoryPickerSheet(initial: selectedIds),
              );
              if (result != null) onApply(result);
            }
          : null,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.adminFieldCategories,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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

/// Card de estoque (somente edição): mostra a quantidade atual e leva à
/// página de histórico/movimentação.
class _StockSection extends StatelessWidget {
  const _StockSection({required this.product, required this.enabled});

  final AdminProduct product;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: const Icon(Icons.inventory_2_outlined),
        title: Text(l10n.adminProductStockSection),
        subtitle: Text(l10n.adminProductStockCount(product.stockQuantity)),
        trailing: TextButton(
          onPressed: enabled
              ? () => context.pushNamed(
                    'admin-product-stock',
                    pathParameters: {'id': product.id},
                    extra: product,
                  )
              : null,
          child: Text(l10n.adminProductStockManage),
        ),
      ),
    );
  }
}

// ─── Aba de promoções do produto ──────────────────────────────────────────────

class _ProductPromotionsTab extends ConsumerWidget {
  const _ProductPromotionsTab({required this.product});

  final AdminProduct product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final asyncPromos = ref.watch(adminProductPromotionsProvider(product.id));
    final scheme = Theme.of(context).colorScheme;

    return asyncPromos.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(e.toString(), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => ref
                  .read(adminProductPromotionsProvider(product.id).notifier)
                  .refresh(),
              style: ElevatedButton.styleFrom(
                backgroundColor: scheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(l10n.retry),
            ),
          ],
        ),
      ),
      data: (promos) => Stack(
        children: [
          promos.isEmpty
              ? Center(child: Text(l10n.adminProductPromotionsEmpty))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                  itemCount: promos.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final p = promos[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: scheme.primaryContainer,
                        child: Icon(
                          Icons.local_offer_outlined,
                          color: scheme.onPrimaryContainer,
                          size: 18,
                        ),
                      ),
                      title: Text(p.name,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        p.type.toApi() == 'percentage'
                            ? '${p.discountValue}%'
                            : 'R\$ ${p.discountValue}',
                      ),
                      trailing: Icon(
                        p.isCurrentlyActive
                            ? Icons.circle
                            : Icons.circle_outlined,
                        size: 10,
                        color: p.isCurrentlyActive
                            ? Colors.green
                            : scheme.outline,
                      ),
                      onTap: () async {
                        await context.pushNamed(
                          'admin-promotion-form',
                          extra: p,
                        );
                        if (context.mounted) {
                          unawaited(ref
                              .read(adminProductPromotionsProvider(product.id)
                                  .notifier)
                              .refresh());
                        }
                      },
                    );
                  },
                ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton.extended(
              heroTag: 'promo-fab-${product.id}',
              backgroundColor: scheme.primary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: Text(l10n.adminPromotionNew),
              onPressed: () async {
                await context.pushNamed(
                  'admin-promotion-form',
                  extra: product,
                );
                if (context.mounted) {
                  ref.invalidate(adminProductPromotionsProvider(product.id));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
