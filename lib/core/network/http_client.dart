/// HTTP Client abstraction for Doglio Marketplace
///
/// This file provides a clean abstraction layer for HTTP operations
/// supporting different implementations (Dio, http package, etc.).
library;

/// HTTP Methods enumeration
enum HttpMethod { get, post, put, patch, delete }

/// HTTP Response wrapper
class HttpResponse {
  const HttpResponse({
    required this.statusCode,
    required this.data,
    this.headers = const {},
  });

  final int statusCode;
  final dynamic data;
  final Map<String, dynamic> headers;

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}

/// HTTP Client interface
abstract class HttpClient {
  /// GET request
  Future<HttpResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// POST request
  Future<HttpResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// PUT request
  Future<HttpResponse> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// PATCH request
  Future<HttpResponse> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// DELETE request
  Future<HttpResponse> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// Upload file
  Future<HttpResponse> uploadFile(
    String path,
    String filePath, {
    Map<String, String>? headers,
    Map<String, dynamic>? fields,
  });
}

/// Default HTTP Client implementation
/// Note: This is a placeholder implementation
/// In production, you would implement this using Dio or similar
class HttpClientImpl implements HttpClient {
  HttpClientImpl({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 30),
  });

  final String baseUrl;
  final Duration timeout;

  @override
  Future<HttpResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    // TODO: Implement with actual HTTP client (Dio)
    throw UnimplementedError('HTTP Client not implemented yet');
  }

  @override
  Future<HttpResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    // TODO: Implement with actual HTTP client (Dio)
    throw UnimplementedError('HTTP Client not implemented yet');
  }

  @override
  Future<HttpResponse> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    // TODO: Implement with actual HTTP client (Dio)
    throw UnimplementedError('HTTP Client not implemented yet');
  }

  @override
  Future<HttpResponse> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    // TODO: Implement with actual HTTP client (Dio)
    throw UnimplementedError('HTTP Client not implemented yet');
  }

  @override
  Future<HttpResponse> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    // TODO: Implement with actual HTTP client (Dio)
    throw UnimplementedError('HTTP Client not implemented yet');
  }

  @override
  Future<HttpResponse> uploadFile(
    String path,
    String filePath, {
    Map<String, String>? headers,
    Map<String, dynamic>? fields,
  }) async {
    // TODO: Implement with actual HTTP client (Dio)
    throw UnimplementedError('HTTP Client not implemented yet');
  }
}
