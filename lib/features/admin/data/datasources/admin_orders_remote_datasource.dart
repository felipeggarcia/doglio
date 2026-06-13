library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/network/http_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/admin_order.dart';
import '../../domain/entities/page_meta.dart';
import '../models/admin_order_model.dart';

class AdminOrdersRemoteDatasource {
  AdminOrdersRemoteDatasource({
    http.Client? httpClient,
    SecureStorage? secureStorage,
  }) : _client = DoglioHttpClient(
          httpClient: httpClient,
          secureStorage: secureStorage,
        );

  final DoglioHttpClient _client;

  /// GET /admin/orders — lista paginada com filtros opcionais.
  Future<(List<AdminOrderModel>, PageMeta)> getOrders({
    String? search,
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
      'search': ?search,
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

    final response = await _client.send(
      'GET',
      '/admin/orders',
      queryParams: query,
    );

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
    final response = await _client.send('GET', '/admin/orders/$id');
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

    final response = await _client.send(
      'PATCH',
      '/admin/orders/$id/status',
      body: body,
    );
    return _parseSingle(response.body);
  }

  /// POST /admin/orders/{orderId}/items — adiciona produto ao pedido.
  Future<AdminOrderModel> addOrderItem(
    String orderId, {
    required String productId,
    required int quantity,
  }) async {
    final response = await _client.send(
      'POST',
      '/admin/orders/$orderId/items',
      body: {'product_id': productId, 'quantity': quantity},
    );
    return _parseSingle(response.body);
  }

  /// PUT /admin/orders/{orderId}/items/{itemId} — altera quantidade do item.
  Future<AdminOrderModel> updateOrderItem(
    String orderId,
    String itemId, {
    required int quantity,
  }) async {
    final response = await _client.send(
      'PUT',
      '/admin/orders/$orderId/items/$itemId',
      body: {'quantity': quantity},
    );
    return _parseSingle(response.body);
  }

  /// DELETE /admin/orders/{orderId}/items/{itemId} — remove item do pedido.
  Future<AdminOrderModel> removeOrderItem(
    String orderId,
    String itemId,
  ) async {
    final response =
        await _client.send('DELETE', '/admin/orders/$orderId/items/$itemId');
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
}
