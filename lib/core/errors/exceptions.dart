/// Custom exceptions for Doglio Marketplace
library;

abstract class DoglioException implements Exception {
  const DoglioException(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

class ServerException extends DoglioException {
  const ServerException(super.message, {this.statusCode = 500});
  final int statusCode;
}

class NetworkException extends DoglioException {
  const NetworkException([super.message = 'Sem conexão com a internet.']);
}

class AuthException extends DoglioException {
  const AuthException(super.message);
}

/// 401 — token ausente ou expirado.
class UnauthorizedException extends DoglioException {
  const UnauthorizedException([super.message = 'Sessão expirada. Faça login novamente.']);
}

/// 403 — sem permissão.
class ForbiddenException extends DoglioException {
  const ForbiddenException([super.message = 'Acesso negado.']);
}

/// 404 — recurso não existe.
class NotFoundException extends DoglioException {
  const NotFoundException([super.message = 'Recurso não encontrado.']);
}

/// 422 — erros de validação do backend.
class ValidationException extends DoglioException {
  const ValidationException(super.message, {this.errors = const {}});
  final Map<String, List<String>> errors;
}

/// 429 — rate limit.
class RateLimitException extends DoglioException {
  const RateLimitException([super.message = 'Muitas tentativas. Aguarde um momento.']);
}

class CacheException extends DoglioException {
  const CacheException(super.message);
}

class DatabaseException extends DoglioException {
  const DatabaseException(super.message);
}

class PermissionException extends DoglioException {
  const PermissionException(super.message);
}

class ProductException extends DoglioException {
  const ProductException(super.message);
}

class CartException extends DoglioException {
  const CartException(super.message);
}

class PaymentException extends DoglioException {
  const PaymentException(super.message);
}
