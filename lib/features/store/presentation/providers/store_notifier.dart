library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/providers/shared_preferences_provider.dart';
import '../../data/datasources/store_local_datasource.dart';
import '../../data/datasources/store_remote_datasource.dart';
import '../../data/repositories/store_repository_impl.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_product_details_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';

// ─── Estado ────────────────────────────────────────────────────────────────────

class StoreState {
  const StoreState({
    this.products = const [],
    this.categories = const [],
    this.isLoadingProducts = false,
    this.isLoadingCategories = false,
    this.errorMessage,
    this.selectedCategoryId,
    this.searchQuery = '',
  });

  final List<Product> products;
  final List<Category> categories;
  final bool isLoadingProducts;
  final bool isLoadingCategories;
  final String? errorMessage;
  final String? selectedCategoryId;
  final String searchQuery;

  bool get isLoading => isLoadingProducts || isLoadingCategories;

  StoreState copyWith({
    List<Product>? products,
    List<Category>? categories,
    bool? isLoadingProducts,
    bool? isLoadingCategories,
    String? errorMessage,
    Object? selectedCategoryId = _sentinel,
    String? searchQuery,
  }) {
    return StoreState(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      errorMessage: errorMessage,
      selectedCategoryId: selectedCategoryId == _sentinel
          ? this.selectedCategoryId
          : selectedCategoryId as String?,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

// sentinel para distinguir "não passou" de "passou null" no selectedCategoryId
const _sentinel = Object();

// ─── Notifier ─────────────────────────────────────────────────────────────────

class StoreNotifier extends Notifier<StoreState> {
  late final GetProductsUseCase _getProducts;
  late final GetCategoriesUseCase _getCategories;

  @override
  StoreState build() {
    SharedPreferences? prefs;
    try {
      prefs = ref.read(sharedPreferencesProvider);
    } catch (_) {
      // Provider not overridden (e.g. in tests) — run without cache.
    }
    final repo = StoreRepositoryImpl(
      remoteDatasource: StoreRemoteDatasourceImpl(),
      localDatasource: prefs != null ? StoreLocalDatasourceImpl(prefs) : null,
    );
    _getProducts = GetProductsUseCase(repo);
    _getCategories = GetCategoriesUseCase(repo);

    Future(() => _loadInitialData());
    return const StoreState();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([_loadCategories(), _loadProducts()]);
  }

  Future<void> _loadCategories() async {
    state = state.copyWith(isLoadingCategories: true);
    final result = await _getCategories(isHighlighted: null, withCount: true);
    result.fold(
      (failure) => state = state.copyWith(
        isLoadingCategories: false,
        errorMessage: failure.userMessage,
      ),
      (categories) => state = state.copyWith(
        isLoadingCategories: false,
        categories: categories,
      ),
    );
  }

  Future<void> _loadProducts({String? categoryId, String? search}) async {
    state = state.copyWith(isLoadingProducts: true, errorMessage: null);
    final result = await _getProducts(
      categoryId: categoryId ?? state.selectedCategoryId,
      search: search ?? (state.searchQuery.isNotEmpty ? state.searchQuery : null),
    );
    result.fold(
      (failure) => state = state.copyWith(
        isLoadingProducts: false,
        errorMessage: failure.userMessage,
      ),
      (products) => state = state.copyWith(
        isLoadingProducts: false,
        products: products,
      ),
    );
  }

  void filterByCategory(String? categoryId) {
    if (state.selectedCategoryId != categoryId) {
      state = state.copyWith(selectedCategoryId: categoryId);
      _loadProducts(categoryId: categoryId);
    }
  }

  void searchProducts(String query) {
    state = state.copyWith(searchQuery: query);
    _loadProducts(search: query.isNotEmpty ? query : null);
  }

  Future<void> clearFilters() async {
    state = state.copyWith(selectedCategoryId: null, searchQuery: '');
    await _loadProducts();
  }

  Future<void> refresh() => _loadInitialData();
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final storeProvider = NotifierProvider<StoreNotifier, StoreState>(
  StoreNotifier.new,
);

final productByIdProvider =
    FutureProvider.autoDispose.family<Product?, String>((ref, productId) async {
  final useCase = GetProductDetailsUseCase(
    StoreRepositoryImpl(remoteDatasource: StoreRemoteDatasourceImpl()),
  );
  final result = await useCase(productId);
  return result.fold((_) => null, (p) => p);
});
