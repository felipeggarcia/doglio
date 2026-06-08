/// Addresses remote datasource
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/address_model.dart';

class AddressesRemoteDatasource {
  AddressesRemoteDatasource({
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

  Future<List<AddressModel>> getAddresses() async {
    final response = await _httpClient
        .get(
          Uri.parse('${ApiConfig.baseUrl}/addresses'),
          headers: await _authHeaders(),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != 200) {
      throw Exception('Failed to load addresses: ${response.statusCode}');
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>;
    return data
        .cast<Map<String, dynamic>>()
        .map((json) => AddressModel.fromJson(_normalizeJson(json)))
        .toList();
  }

  Future<AddressModel> createAddress(AddressModel address) async {
    final response = await _httpClient
        .post(
          Uri.parse('${ApiConfig.baseUrl}/addresses'),
          headers: await _authHeaders(),
          body: jsonEncode(address.toJson()),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to create address: ${response.statusCode}');
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return AddressModel.fromJson(
      _normalizeJson(body['data'] as Map<String, dynamic>),
    );
  }

  Future<AddressModel> updateAddress(AddressModel address) async {
    final response = await _httpClient
        .put(
          Uri.parse('${ApiConfig.baseUrl}/addresses/${address.id}'),
          headers: await _authHeaders(),
          body: jsonEncode(address.toJson()),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != 200) {
      throw Exception('Failed to update address: ${response.statusCode}');
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return AddressModel.fromJson(
      _normalizeJson(body['data'] as Map<String, dynamic>),
    );
  }

  Future<void> deleteAddress(String addressId) async {
    final response = await _httpClient
        .delete(
          Uri.parse('${ApiConfig.baseUrl}/addresses/$addressId'),
          headers: await _authHeaders(),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Failed to delete address: ${response.statusCode}');
    }
  }

  /// Normaliza campos do JSON de endereço para cobrir variações de campo
  /// que o backend pode retornar (ex: 'zip' vs 'zip_code', 'neighborhood' vs 'district').
  Map<String, dynamic> _normalizeJson(Map<String, dynamic> json) => {
        ...json,
        'zip_code': json['zip_code'] ?? json['zip'] ?? json['cep'] ?? '',
        'district': json['district'] ??
            json['neighborhood'] ??
            json['bairro'] ??
            '',
      };

  Future<void> setPrimaryAddress(String addressId) async {
    final response = await _httpClient
        .patch(
          Uri.parse('${ApiConfig.baseUrl}/addresses/$addressId/primary'),
          headers: await _authHeaders(),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != 200) {
      throw Exception('Failed to set primary address: ${response.statusCode}');
    }
  }
}
