/// Orders remote datasource
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/order_model.dart';

class OrdersRemoteDatasource {
  OrdersRemoteDatasource({
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

  /// Retorna (model, orderNumber) para cada pedido.
  Future<List<(OrderModel, String?)>> getOrders() async {
    final response = await _httpClient
        .get(
          Uri.parse('${ApiConfig.baseUrl}/orders'),
          headers: await _authHeaders(),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != 200) {
      throw Exception('Failed to load orders: ${response.statusCode}');
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>;
    return data.cast<Map<String, dynamic>>().map((json) {
      final normalized = _normalizeOrder(json);
      final model = OrderModel.fromJson(normalized);
      final orderNumber = json['order_number'] as String?;
      return (model, orderNumber);
    }).toList();
  }

  /// Retorna (model, orderNumber, statusHistory, paymentRaw) para o pedido.
  Future<(OrderModel, String?, List<Map<String, dynamic>>, Map<String, dynamic>?)>
      getOrderDetail(String orderId) async {
    final response = await _httpClient
        .get(
          Uri.parse('${ApiConfig.baseUrl}/orders/$orderId'),
          headers: await _authHeaders(),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != 200) {
      throw Exception('Failed to load order: ${response.statusCode}');
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    final normalized = _normalizeOrder(data);
    final model = OrderModel.fromJson(normalized);
    final orderNumber = data['order_number'] as String?;
    final historyRaw = (data['status_history'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final paymentRaw = data['payment'] as Map<String, dynamic>?;
    return (model, orderNumber, historyRaw, paymentRaw);
  }

  // ─── Normalizadores ───────────────────────────────────────────────────────────

  Map<String, dynamic> _normalizeOrder(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map(_normalizeOrderItem)
        .toList();

    final shippingRaw = json['shipping_address'];
    String? shippingAddress;
    if (shippingRaw is Map) {
      shippingAddress = _formatAddress(shippingRaw.cast<String, dynamic>());
    } else if (shippingRaw is String) {
      shippingAddress = shippingRaw;
    }

    // id agora é inteiro no backend → converter para string
    final result = Map<String, dynamic>.from(json);
    result['id'] = (json['id'] ?? '').toString();
    result['total'] =
        (json['total_amount'] ?? json['total'] ?? json['order_total'] ?? '0')
            .toString();
    result['shipping_address'] = shippingAddress;
    result['items'] = rawItems;
    return result;
  }

  Map<String, dynamic> _normalizeOrderItem(Map<String, dynamic> json) {
    final product = json['product'] as Map<String, dynamic>?;
    return {
      ...json,
      'id': (json['id'] ?? '').toString(),
      'product_id': (json['product_id'] ?? product?['id'] ?? '').toString(),
      'product_name':
          (json['product_name'] ?? product?['name'] ?? json['name'] ?? '')
              .toString(),
      'price':
          (json['price'] ?? json['unit_price'] ?? json['subtotal'] ?? '0')
              .toString(),
      'product_image': json['product_image'] ??
          (product?['primary_image'] as Map<String, dynamic>?)?['url'] ??
          (product?['images'] as List<dynamic>?)?.firstOrNull?['url'],
    };
  }

  String? _formatAddress(Map<String, dynamic> addr) {
    final street = addr['street'] as String?;
    if (street == null) return null;

    final number = addr['number'] as String?;
    final complement = addr['complement'] as String?;
    final district = addr['district'] as String?;
    final city = addr['city'] as String?;
    final state = addr['state'] as String?;
    final zip = addr['zip_code'] as String?;

    final buf = StringBuffer('$street, $number');
    if (complement != null) buf.write(' — $complement');
    if (district != null) buf.write('\n$district');
    if (city != null) buf.write('\n$city');
    if (state != null) buf.write('/$state');
    if (zip != null) {
      final d = zip.replaceAll(RegExp(r'[^\d]'), '');
      final fmt =
          d.length == 8 ? '${d.substring(0, 5)}-${d.substring(5)}' : zip;
      buf.write(' — CEP $fmt');
    }
    return buf.toString();
  }
}
