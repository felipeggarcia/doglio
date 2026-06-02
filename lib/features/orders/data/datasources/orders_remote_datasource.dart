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

  Future<List<OrderModel>> getOrders() async {
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
    return data
        .cast<Map<String, dynamic>>()
        .map(OrderModel.fromJson)
        .toList();
  }

  Future<OrderModel> getOrderDetail(String orderId) async {
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
    return OrderModel.fromJson(body['data'] as Map<String, dynamic>);
  }
}
