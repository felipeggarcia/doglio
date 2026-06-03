/// Favorites remote datasource
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/favorite_model.dart';

class FavoritesRemoteDatasource {
  FavoritesRemoteDatasource({
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

  Future<List<FavoriteModel>> getFavorites() async {
    final response = await _httpClient
        .get(
          Uri.parse('${ApiConfig.baseUrl}/favorites'),
          headers: await _authHeaders(),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != 200) {
      throw Exception('Failed to load favorites: ${response.statusCode}');
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>;
    return data
        .cast<Map<String, dynamic>>()
        .map(FavoriteModel.fromJson)
        .toList();
  }

  Future<FavoriteModel> addFavorite({
    required String productId,
    bool notifyOnRestock = false,
  }) async {
    final response = await _httpClient
        .post(
          Uri.parse('${ApiConfig.baseUrl}/favorites'),
          headers: await _authHeaders(),
          body: jsonEncode({
            'product_id': productId,
            'notify_on_restock': notifyOnRestock,
          }),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to add favorite: ${response.statusCode}');
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return FavoriteModel.fromJson(body['data'] as Map<String, dynamic>);
  }

  Future<void> removeFavorite(String favoriteId) async {
    final response = await _httpClient
        .delete(
          Uri.parse('${ApiConfig.baseUrl}/favorites/$favoriteId'),
          headers: await _authHeaders(),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to remove favorite: ${response.statusCode}');
    }
  }
}
