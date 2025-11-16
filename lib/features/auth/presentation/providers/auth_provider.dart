/// Authentication state management without external dependencies
///
/// This file contains simple providers for authentication state management
/// following Clean Architecture principles without Riverpod dependency.
library;

import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../domain/use_cases/register_use_case.dart';
import '../../domain/use_cases/forgot_password_use_case.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/laravel_auth_datasource.dart';
import '../../../../core/config/api_config.dart';

/// Simple authentication provider without external state management
///
/// This provider manages authentication state using Flutter's built-in
/// ChangeNotifier, avoiding external dependencies like Riverpod.
class AuthProvider extends ChangeNotifier {
  static AuthProvider? _instance;

  /// Singleton instance
  static AuthProvider get instance {
    _instance ??= AuthProvider._internal();
    return _instance!;
  }

  AuthProvider._internal() {
    _initializeDependencies();
  }

  // Dependencies
  late final LaravelAuthDatasource _remoteDatasource;
  late final AuthRepository _repository;
  late final LoginUseCase _loginUseCase;
  late final RegisterUseCase _registerUseCase;
  late final ForgotPasswordUseCase _forgotPasswordUseCase;

  // State
  bool _isLoading = false;
  String? _error;
  User? _currentUser;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  /// Initialize dependencies
  void _initializeDependencies() {
    _remoteDatasource = LaravelAuthDatasource(baseUrl: ApiConfig.baseUrl);
    _repository = AuthRepositoryImpl(_remoteDatasource);
    _loginUseCase = LoginUseCase(_repository);
    _registerUseCase = RegisterUseCase(_repository);
    _forgotPasswordUseCase = ForgotPasswordUseCase(_repository);
  }

  /// Performs user login
  Future<bool> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final params = LoginParams(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );

      final user = await _loginUseCase(params);
      _currentUser = user;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }

  /// Performs user registration
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required bool acceptTerms,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final params = RegisterParams(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        acceptTerms: acceptTerms,
      );

      final user = await _registerUseCase(params);
      _currentUser = user;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }

  /// Sends password reset email
  Future<bool> forgotPassword({required String email}) async {
    _setLoading(true);
    _clearError();

    try {
      final params = ForgotPasswordParams(email: email);
      await _forgotPasswordUseCase(params);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }

  /// Signs out the current user
  Future<void> signOut() async {
    _setLoading(true);

    try {
      await _repository.signOut();
      _currentUser = null;
    } catch (e) {
      _setError(_getErrorMessage(e));
    }

    _setLoading(false);
  }

  /// Clears the current error state
  void clearError() {
    _clearError();
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  /// Converts exceptions to user-friendly error messages
  String _getErrorMessage(dynamic exception) {
    switch (exception.runtimeType.toString()) {
      case 'InvalidParametersException':
        return exception.message;
      case 'InvalidCredentialsException':
        return 'Invalid email or password. Please try again.';
      case 'UserNotFoundException':
        return 'No account found with this email address.';
      case 'EmailAlreadyInUseException':
        return 'An account with this email already exists.';
      case 'WeakPasswordException':
        return 'Password is too weak. Please use a stronger password.';
      case 'NetworkException':
        return 'Network error. Please check your connection.';
      case 'AccountInactiveException':
        return 'Your account is inactive. Please contact support.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
