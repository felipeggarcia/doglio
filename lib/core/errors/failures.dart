/// Failure classes for error handling in Doglio Marketplace
///
/// This file defines failure objects used throughout the application
/// following the Either pattern for clean error handling.
library;

/// Base class for all failures
abstract class Failure {
  const Failure(this.message);

  final String message;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() => 'Failure: $message';
}

/// Server failure - when server returns an error
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Network failure - when there's no internet connection
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Authentication failure - when auth operations fail
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Validation failure - when input validation fails
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Cache failure - when local storage operations fail
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Database failure - when database operations fail
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

/// Permission failure - when permissions are denied
class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

/// Product failure - when product operations fail
class ProductFailure extends Failure {
  const ProductFailure(super.message);
}

/// Cart failure - when cart operations fail
class CartFailure extends Failure {
  const CartFailure(super.message);
}

/// Payment failure - when payment operations fail
class PaymentFailure extends Failure {
  const PaymentFailure(super.message);
}

/// Unknown failure - for unexpected errors
class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
