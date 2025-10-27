/// Register use case for Doglio Marketplace
///
/// This use case encapsulates the business logic for user registration.
/// It validates user data and handles the account creation process.
library;

import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import 'base_use_case.dart';

/// Use case for user registration
///
/// This encapsulates all business logic related to user registration,
/// including validation, password confirmation, and account creation.
class RegisterUseCase extends UseCase<User, RegisterParams>
    with ParamsValidation {
  const RegisterUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<User> call(RegisterParams params) async {
    // 1. Validate parameters
    _validateParams(params);

    // 2. Attempt registration
    try {
      final user = await _authRepository.createUserWithEmailAndPassword(
        name: params.name.trim(),
        email: params.email.toLowerCase().trim(),
        password: params.password,
      );

      // 3. Additional business logic (if needed)
      // For example: send welcome email, create user profile, etc.

      return user;
    } catch (e) {
      // 4. Handle and re-throw appropriate exceptions
      if (e is AuthException) {
        rethrow;
      }
      throw UnknownAuthException(e.toString());
    }
  }

  /// Validates registration parameters
  void _validateParams(RegisterParams params) {
    // Name validation
    if (!isNotEmpty(params.name)) {
      throw const InvalidParametersException('Name is required');
    }

    if (!isValidName(params.name)) {
      throw const InvalidParametersException(
        'Name must contain only letters and spaces',
      );
    }

    if (params.name.trim().length < 2) {
      throw const InvalidParametersException(
        'Name must be at least 2 characters',
      );
    }

    // Email validation
    if (!isNotEmpty(params.email)) {
      throw const InvalidParametersException('Email is required');
    }

    if (!isValidEmail(params.email)) {
      throw const InvalidParametersException('Invalid email format');
    }

    // Password validation
    if (!isNotEmpty(params.password)) {
      throw const InvalidParametersException('Password is required');
    }

    if (!isValidPassword(params.password)) {
      throw const InvalidParametersException(
        'Password must be at least 8 characters with uppercase, lowercase, and number',
      );
    }

    // Confirm password validation
    if (params.password != params.confirmPassword) {
      throw const InvalidParametersException('Passwords do not match');
    }

    // Terms acceptance validation
    if (!params.acceptTerms) {
      throw const InvalidParametersException(
        'You must accept the terms and conditions',
      );
    }
  }
}

/// Parameters for register use case
class RegisterParams {
  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.acceptTerms,
  });

  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final bool acceptTerms;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegisterParams &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          email == other.email &&
          password == other.password &&
          confirmPassword == other.confirmPassword &&
          acceptTerms == other.acceptTerms;

  @override
  int get hashCode =>
      name.hashCode ^
      email.hashCode ^
      password.hashCode ^
      confirmPassword.hashCode ^
      acceptTerms.hashCode;
}
