/// Provider de estado da listagem de produtos admin.
///
/// Espelha AdminUsersNotifier: lista paginada + filtros (objeto
/// AdminProductFilters) + busca com debounce.
library;

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/datasources/admin_products_remote_datasource.dart';
import '../../data/repositories/admin_products_repository_impl.dart';
import '../../domain/entities/admin_product.dart';
import '../../domain/entities/admin_product_filters.dart';
import '../../domain/entities/page_meta.dart';
import '../../domain/usecases/create_admin_product_use_case.dart';
import '../../domain/usecases/delete_admin_product_use_case.dart';
import '../../domain/usecases/get_admin_products_use_case.dart';
import '../../domain/usecases/update_admin_product_use_case.dart';

/// Estado imutável da tela de produtos.
class AdminProductsState {
  const AdminProductsState({
    this.products = const [],
    this.meta = PageMeta.empty,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.filters = AdminProductFilters.empty,
  });

  final List<AdminProduct> products;
  final PageMeta meta;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final AdminProductFilters filters;

  bool get hasMore => meta.hasMore;

  AdminProductsState copyWith({
    List<AdminProduct>? products,
    PageMeta? meta,
    bool? isLoading,
    bool? isLoadingMore,
    // Sentinela para permitir voltar errorMessage a null explicitamente.
    Object? errorMessage = _sentinel,
    AdminProductFilters? filters,
  }) {
    return AdminProductsState(
      products: products ?? this.products,
      meta: meta ?? this.meta,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage:
          errorMessage == _sentinel ? this.errorMessage : errorMessage as String?,
      filters: filters ?? this.filters,
    );
  }

  static const _sentinel = Object();
}

class AdminProductsNotifier extends AutoDisposeNotifier<AdminProductsState> {
  late final GetAdminProductsUseCase _getProducts;
  late final CreateAdminProductUseCase _createProduct;
  late final UpdateAdminProductUseCase _updateProduct;
  late final DeleteAdminProductUseCase _deleteProduct;
  Timer? _debounce;

  @override
  AdminProductsState build() {
    final repo =
        AdminProductsRepositoryImpl(AdminProductsRemoteDatasource());
    _getProducts = GetAdminProductsUseCase(repo);
    _createProduct = CreateAdminProductUseCase(repo);
    _updateProduct = UpdateAdminProductUseCase(repo);
    _deleteProduct = DeleteAdminProductUseCase(repo);
    ref.onDispose(() => _debounce?.cancel());
    // Carrega a primeira página logo após o build.
    Future(_loadFirstPage);
    return const AdminProductsState(isLoading: true);
  }

  // ─── Filtros ────────────────────────────────────────────────────────────────

  /// Busca com debounce: só dispara 400ms após a última tecla.
  void setSearch(String value) {
    state = state.copyWith(filters: state.filters.copyWith(search: value));
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _loadFirstPage);
  }

  void setActiveFilter(bool? active) {
    state = state.copyWith(filters: state.filters.copyWith(isActive: active));
    _loadFirstPage();
  }

  /// Chip "Destaque": alterna entre filtrar destacados e não filtrar.
  void toggleHighlightedFilter() {
    final current = state.filters.isHighlighted;
    state = state.copyWith(
      filters: state.filters.copyWith(isHighlighted: current == true ? null : true),
    );
    _loadFirstPage();
  }

  /// Chip "Sem estoque": alterna entre filtrar esgotados e não filtrar.
  void toggleOutOfStockFilter() {
    final current = state.filters.outOfStock;
    state = state.copyWith(
      filters: state.filters.copyWith(outOfStock: current == true ? null : true),
    );
    _loadFirstPage();
  }

  /// Aplica os filtros do bottom sheet (substitui o objeto inteiro).
  void applyFilters(AdminProductFilters filters) {
    state = state.copyWith(filters: filters);
    _loadFirstPage();
  }

  // ─── Carregamento ─────────────────────────────────────────────────────────

  Future<void> refresh() => _loadFirstPage();

  Future<void> _loadFirstPage() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _getProducts(filters: state.filters, page: 1);
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.userMessage,
      ),
      (data) {
        final (products, meta) = data;
        state =
            state.copyWith(isLoading: false, products: products, meta: meta);
      },
    );
  }

  /// Carrega a próxima página e concatena na lista atual.
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    final result = await _getProducts(
      filters: state.filters,
      page: state.meta.currentPage + 1,
    );
    result.fold(
      (failure) => state = state.copyWith(
        isLoadingMore: false,
        errorMessage: failure.userMessage,
      ),
      (data) {
        final (products, meta) = data;
        state = state.copyWith(
          isLoadingMore: false,
          products: [...state.products, ...products],
          meta: meta,
        );
      },
    );
  }

  // ─── Mutações (retornam Either para a UI exibir erro) ───────────────────────

  Future<Either<Failure, AdminProduct>> createProduct(
    AdminProduct product, {
    required List<String> newImagePaths,
  }) async {
    final result =
        await _createProduct(product, newImagePaths: newImagePaths);
    result.fold((_) {}, (_) => unawaited(_loadFirstPage()));
    return result;
  }

  Future<Either<Failure, AdminProduct>> updateProduct(
    AdminProduct product, {
    required List<String> newImagePaths,
    required List<String> removeImageIds,
    List<String> imageOrder = const [],
  }) async {
    final result = await _updateProduct(
      product,
      newImagePaths: newImagePaths,
      removeImageIds: removeImageIds,
      imageOrder: imageOrder,
    );
    result.fold((_) {}, (_) => unawaited(_loadFirstPage()));
    return result;
  }

  Future<Either<Failure, Unit>> deleteProduct(String id) async {
    final result = await _deleteProduct(id);
    result.fold(
      (_) {},
      // Remoção otimista: tira da lista local sem refetch.
      (_) => state = state.copyWith(
        products: state.products.where((p) => p.id != id).toList(),
      ),
    );
    return result;
  }
}

final adminProductsProvider =
    AutoDisposeNotifierProvider<AdminProductsNotifier, AdminProductsState>(
  AdminProductsNotifier.new,
);
