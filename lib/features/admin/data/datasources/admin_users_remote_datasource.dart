/// Datasource remoto dos usuários admin — chamadas HTTP cruas a `/admin/users`.
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/network/http_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/page_meta.dart';
import '../models/admin_user_model.dart';

class AdminUsersRemoteDatasource {
  AdminUsersRemoteDatasource({
    http.Client? httpClient,
    SecureStorage? secureStorage,
  }) : _client = DoglioHttpClient(
          httpClient: httpClient,
          secureStorage: secureStorage,
        );

  final DoglioHttpClient _client;

  /// GET /admin/users com filtros e paginação.
  Future<(List<AdminUserModel>, PageMeta)> getUsers({
    String? search,
    String? role,
    bool? isActive,
    int page = 1,
    int perPage = 20,
  }) async {
    final query = <String, String>{
      'page': '$page',
      'per_page': '$perPage',
      if (search != null && search.isNotEmpty) 'search': search,
      'role': ?role,
      if (isActive != null) 'is_active': isActive ? '1' : '0',
    };

    final response = await _client.send(
      'GET',
      '/admin/users',
      queryParams: query,
    );

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
    final response = await _client.send(
      'POST',
      '/admin/users',
      body: {...user.toJson(), 'password': password},
    );
    return _parseSingle(response.body);
  }

  /// PUT /admin/users/{id}.
  Future<AdminUserModel> updateUser(AdminUserModel user) async {
    final response = await _client.send(
      'PUT',
      '/admin/users/${user.id}',
      body: user.toJson(),
    );
    return _parseSingle(response.body);
  }

  /// DELETE /admin/users/{id}.
  Future<void> deleteUser(String id) async {
    await _client.send('DELETE', '/admin/users/$id');
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
}
