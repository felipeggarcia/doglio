library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/admin_order.dart';
import '../../domain/entities/page_meta.dart';
import '../models/admin_order_model.dart';

class AdminOrdersRemoteDatasource {
  AdminOrdersRemoteDatasource({
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

  /// GET /admin/orders — lista paginada com filtros opcionais.
  Future<(List<AdminOrderModel>, PageMeta)> getOrders({
    AdminOrderStatus? status,
    String? deliveryType,
    DateTime? dateFrom,
    DateTime? dateTo,
    int page = 1,
    int perPage = 20,
  }) async {
    final query = <String, String>{
      'page': '$page',
      'per_page': '$perPage',
      'status': ?status?.toApi(),
      'delivery_type': ?deliveryType,
      if (dateFrom != null)
        'date_from': '${dateFrom.year.toString().padLeft(4, '0')}-'
            '${dateFrom.month.toString().padLeft(2, '0')}-'
            '${dateFrom.day.toString().padLeft(2, '0')}',
      if (dateTo != null)
        'date_to': '${dateTo.year.toString().padLeft(4, '0')}-'
            '${dateTo.month.toString().padLeft(2, '0')}-'
            '${dateTo.day.toString().padLeft(2, '0')}',
    };

    final uri = Uri.parse('${ApiConfig.baseUrl}/admin/orders')
        .replace(queryParameters: query);

    final response = await _httpClient
        .get(uri, headers: await _authHeaders())
        .timeout(ApiConfig.timeout);

    if (response.statusCode != 200) {
      _throwFor(response);
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = (body['data'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(AdminOrderModel.fromJson)
        .toList();
    final meta = _parseMeta(body['meta'] as Map<String, dynamic>?);
    return (data, meta);
  }

  /// GET /admin/orders/{id} — detalhe com customer e status_history.
  Future<AdminOrderModel> getOrderDetail(String id) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/admin/orders/$id');
    final response = await _httpClient
        .get(uri, headers: await _authHeaders())
        .timeout(ApiConfig.timeout);

    if (response.statusCode != 200) {
      _throwFor(response);
    }
    return _parseSingle(response.body);
  }

  /// PATCH /admin/orders/{id}/status — atualiza status com notes opcional.
  Future<AdminOrderModel> updateOrderStatus(
    String id,
    AdminOrderStatus status, {
    String? notes,
  }) async {
    final body = <String, dynamic>{
      'status': status.toApi(),
      'notes': ?notes,
    };

    final response = await _httpClient
        .patch(
          Uri.parse('${ApiConfig.baseUrl}/admin/orders/$id/status'),
          headers: await _authHeaders(),
          body: jsonEncode(body),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != 200) {
      _throwFor(response);
    }
    return _parseSingle(response.body);
  }

  /// POST /admin/orders/{orderId}/items — adiciona produto ao pedido.
  Future<AdminOrderModel> addOrderItem(
    String orderId, {
    required String productId,
    required int quantity,
  }) async {
    final response = await _httpClient
        .post(
          Uri.parse('${ApiConfig.baseUrl}/admin/orders/$orderId/items'),
          headers: await _authHeaders(),
          body: jsonEncode({'product_id': productId, 'quantity': quantity}),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != 200 && response.statusCode != 201) {
      _throwFor(response);
    }
    return _parseSingle(response.body);
  }

  /// PUT /admin/orders/{orderId}/items/{itemId} — altera quantidade do item.
  Future<AdminOrderModel> updateOrderItem(
    String orderId,
    String itemId, {
    required int quantity,
  }) async {
    final response = await _httpClient
        .put(
          Uri.parse(
              '${ApiConfig.baseUrl}/admin/orders/$orderId/items/$itemId'),
          headers: await _authHeaders(),
          body: jsonEncode({'quantity': quantity}),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != 200) {
      _throwFor(response);
    }
    return _parseSingle(response.body);
  }

  /// DELETE /admin/orders/{orderId}/items/{itemId} — remove item do pedido.
  Future<AdminOrderModel> removeOrderItem(
    String orderId,
    String itemId,
  ) async {
    // DELETE sem Content-Type para não enviar body JSON desnecessário.
    final headers = await _authHeaders();
    headers.remove('Content-Type');
    final response = await _httpClient
        .delete(
          Uri.parse(
              '${ApiConfig.baseUrl}/admin/orders/$orderId/items/$itemId'),
          headers: headers,
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != 200) {
      _throwFor(response);
    }
    return _parseSingle(response.body);
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  AdminOrderModel _parseSingle(String responseBody) {
    final body = jsonDecode(responseBody) as Map<String, dynamic>;
    return AdminOrderModel.fromJson(body['data'] as Map<String, dynamic>);
  }

  PageMeta _parseMeta(Map<String, dynamic>? meta) {
    if (meta == null) return PageMeta.empty;
    return PageMeta(
      currentPage: (meta['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (meta['last_page'] as num?)?.toInt() ?? 1,
      total: (meta['total'] as num?)?.toInt() ?? 0,
    );
  }

  /// 422 vira [ValidationException]; demais erros usam a `message` da API.
  Never _throwFor(http.Response response) {
    if (response.statusCode == 422) {
      throw ValidationException(
        _errorMessage(response),
        errors: _parseValidationErrors(response),
      );
    }
    throw Exception(_errorMessage(response));
  }

  Map<String, List<String>> _parseValidationErrors(http.Response response) {
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final errors = body['errors'];
      if (errors is Map<String, dynamic>) {
        return errors.map(
          (field, messages) => MapEntry(
            field,
            (messages as List<dynamic>).map((m) => m.toString()).toList(),
          ),
        );
      }
    } catch (_) {}
    return const {};
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
