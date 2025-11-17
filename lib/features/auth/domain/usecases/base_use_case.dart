/// Base use case class for authentication operations
///
/// This provides a common structure for all use cases,
/// ensuring consistent error handling and parameter validation.
library;

/// Base class for use cases
///
/// This implements the Command pattern and provides
/// consistent error handling across all use cases.
abstract class UseCase<Type, Params> {
  const UseCase();

  /// Executes the use case with the given parameters
  Future<Type> call(Params params);
}

/// Base class for use cases that don't require parameters
abstract class UseCaseNoParams<Type> {
  const UseCaseNoParams();

  /// Executes the use case without parameters
  Future<Type> call();
}

/// Parameters validation mixin
mixin ParamsValidation {
  /// Validates email format
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validates password strength
  bool isValidPassword(String password) {
    // At least 8 characters, 1 uppercase, 1 lowercase, 1 number
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password);
  }

  /// Validates name format
  bool isValidName(String name) {
    return name.trim().length >= 2 &&
        RegExp(r'^[a-zA-Z\s]+$').hasMatch(name.trim());
  }

  /// Validates that a string is not empty
  bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}

/// Exception thrown when use case parameters are invalid
class InvalidParametersException implements Exception {
  const InvalidParametersException(this.message);

  final String message;

  @override
  String toString() => 'InvalidParametersException: $message';
}
