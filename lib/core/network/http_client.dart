/// HTTP client wrapper for Doglio API — com Host header para Laragon
library;

import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../config/environment.dart';
import '../errors/exceptions.dart';
import '../storage/secure_storage.dart';
import '../utils/app_logger.dart';
import 'api_response.dart';

/// HTTP client for Doglio API with automatic token management
class DoglioHttpClient {
  DoglioHttpClient({http.Client? httpClient, SecureStorage? secureStorage})
    : _httpClient = httpClient ?? http.Client(),
      _secureStorage = secureStorage ?? SecureStorage();

  final http.Client _httpClient;
  final SecureStorage _secureStorage;

  Map<String, String> _getBaseHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Host': ApiConfig.virtualHost,
    };
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final headers = _getBaseHeaders();
    final token = await _secureStorage.getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParams,
    bool requiresAuth = false,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint')
          .replace(queryParameters: queryParams);

      if (EnvironmentConfig.enableApiLogging) AppLogger.d('→ GET $uri');

      final headers =
          requiresAuth ? await _getAuthHeaders() : _getBaseHeaders();

      final response =
          await _httpClient.get(uri, headers: headers).timeout(ApiConfig.timeout);

      return _handleResponse<T>(response);
    } on TimeoutException {
      throw const NetworkException();
    } on http.ClientException {
      throw const NetworkException();
    } catch (e) {
      if (e is DoglioException) rethrow;
      throw const NetworkException();
    }
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers =
          requiresAuth ? await _getAuthHeaders() : _getBaseHeaders();

      final response = await _httpClient
          .post(uri, headers: headers, body: body != null ? jsonEncode(body) : null)
          .timeout(ApiConfig.timeout);

      return _handleResponse<T>(response);
    } on TimeoutException {
      throw const NetworkException();
    } on http.ClientException {
      throw const NetworkException();
    } catch (e) {
      if (e is DoglioException) rethrow;
      throw const NetworkException();
    }
  }

  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers =
          requiresAuth ? await _getAuthHeaders() : _getBaseHeaders();

      final response = await _httpClient
          .put(uri, headers: headers, body: body != null ? jsonEncode(body) : null)
          .timeout(ApiConfig.timeout);

      return _handleResponse<T>(response);
    } on TimeoutException {
      throw const NetworkException();
    } on http.ClientException {
      throw const NetworkException();
    } catch (e) {
      if (e is DoglioException) rethrow;
      throw const NetworkException();
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    bool requiresAuth = false,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers =
          requiresAuth ? await _getAuthHeaders() : _getBaseHeaders();

      final response =
          await _httpClient.delete(uri, headers: headers).timeout(ApiConfig.timeout);

      return _handleResponse<T>(response);
    } on TimeoutException {
      throw const NetworkException();
    } on http.ClientException {
      throw const NetworkException();
    } catch (e) {
      if (e is DoglioException) rethrow;
      throw const NetworkException();
    }
  }

  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers =
          requiresAuth ? await _getAuthHeaders() : _getBaseHeaders();

      final response = await _httpClient
          .patch(uri, headers: headers, body: body != null ? jsonEncode(body) : null)
          .timeout(ApiConfig.timeout);

      return _handleResponse<T>(response);
    } on TimeoutException {
      throw const NetworkException();
    } on http.ClientException {
      throw const NetworkException();
    } catch (e) {
      if (e is DoglioException) rethrow;
      throw const NetworkException();
    }
  }

  ApiResponse<T> _handleResponse<T>(http.Response response) {
    final statusCode = response.statusCode;

    if (EnvironmentConfig.enableApiLogging) {
      AppLogger.d('← ${response.request?.method} ${response.request?.url} [$statusCode]');
    }

    if (statusCode == 204) {
      return ApiResponse<T>(success: true, message: 'Success');
    }

    if (response.body.isEmpty) {
      throw ServerException('Empty response from server', statusCode: statusCode);
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final message = body['message'] as String? ?? 'Erro $statusCode';

    if (statusCode >= 200 && statusCode < 300) {
      return ApiResponse<T>.fromJson(body);
    }

    switch (statusCode) {
      case 401:
        throw const UnauthorizedException();
      case 403:
        throw const ForbiddenException();
      case 404:
        throw const NotFoundException();
      case 422:
        final rawErrors = body['errors'] as Map<String, dynamic>?;
        final errors = rawErrors?.map(
              (k, v) => MapEntry(k, (v as List).map((e) => e.toString()).toList()),
            ) ??
            const {};
        throw ValidationException(message, errors: errors);
      case 429:
        throw const RateLimitException();
      default:
        throw ServerException(message, statusCode: statusCode);
    }
  }

  /// Executes an authenticated request and returns the raw [http.Response].
  ///
  /// Use this from admin datasources that need custom response parsing
  /// (paginated lists, multipart, DELETE with body, etc.).
  /// Auth, timeout, logging and error-throwing are all handled here.
  Future<http.Response> send(
    String method,
    String endpoint, {
    Map<String, String>? queryParams,
    Object? body,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint')
          .replace(queryParameters: queryParams);

      if (EnvironmentConfig.enableApiLogging) AppLogger.d('→ $method $uri');

      final headers = await _getAuthHeaders();
      final encodedBody = body != null
          ? (body is String ? body : jsonEncode(body))
          : null;

      final http.Response response;
      switch (method.toUpperCase()) {
        case 'GET':
          response = await _httpClient
              .get(uri, headers: headers)
              .timeout(ApiConfig.timeout);
        case 'POST':
          response = await _httpClient
              .post(uri, headers: headers, body: encodedBody)
              .timeout(ApiConfig.timeout);
        case 'PUT':
          response = await _httpClient
              .put(uri, headers: headers, body: encodedBody)
              .timeout(ApiConfig.timeout);
        case 'PATCH':
          response = await _httpClient
              .patch(uri, headers: headers, body: encodedBody)
              .timeout(ApiConfig.timeout);
        case 'DELETE' when encodedBody != null:
          // http.Client.delete() does not accept a body — use generic send().
          final req = http.Request(method, uri)
            ..headers.addAll(headers)
            ..body = encodedBody;
          final streamed = await _httpClient.send(req).timeout(ApiConfig.timeout);
          response = await http.Response.fromStream(streamed);
        default:
          response = await _httpClient
              .delete(uri, headers: headers)
              .timeout(ApiConfig.timeout);
      }

      _throwIfError(response);
      return response;
    } on TimeoutException {
      throw const NetworkException();
    } on http.ClientException {
      throw const NetworkException();
    } catch (e) {
      if (e is DoglioException) rethrow;
      throw const NetworkException();
    }
  }

  /// Sends a multipart request (file uploads) with auth headers injected.
  ///
  /// The caller builds and populates the [http.MultipartRequest] — this method
  /// adds auth/Host headers, enforces timeout, and throws on error.
  Future<http.Response> sendMultipart(http.MultipartRequest request) async {
    try {
      if (EnvironmentConfig.enableApiLogging) {
        AppLogger.d('→ ${request.method} ${request.url} [multipart]');
      }

      final token = await _secureStorage.getToken();
      request.headers.addAll({
        'Accept': 'application/json',
        'Host': ApiConfig.virtualHost,
        if (token != null) 'Authorization': 'Bearer $token',
      });

      final streamed = await _httpClient.send(request).timeout(ApiConfig.timeout);
      final response = await http.Response.fromStream(streamed);
      _throwIfError(response);
      return response;
    } on TimeoutException {
      throw const NetworkException();
    } on http.ClientException {
      throw const NetworkException();
    } catch (e) {
      if (e is DoglioException) rethrow;
      throw const NetworkException();
    }
  }

  void _throwIfError(http.Response response) {
    final statusCode = response.statusCode;

    if (EnvironmentConfig.enableApiLogging) {
      AppLogger.d('← ${response.request?.method} ${response.request?.url} [$statusCode]');
    }

    if (statusCode >= 200 && statusCode < 300) return;
    if (statusCode == 204) return;

    final Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw ServerException('Erro $statusCode', statusCode: statusCode);
    }

    final message = body['message'] as String? ?? 'Erro $statusCode';

    switch (statusCode) {
      case 401:
        throw const UnauthorizedException();
      case 403:
        throw const ForbiddenException();
      case 404:
        throw const NotFoundException();
      case 422:
        final rawErrors = body['errors'] as Map<String, dynamic>?;
        final errors = rawErrors?.map(
              (k, v) => MapEntry(k, (v as List).map((e) => e.toString()).toList()),
            ) ??
            const {};
        throw ValidationException(message, errors: errors);
      case 429:
        throw const RateLimitException();
      default:
        throw ServerException(message, statusCode: statusCode);
    }
  }

  void dispose() => _httpClient.close();
}
