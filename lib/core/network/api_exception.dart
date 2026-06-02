/// API Exception handling for Doglio API
///
/// Provides consistent error handling based on Laravel backend responses
library;

/// Base API exception
class ApiException implements Exception {
  const ApiException({
    required this.statusCode,
    required this.message,
    this.code,
    this.details,
    this.validationErrors,
  });

  final int statusCode;
  final String message;
  final String? code;
  final Map<String, dynamic>? details;
  final Map<String, List<String>>? validationErrors;

  factory ApiException.fromResponse(int statusCode, Map<String, dynamic> body) {
    final message = body['message'] as String? ?? 'Erro desconhecido';

    // Validation errors (422)
    if (statusCode == 422 && body.containsKey('errors')) {
      return ApiException(
        statusCode: statusCode,
        message: message,
        code: 'VALIDATION_ERROR',
        validationErrors: (body['errors'] as Map<String, dynamic>).map(
          (key, value) =>
              MapEntry(key, (value as List).map((e) => e.toString()).toList()),
        ),
      );
    }

    // Standard error format
    final error = body['error'] as Map<String, dynamic>?;
    return ApiException(
      statusCode: statusCode,
      message: message,
      code: error?['code'] as String?,
      details: error?['details'] as Map<String, dynamic>?,
    );
  }

  bool get isNetworkError => statusCode == 0;
  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isValidationError => statusCode == 422;
  bool get isRateLimited => statusCode == 429;
  bool get isServerError => statusCode >= 500;

  @override
  String toString() {
    if (validationErrors != null) {
      final errors = validationErrors!.entries
          .map((e) => '${e.key}: ${e.value.join(', ')}')
          .join('\n');
      return 'ApiException($statusCode): $message\n$errors';
    }
    return 'ApiException($statusCode): $message ${code != null ? "($code)" : ""}';
  }

  /// Get user-friendly error message
  String get userMessage {
    switch (statusCode) {
      case 0:
        return 'Erro de conexão. Verifique sua internet.';
      case 401:
        return 'Sessão expirada. Faça login novamente.';
      case 403:
        return 'Você não tem permissão para esta ação.';
      case 404:
        return 'Recurso não encontrado.';
      case 429:
        return 'Muitas tentativas. Aguarde um momento.';
      case >= 500:
        return 'Erro no servidor. Tente novamente mais tarde.';
      default:
        return message;
    }
  }

  /// Get first validation error message
  String? get firstValidationError {
    if (validationErrors == null || validationErrors!.isEmpty) return null;
    return validationErrors!.values.first.first;
  }
}

/// Specific API exceptions
class UnauthorizedException extends ApiException {
  const UnauthorizedException()
    : super(statusCode: 401, message: 'Não autenticado', code: 'UNAUTHORIZED');
}

class ForbiddenException extends ApiException {
  const ForbiddenException({String? message})
    : super(
        statusCode: 403,
        message: message ?? 'Acesso negado',
        code: 'FORBIDDEN',
      );
}

class NotFoundException extends ApiException {
  const NotFoundException({String? message})
    : super(
        statusCode: 404,
        message: message ?? 'Recurso não encontrado',
        code: 'NOT_FOUND',
      );
}

class ValidationException extends ApiException {
  const ValidationException({
    required String message,
    required Map<String, List<String>> validationErrors,
  }) : super(
         statusCode: 422,
         message: message,
         code: 'VALIDATION_ERROR',
         validationErrors: validationErrors,
       );
}

class RateLimitException extends ApiException {
  const RateLimitException()
    : super(
        statusCode: 429,
        message: 'Muitas requisições. Tente novamente em instantes.',
        code: 'RATE_LIMIT_EXCEEDED',
      );
}

class NetworkException extends ApiException {
  const NetworkException()
    : super(
        statusCode: 0,
        message: 'Erro de conexão. Verifique sua internet.',
        code: 'NETWORK_ERROR',
      );
}
