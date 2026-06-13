library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/network/http_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/admin_category_model.dart';

class AdminCategoriesRemoteDatasource {
  AdminCategoriesRemoteDatasource({
    http.Client? httpClient,
    SecureStorage? secureStorage,
  }) : _client = DoglioHttpClient(
          httpClient: httpClient,
          secureStorage: secureStorage,
        );

  final DoglioHttpClient _client;

  /// GET /admin/categories — retorna a lista completa (sem paginação).
  Future<List<AdminCategoryModel>> getCategories({
    String? search,
    bool? isActive,
  }) async {
    final query = <String, String>{
      if (search != null && search.isNotEmpty) 'search': search,
      if (isActive != null) 'is_active': isActive ? '1' : '0',
    };

    final response = await _client.send(
      'GET',
      '/admin/categories',
      queryParams: query.isEmpty ? null : query,
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return (body['data'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(AdminCategoryModel.fromJson)
        .toList();
  }

  /// POST /admin/categories.
  Future<AdminCategoryModel> createCategory(AdminCategoryModel category) async {
    final response = await _client.send(
      'POST',
      '/admin/categories',
      body: category.toJson(),
    );
    return _parseSingle(response.body);
  }

  /// PUT /admin/categories/{id}.
  Future<AdminCategoryModel> updateCategory(AdminCategoryModel category) async {
    final response = await _client.send(
      'PUT',
      '/admin/categories/${category.id}',
      body: category.toJson(),
    );
    return _parseSingle(response.body);
  }

  /// DELETE /admin/categories/{id}.
  Future<void> deleteCategory(String id) async {
    await _client.send('DELETE', '/admin/categories/$id');
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  AdminCategoryModel _parseSingle(String responseBody) {
    final body = jsonDecode(responseBody) as Map<String, dynamic>;
    return AdminCategoryModel.fromJson(body['data'] as Map<String, dynamic>);
  }
}
