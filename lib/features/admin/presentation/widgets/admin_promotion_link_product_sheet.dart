library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../domain/entities/admin_product.dart';
import '../providers/admin_products_provider.dart';
import '../providers/admin_promotions_provider.dart';

/// Bottom sheet para vincular um produto a uma promoção.
///
/// Modo edição (promotionId fornecido): chama a API linkProducts ao confirmar.
/// Modo criação (onProductPicked fornecido): retorna o produto via callback sem chamar a API.
class AdminPromotionLinkProductSheet extends ConsumerStatefulWidget {
  const AdminPromotionLinkProductSheet({
    super.key,
    this.promotionId,
    required this.linkedProductIds,
    this.onProductPicked,
  }) : assert(
          promotionId != null || onProductPicked != null,
          'Forneça promotionId (edit) ou onProductPicked (create)',
        );

  /// ID da promoção — obrigatório em modo edição.
  final String? promotionId;
  /// IDs dos produtos já vinculados — filtrados da lista de busca.
  final Set<String> linkedProductIds;
  /// Callback para modo criação: recebe o produto e o use_limit localmente.
  final void Function(AdminProduct product, int? useLimit)? onProductPicked;

  @override
  ConsumerState<AdminPromotionLinkProductSheet> createState() =>
      _AdminPromotionLinkProductSheetState();
}

class _AdminPromotionLinkProductSheetState
    extends ConsumerState<AdminPromotionLinkProductSheet> {
  final _searchController = TextEditingController();
  final _useLimitController = TextEditingController();
  final _scrollController = ScrollController();
  AdminProduct? _selected;
  bool _linking = false;

  static const _minSearchLength = 3;

  bool get _isSearchActive =>
      _searchController.text.length >= _minSearchLength;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 250) {
      ref.read(adminProductsProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _useLimitController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final productsState = ref.watch(adminProductsProvider);

    final visible = productsState.products
        .where((p) => !widget.linkedProductIds.contains(p.id))
        .toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ─── Header ────────────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.adminPromotionAddProduct,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // ─── Search field ───────────────────────────────────────────
                TextField(
                  controller: _searchController,
                  onChanged: (v) {
                    setState(() {});
                    if (v.length >= _minSearchLength) {
                      ref.read(adminProductsProvider.notifier).setSearch(v);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: l10n.adminProductsSearchHint,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 12),

                // ─── Product list / confirm panel ───────────────────────────
                if (_selected == null) ...[
                  Flexible(
                    child: !_isSearchActive
                        ? Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 24),
                              child: Text(
                                'Digite ao menos $_minSearchLength caracteres para buscar',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: scheme.onSurfaceVariant),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : productsState.isLoading && visible.isEmpty
                            ? const Center(child: CircularProgressIndicator())
                            : visible.isEmpty
                                ? Center(child: Text(l10n.adminProductsEmpty))
                                : ListView.builder(
                                    controller: _scrollController,
                                    shrinkWrap: true,
                                    itemCount: visible.length +
                                        (productsState.hasMore ? 1 : 0),
                                    itemBuilder: (_, i) {
                                      if (i == visible.length) {
                                        return productsState.isLoadingMore
                                            ? const Padding(
                                                padding: EdgeInsets.all(16),
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                              )
                                            : const SizedBox.shrink();
                                      }
                                      final p = visible[i];
                                      return ListTile(
                                        leading: const Icon(
                                            Icons.inventory_2_outlined),
                                        title: Text(p.name),
                                        subtitle: Text('R\$ ${p.price}'),
                                        onTap: () =>
                                            setState(() => _selected = p),
                                      );
                                    },
                                  ),
                  ),
                ] else ...[
                  // ─── Confirm use_limit ────────────────────────────────────
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.inventory_2_outlined),
                    title: Text(
                      _selected!.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: TextButton(
                      onPressed:
                          _linking ? null : () => setState(() => _selected = null),
                      child: Text(l10n.cancel),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _useLimitController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.adminPromotionUseLimit,
                      hintText: l10n.adminPromotionUseLimitHint,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _linking ? null : _handleLink,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: scheme.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _linking
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text(l10n.adminPromotionLinkButton),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLink() async {
    if (_selected == null) return;

    final useLimit = _useLimitController.text.trim().isEmpty
        ? null
        : int.tryParse(_useLimitController.text.trim());

    // Modo criação: retorna o produto via callback sem chamar a API.
    if (widget.onProductPicked != null) {
      widget.onProductPicked!(_selected!, useLimit);
      if (mounted) Navigator.pop(context);
      return;
    }

    // Modo edição: chama a API linkProducts.
    setState(() => _linking = true);

    final result = await ref
        .read(adminPromotionsProvider.notifier)
        .linkProducts(widget.promotionId!, [
      (productId: _selected!.id, useLimit: useLimit),
    ]);

    if (!mounted) return;
    setState(() => _linking = false);

    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failure.userMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      ),
      (_) => Navigator.pop(context),
    );
  }
}
