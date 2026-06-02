/// Authentication controller for Clean Architecture
///
/// This controller manages authentication operations using Use Cases.
/// It provides a clean interface between UI and business logic.
library;

import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/base_use_case.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/register_use_case.dart';
import '../../domain/usecases/forgot_password_use_case.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/laravel_auth_datasource.dart';
import '../providers/auth_provider.dart';


/// Authentication controller following Clean Architecture
///
/// This controller acts as an intermediary between the UI and Use Cases,
/// managing authentication state and operations.
class AuthController extends ChangeNotifier {
  AuthController() {
    _initializeDependencies();
  }

  // Dependencies
  late final LaravelAuthDatasource _remoteDatasource;
  late final AuthRepositoryImpl _repository;
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

  void _initializeDependencies() {
    _remoteDatasource = LaravelAuthDatasource();
    _repository = AuthRepositoryImpl(_remoteDatasource);
    _loginUseCase = LoginUseCase(_repository);
    _registerUseCase = RegisterUseCase(_repository);
    _forgotPasswordUseCase = ForgotPasswordUseCase(_repository);
  }

  /// Performs user login using LoginUseCase
  ///
  /// This method encapsulates all business logic for authentication,
  /// including validation and error handling.
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
      AuthProvider.instance.setUser(user);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }

  /// Performs user registration using RegisterUseCase
  ///
  /// This method handles all business logic for user registration,
  /// including validation and error handling.
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

  /// Sends password reset email using ForgotPasswordUseCase
  ///
  /// This method handles the business logic for password reset,
  /// including validation and error handling.
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

  /// Converts exceptions to user-friendly error messages in Portuguese
  String _getErrorMessage(dynamic exception) {
    if (exception is InvalidParametersException) {
      return exception.message;
    }
    if (exception is InvalidCredentialsException) {
      return 'E-mail ou senha inválidos.';
    }
    if (exception is UserNotFoundException) {
      return 'Nenhuma conta encontrada com este e-mail.';
    }
    if (exception is EmailAlreadyInUseException) {
      return 'Já existe uma conta com este e-mail.';
    }
    if (exception is AccountInactiveException) {
      return 'Sua conta foi desativada. Entre em contato com o suporte.';
    }
    if (exception is WeakPasswordException) {
      return 'Senha muito fraca. Use uma senha mais segura.';
    }
    if (exception is NetworkException) {
      return 'Erro de conexão. Verifique sua internet.';
    }
    return 'Ocorreu um erro inesperado. Tente novamente.';
  }

}
