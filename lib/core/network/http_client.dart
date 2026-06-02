/// HTTP client wrapper for Doglio API
///
/// Provides consistent headers, authentication, and error handling
library;

import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../storage/secure_storage.dart';
import 'api_response.dart';
import 'api_exception.dart';

/// HTTP client for Doglio API with automatic token management
class DoglioHttpClient {
  DoglioHttpClient({http.Client? httpClient, SecureStorage? secureStorage})
    : _httpClient = httpClient ?? http.Client(),
      _secureStorage = secureStorage ?? SecureStorage();

  final http.Client _httpClient;
  final SecureStorage _secureStorage;

  /// Get base headers for all requests
  Map<String, String> _getBaseHeaders() {
    return {'Content-Type': 'application/json', 'Accept': 'application/json'};
  }

  /// Get headers with authentication token
  Future<Map<String, String>> _getAuthHeaders() async {
    final headers = _getBaseHeaders();
    final token = await _secureStorage.getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParams,
    bool requiresAuth = false,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiConfig.baseUrl}$endpoint',
      ).replace(queryParameters: queryParams);

      final headers = requiresAuth
          ? await _getAuthHeaders()
          : _getBaseHeaders();

      final response = await _httpClient
          .get(uri, headers: headers)
          .timeout(ApiConfig.timeout);

      return _handleResponse<T>(response);
    } on TimeoutException {
      throw const NetworkException();
    } on http.ClientException {
      throw const NetworkException();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw const NetworkException();
    }
  }

  /// POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');

      final headers = requiresAuth
          ? await _getAuthHeaders()
          : _getBaseHeaders();

      final response = await _httpClient
          .post(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.timeout);

      return _handleResponse<T>(response);
    } on TimeoutException {
      throw const NetworkException();
    } on http.ClientException {
      throw const NetworkException();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw const NetworkException();
    }
  }

  /// PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');

      final headers = requiresAuth
          ? await _getAuthHeaders()
          : _getBaseHeaders();

      final response = await _httpClient
          .put(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.timeout);

      return _handleResponse<T>(response);
    } on TimeoutException {
      throw const NetworkException();
    } on http.ClientException {
      throw const NetworkException();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw const NetworkException();
    }
  }

  /// DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    bool requiresAuth = false,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');

      final headers = requiresAuth
          ? await _getAuthHeaders()
          : _getBaseHeaders();

      final response = await _httpClient
          .delete(uri, headers: headers)
          .timeout(ApiConfig.timeout);

      return _handleResponse<T>(response);
    } on TimeoutException {
      throw const NetworkException();
    } on http.ClientException {
      throw const NetworkException();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw const NetworkException();
    }
  }

  /// PATCH request
  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');

      final headers = requiresAuth
          ? await _getAuthHeaders()
          : _getBaseHeaders();

      final response = await _httpClient
          .patch(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.timeout);

      return _handleResponse<T>(response);
    } on TimeoutException {
      throw const NetworkException();
    } on http.ClientException {
      throw const NetworkException();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw const NetworkException();
    }
  }

  /// Handle HTTP response
  ApiResponse<T> _handleResponse<T>(http.Response response) {
    final statusCode = response.statusCode;

    // No content response (204)
    if (statusCode == 204) {
      return ApiResponse<T>(success: true, message: 'Success', data: null);
    }

    // Empty body check
    if (response.body.isEmpty) {
      throw ApiException(
        statusCode: statusCode,
        message: 'Empty response from server',
        code: 'EMPTY_RESPONSE',
      );
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    // Success responses (200, 201)
    if (statusCode >= 200 && statusCode < 300) {
      return ApiResponse<T>.fromJson(body);
    }

    // Error responses
    throw ApiException.fromResponse(statusCode, body);
  }

  /// Dispose resources
  void dispose() {
    _httpClient.close();
  }
}
