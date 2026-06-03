library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/cart_model.dart';

class CartRemoteDatasource {
  CartRemoteDatasource({
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

  Future<CartModel> getCart() async {
    final response = await _httpClient
        .get(
          Uri.parse('${ApiConfig.baseUrl}/cart'),
          headers: await _authHeaders(),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode == 404 || response.statusCode == 401) {
      return const CartModel(
        items: [],
        total: '0.00',
        hasStockWarning: false,
        hasPriceChange: false,
      );
    }
    if (response.statusCode != 200) {
      throw Exception('Failed to load cart: ${response.statusCode}');
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>? ?? {};
    return CartModel.fromJson(data);
  }

  Future<CartModel> syncCart(List<Map<String, dynamic>> items) async {
    final response = await _httpClient
        .post(
          Uri.parse('${ApiConfig.baseUrl}/cart/sync'),
          headers: await _authHeaders(),
          body: jsonEncode({'items': items}),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to sync cart: ${response.statusCode}');
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>? ?? {};
    return CartModel.fromJson(data);
  }

  Future<void> clearCart() async {
    final response = await _httpClient
        .delete(
          Uri.parse('${ApiConfig.baseUrl}/cart'),
          headers: await _authHeaders(),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to clear cart: ${response.statusCode}');
    }
  }
}
