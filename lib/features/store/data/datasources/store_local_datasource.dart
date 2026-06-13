/// SharedPreferences cache for store products and categories.
///
/// Strategy: online-first. This datasource is only read on network failure
/// and written on every successful remote fetch.
library;

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

const Duration _kTtl = Duration(minutes: 30);

/// Key prefixes
const _kProductsPrefix = 'store_products_';
const _kProductsTsPrefix = 'store_products_ts_';
const _kCategories = 'store_categories';
const _kCategoriesTs = 'store_categories_ts';

abstract interface class StoreLocalDatasource {
  Future<void> saveProducts(String cacheKey, List<ProductModel> models);
  Future<List<ProductModel>?> loadProducts(String cacheKey);

  Future<void> saveCategories(List<CategoryModel> models);
  Future<List<CategoryModel>?> loadCategories();

  Future<void> clearAll();
}

class StoreLocalDatasourceImpl implements StoreLocalDatasource {
  StoreLocalDatasourceImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<void> saveProducts(String cacheKey, List<ProductModel> models) async {
    final json = jsonEncode(models.map((m) => m.toJson()).toList());
    await _prefs.setString('$_kProductsPrefix$cacheKey', json);
    await _prefs.setInt(
      '$_kProductsTsPrefix$cacheKey',
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  Future<List<ProductModel>?> loadProducts(String cacheKey) async {
    if (_isExpired('$_kProductsTsPrefix$cacheKey')) return null;

    final raw = _prefs.getString('$_kProductsPrefix$cacheKey');
    if (raw == null) return null;

    try {
      return (jsonDecode(raw) as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .toList();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveCategories(List<CategoryModel> models) async {
    final json = jsonEncode(models.map((m) => m.toJson()).toList());
    await _prefs.setString(_kCategories, json);
    await _prefs.setInt(
      _kCategoriesTs,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  Future<List<CategoryModel>?> loadCategories() async {
    if (_isExpired(_kCategoriesTs)) return null;

    final raw = _prefs.getString(_kCategories);
    if (raw == null) return null;

    try {
      return (jsonDecode(raw) as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(CategoryModel.fromJson)
          .toList();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearAll() async {
    final keys = _prefs.getKeys().where(
          (k) =>
              k.startsWith(_kProductsPrefix) ||
              k.startsWith(_kProductsTsPrefix) ||
              k == _kCategories ||
              k == _kCategoriesTs,
        );
    for (final key in keys.toList()) {
      await _prefs.remove(key);
    }
  }

  bool _isExpired(String tsKey) {
    final ts = _prefs.getInt(tsKey);
    if (ts == null) return true;
    final age = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(ts));
    return age > _kTtl;
  }
}
