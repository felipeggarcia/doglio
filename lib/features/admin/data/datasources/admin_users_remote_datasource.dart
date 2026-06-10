/// Datasource remoto dos usuários admin — chamadas HTTP cruas a `/admin/users`.
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/page_meta.dart';
import '../models/admin_user_model.dart';

class AdminUsersRemoteDatasource {
  AdminUsersRemoteDatasource({
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

  /// GET /admin/users com filtros e paginação.
  /// Retorna a lista de models + os metadados da página.
  Future<(List<AdminUserModel>, PageMeta)> getUsers({
    String? search,
    String? role,
    bool? isActive,
    int page = 1,
    int perPage = 20,
  }) async {
    // Monta os query params dinamicamente: só inclui o que foi informado.
    final query = <String, String>{
      'page': '$page',
      'per_page': '$perPage',
      if (search != null && search.isNotEmpty) 'search': search,
      'role': ?role,
      if (isActive != null) 'is_active': isActive ? '1' : '0',
    };

    final uri = Uri.parse('${ApiConfig.baseUrl}/admin/users')
        .replace(queryParameters: query);

    final response =
        await _httpClient.get(uri, headers: await _authHeaders()).timeout(
              ApiConfig.timeout,
            );

    if (response.statusCode != 200) {
      throw Exception(_errorMessage(response));
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = (body['data'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(AdminUserModel.fromJson)
        .toList();
    final meta = _parseMeta(body['meta'] as Map<String, dynamic>?);
    return (data, meta);
  }

  /// POST /admin/users. `password` é exigido pela API e entra no corpo.
  Future<AdminUserModel> createUser(
    AdminUserModel user, {
    required String password,
  }) async {
    final response = await _httpClient
        .post(
          Uri.parse('${ApiConfig.baseUrl}/admin/users'),
          headers: await _authHeaders(),
          body: jsonEncode({...user.toJson(), 'password': password}),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(_errorMessage(response));
    }
    return _parseSingle(response.body);
  }

  /// PUT /admin/users/{id}.
  Future<AdminUserModel> updateUser(AdminUserModel user) async {
    final response = await _httpClient
        .put(
          Uri.parse('${ApiConfig.baseUrl}/admin/users/${user.id}'),
          headers: await _authHeaders(),
          body: jsonEncode(user.toJson()),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != 200) {
      throw Exception(_errorMessage(response));
    }
    return _parseSingle(response.body);
  }

  /// DELETE /admin/users/{id}.
  Future<void> deleteUser(String id) async {
    final response = await _httpClient
        .delete(
          Uri.parse('${ApiConfig.baseUrl}/admin/users/$id'),
          headers: await _authHeaders(),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(_errorMessage(response));
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  AdminUserModel _parseSingle(String responseBody) {
    final body = jsonDecode(responseBody) as Map<String, dynamic>;
    return AdminUserModel.fromJson(body['data'] as Map<String, dynamic>);
  }

  PageMeta _parseMeta(Map<String, dynamic>? meta) {
    if (meta == null) return PageMeta.empty;
    return PageMeta(
      currentPage: (meta['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (meta['last_page'] as num?)?.toInt() ?? 1,
      total: (meta['total'] as num?)?.toInt() ?? 0,
    );
  }

  /// Extrai a `message` do corpo de erro do backend; cai para o status code.
  String _errorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final msg = body['message'];
      if (msg is String && msg.isNotEmpty) return msg;
    } catch (_) {
      // corpo não-JSON: ignora e usa o fallback
    }
    return 'Erro ${response.statusCode}';
  }
}
