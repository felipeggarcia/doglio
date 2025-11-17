/// Store provider for managing products and categories state (Presentation layer)
///
/// This provider manages UI state and uses domain use cases.
/// It should NOT have business logic - that belongs in use cases.
library;

import 'package:flutter/foundation.dart' hide Category;
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../data/repositories/store_repository_impl.dart';
import '../../data/datasources/store_remote_datasource.dart';

class StoreProvider extends ChangeNotifier {
  static StoreProvider? _instance;

  static StoreProvider get instance {
    _instance ??= StoreProvider._internal();
    return _instance!;
  }

  StoreProvider._internal() {
    // Dependency injection (in a real app, use a DI framework)
    final remoteDatasource = StoreRemoteDatasourceImpl();
    final repository = StoreRepositoryImpl(remoteDatasource: remoteDatasource);
    _getProductsUseCase = GetProductsUseCase(repository);
    _getCategoriesUseCase = GetCategoriesUseCase(repository);
    // Don't load data here - let the widget trigger it
  }

  // Use cases (domain layer dependencies)
  late final GetProductsUseCase _getProductsUseCase;
  late final GetCategoriesUseCase _getCategoriesUseCase;

  // State
  bool _isLoadingProducts = false;
  bool _isLoadingCategories = false;
  String? _error;
  List<Product> _products = [];
  List<Category> _categories = [];
  String? _selectedCategoryId;
  String _searchQuery = '';

  // Getters
  bool get isLoadingProducts => _isLoadingProducts;
  bool get isLoadingCategories => _isLoadingCategories;
  bool get isLoading => _isLoadingProducts || _isLoadingCategories;
  String? get error => _error;
  List<Product> get products => _products;
  List<Category> get categories => _categories;
  String? get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;

  /// Load initial data (categories and products)
  Future<void> loadInitialData() async {
    await Future.wait([loadCategories(), loadProducts()]);
  }

  /// Load categories from API using use case
  Future<void> loadCategories({bool? isHighlighted}) async {
    _isLoadingCategories = true;
    _error = null;
    notifyListeners();

    try {
      print('[StoreProvider] Loading categories...');
      _categories = await _getCategoriesUseCase(
        isHighlighted: isHighlighted,
        withCount: true,
      );
      print('[StoreProvider] Categories loaded: ${_categories.length}');
      _error = null;
    } catch (e) {
      print('[StoreProvider] Error loading categories: $e');
      _error = 'Error loading categories: $e';
      _categories = [];
    } finally {
      _isLoadingCategories = false;
      notifyListeners();
    }
  }

  /// Load products from API using use case
  Future<void> loadProducts({
    String? categoryId,
    bool? isHighlighted,
    String? search,
  }) async {
    _isLoadingProducts = true;
    _error = null;
    notifyListeners();

    try {
      print('[StoreProvider] Loading products...');
      _products = await _getProductsUseCase(
        categoryId: categoryId ?? _selectedCategoryId,
        isHighlighted: isHighlighted,
        search: search ?? (_searchQuery.isNotEmpty ? _searchQuery : null),
      );
      print('[StoreProvider] Products loaded: ${_products.length}');
      _error = null;
    } catch (e) {
      print('[StoreProvider] Error loading products: $e');
      _error = 'Error loading products: $e';
      _products = [];
    } finally {
      _isLoadingProducts = false;
      notifyListeners();
    }
  }

  /// Filter products by category
  void filterByCategory(String? categoryId) {
    if (_selectedCategoryId != categoryId) {
      _selectedCategoryId = categoryId;
      loadProducts(categoryId: categoryId);
    }
  }

  /// Search products
  void searchProducts(String query) {
    _searchQuery = query;
    loadProducts(search: query.isNotEmpty ? query : null);
  }

  /// Clear filters and reload all products
  void clearFilters() {
    _selectedCategoryId = null;
    _searchQuery = '';
    loadProducts();
  }

  /// Refresh all data
  Future<void> refresh() async {
    await loadInitialData();
  }
}
