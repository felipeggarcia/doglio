/// Custom exceptions for Doglio Marketplace
///
/// This file defines all custom exceptions that can occur
/// throughout the application layers.
library;

/// Base class for all custom exceptions
abstract class DoglioException implements Exception {
  const DoglioException(this.message);

  final String message;

  @override
  String toString() => 'DoglioException: $message';
}

/// Server-related exceptions
class ServerException extends DoglioException {
  const ServerException(super.message);

  @override
  String toString() => 'ServerException: $message';
}

/// Network-related exceptions
class NetworkException extends DoglioException {
  const NetworkException(super.message);

  @override
  String toString() => 'NetworkException: $message';
}

/// Authentication-related exceptions
class AuthException extends DoglioException {
  const AuthException(super.message);

  @override
  String toString() => 'AuthException: $message';
}

/// Validation-related exceptions
class ValidationException extends DoglioException {
  const ValidationException(super.message);

  @override
  String toString() => 'ValidationException: $message';
}

/// Cache-related exceptions
class CacheException extends DoglioException {
  const CacheException(super.message);

  @override
  String toString() => 'CacheException: $message';
}

/// Database-related exceptions
class DatabaseException extends DoglioException {
  const DatabaseException(super.message);

  @override
  String toString() => 'DatabaseException: $message';
}

/// Permission-related exceptions
class PermissionException extends DoglioException {
  const PermissionException(super.message);

  @override
  String toString() => 'PermissionException: $message';
}

/// Product-related exceptions
class ProductException extends DoglioException {
  const ProductException(super.message);

  @override
  String toString() => 'ProductException: $message';
}

/// Cart-related exceptions
class CartException extends DoglioException {
  const CartException(super.message);

  @override
  String toString() => 'CartException: $message';
}

/// Payment-related exceptions
class PaymentException extends DoglioException {
  const PaymentException(super.message);

  @override
  String toString() => 'PaymentException: $message';
}
