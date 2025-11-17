/// Store provider for managing products and categories state
library;

import 'package:flutter/foundation.dart' hide Category;
import '../../domain/entities/product.dart';
import '../../data/datasources/store_remote_datasource.dart';

class StoreProvider extends ChangeNotifier {
  static StoreProvider? _instance;

  static StoreProvider get instance {
    _instance ??= StoreProvider._internal();
    return _instance!;
  }

  StoreProvider._internal() {
    _datasource = StoreRemoteDatasourceImpl();
    loadInitialData();
  }

  late final StoreRemoteDatasource _datasource;

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

  /// Load categories from API
  Future<void> loadCategories({bool? isHighlighted}) async {
    _isLoadingCategories = true;
    _error = null;
    notifyListeners();

    try {
      _categories = await _datasource.getCategories(
        isHighlighted: isHighlighted,
        withCount: true,
      );
      _error = null;
    } catch (e) {
      _error = 'Error loading categories: $e';
      _categories = [];
    } finally {
      _isLoadingCategories = false;
      notifyListeners();
    }
  }

  /// Load products from API
  Future<void> loadProducts({
    String? categoryId,
    bool? isHighlighted,
    String? search,
  }) async {
    _isLoadingProducts = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _datasource.getProducts(
        categoryId: categoryId ?? _selectedCategoryId,
        isHighlighted: isHighlighted,
        search: search ?? (_searchQuery.isNotEmpty ? _searchQuery : null),
      );
      _error = null;
    } catch (e) {
      _error = 'Error loading products: $e';
      _products = [];
    } finally {
      _isLoadingProducts = false;
      notifyListeners();
    }
  }

  /// Filter products by category
  void filterByCategory(String? categoryId) {
    print('🔵 [FILTER] Filtering by category: $categoryId');
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
    print('🔵 [FILTER] Clearing all filters');
    _selectedCategoryId = null;
    _searchQuery = '';
    loadProducts();
  }

  /// Refresh all data
  Future<void> refresh() async {
    await loadInitialData();
  }
}
