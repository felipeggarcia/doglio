library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/admin_category_model.dart';

class AdminCategoriesRemoteDatasource {
  AdminCategoriesRemoteDatasource({
    http.Client? httpClient,
    SecureStorage? secureStorage,
  })  : _httpClient = httpClient ?? http.Client(),
        _secureStorage = secureStorage ?? SecureStorage();

  final http.Client _httpClient;
  final SecureStorage _secureStorage;

  Future<Map<String, String>> _authHeaders() async {
    final token = await _secureStorage.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Host': ApiConfig.virtualHost,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// GET /admin/categories — retorna a lista completa (sem paginação).
  Future<List<AdminCategoryModel>> getCategories({
    String? search,
    bool? isActive,
  }) async {
    final query = <String, String>{
      if (search != null && search.isNotEmpty) 'search': search,
      if (isActive != null) 'is_active': isActive ? '1' : '0',
    };

    final uri = Uri.parse('${ApiConfig.baseUrl}/admin/categories')
        .replace(queryParameters: query.isEmpty ? null : query);

    final response = await _httpClient
        .get(uri, headers: await _authHeaders())
        .timeout(ApiConfig.timeout);

    if (response.statusCode != 200) {
      throw Exception(_errorMessage(response));
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return (body['data'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(AdminCategoryModel.fromJson)
        .toList();
  }

  /// POST /admin/categories.
  Future<AdminCategoryModel> createCategory(
      AdminCategoryModel category) async {
    final response = await _httpClient
        .post(
          Uri.parse('${ApiConfig.baseUrl}/admin/categories'),
          headers: await _authHeaders(),
          body: jsonEncode(category.toJson()),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(_errorMessage(response));
    }
    return _parseSingle(response.body);
  }

  /// PUT /admin/categories/{id}.
  Future<AdminCategoryModel> updateCategory(
      AdminCategoryModel category) async {
    final response = await _httpClient
        .put(
          Uri.parse('${ApiConfig.baseUrl}/admin/categories/${category.id}'),
          headers: await _authHeaders(),
          body: jsonEncode(category.toJson()),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != 200) {
      throw Exception(_errorMessage(response));
    }
    return _parseSingle(response.body);
  }

  /// DELETE /admin/categories/{id}.
  Future<void> deleteCategory(String id) async {
    final response = await _httpClient
        .delete(
          Uri.parse('${ApiConfig.baseUrl}/admin/categories/$id'),
          headers: await _authHeaders(),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(_errorMessage(response));
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  AdminCategoryModel _parseSingle(String responseBody) {
    final body = jsonDecode(responseBody) as Map<String, dynamic>;
    return AdminCategoryModel.fromJson(body['data'] as Map<String, dynamic>);
  }

  String _errorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final msg = body['message'];
      if (msg is String && msg.isNotEmpty) return msg;
    } catch (_) {}
    return 'Erro ${response.statusCode}';
  }
}
