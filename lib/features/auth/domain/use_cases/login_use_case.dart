/// Login use case for Doglio Marketplace
///
/// This use case encapsulates the business logic for user authentication.
/// It validates credentials and handles the login process.
library;

import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import 'base_use_case.dart';

/// Use case for user login
///
/// This encapsulates all business logic related to user authentication,
/// including validation and error handling.
class LoginUseCase extends UseCase<User, LoginParams> with ParamsValidation {
  const LoginUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<User> call(LoginParams params) async {
    // 1. Validate parameters
    _validateParams(params);

    // 2. Attempt authentication
    try {
      final user = await _authRepository.signInWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );

      // 3. Additional business logic (if needed)
      // For example: check if account is active, log login attempt, etc.
      if (!user.isActive) {
        throw const AccountInactiveException();
      }

      return user;
    } catch (e) {
      // 4. Handle and re-throw appropriate exceptions
      if (e is AuthException) {
        rethrow;
      }
      throw UnknownAuthException(e.toString());
    }
  }

  /// Validates login parameters
  void _validateParams(LoginParams params) {
    if (!isNotEmpty(params.email)) {
      throw const InvalidParametersException('Email is required');
    }

    if (!isValidEmail(params.email)) {
      throw const InvalidParametersException('Invalid email format');
    }

    if (!isNotEmpty(params.password)) {
      throw const InvalidParametersException('Password is required');
    }

    if (params.password.length < 6) {
      throw const InvalidParametersException(
        'Password must be at least 6 characters',
      );
    }
  }
}

/// Parameters for login use case
class LoginParams {
  const LoginParams({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  final String email;
  final String password;
  final bool rememberMe;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginParams &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          password == other.password &&
          rememberMe == other.rememberMe;

  @override
  int get hashCode => email.hashCode ^ password.hashCode ^ rememberMe.hashCode;
}

/// Exception thrown when account is inactive
class AccountInactiveException extends AuthException {
  const AccountInactiveException()
    : super('Account is inactive. Please contact support.', 'account-inactive');
}
