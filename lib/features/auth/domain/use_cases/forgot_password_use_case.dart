/// Forgot password use case for Doglio Marketplace
///
/// This use case encapsulates the business logic for password reset.
/// It validates email and handles the password reset process.
library;

import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import 'base_use_case.dart';

/// Use case for password reset
///
/// This encapsulates all business logic related to password reset,
/// including email validation and reset email sending.
class ForgotPasswordUseCase extends UseCase<void, ForgotPasswordParams>
    with ParamsValidation {
  const ForgotPasswordUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<void> call(ForgotPasswordParams params) async {
    // 1. Validate parameters
    _validateParams(params);

    // 2. Attempt to send reset email
    try {
      await _authRepository.sendPasswordResetEmail(
        email: params.email.toLowerCase().trim(),
      );

      // 3. Additional business logic (if needed)
      // For example: log reset attempt, rate limiting, etc.
    } catch (e) {
      // 4. Handle and re-throw appropriate exceptions
      if (e is AuthException) {
        rethrow;
      }
      throw UnknownAuthException(e.toString());
    }
  }

  /// Validates forgot password parameters
  void _validateParams(ForgotPasswordParams params) {
    if (!isNotEmpty(params.email)) {
      throw const InvalidParametersException('Email is required');
    }

    if (!isValidEmail(params.email)) {
      throw const InvalidParametersException('Invalid email format');
    }
  }
}

/// Parameters for forgot password use case
class ForgotPasswordParams {
  const ForgotPasswordParams({required this.email});

  final String email;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForgotPasswordParams &&
          runtimeType == other.runtimeType &&
          email == other.email;

  @override
  int get hashCode => email.hashCode;
}

/// Use case for getting current authenticated user
class GetCurrentUserUseCase extends UseCaseNoParams<User?> {
  const GetCurrentUserUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<User?> call() async {
    try {
      return await _authRepository.getCurrentUser();
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw UnknownAuthException(e.toString());
    }
  }
}

/// Use case for signing out
class SignOutUseCase extends UseCaseNoParams<void> {
  const SignOutUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<void> call() async {
    try {
      await _authRepository.signOut();
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw UnknownAuthException(e.toString());
    }
  }
}
