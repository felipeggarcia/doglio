library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/datasources/laravel_auth_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/register_use_case.dart';
import '../../domain/usecases/forgot_password_use_case.dart';

// ─── Estado de autenticação ────────────────────────────────────────────────────

sealed class AuthState {
  const AuthState();
}

class Authenticated extends AuthState {
  const Authenticated(this.user);
  final User user;
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class AuthNotifier extends AsyncNotifier<AuthState> {
  late final AuthRepository _repository;
  late final LoginUseCase _loginUseCase;
  late final RegisterUseCase _registerUseCase;
  late final ForgotPasswordUseCase _forgotPasswordUseCase;

  @override
  Future<AuthState> build() async {
    final datasource = LaravelAuthDatasource();
    _repository = AuthRepositoryImpl(datasource);
    _loginUseCase = LoginUseCase(_repository);
    _registerUseCase = RegisterUseCase(_repository);
    _forgotPasswordUseCase = ForgotPasswordUseCase(_repository);

    final result = await _repository.getCurrentUser();
    return result.fold(
      (_) => const Unauthenticated(),
      (user) => user != null ? Authenticated(user) : const Unauthenticated(),
    );
  }

  /// Retorna Either para a UI poder exibir erros de validação/servidor
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    final result = await _loginUseCase(
      LoginParams(email: email, password: password),
    );
    result.fold(
      (_) => null,
      (user) => state = AsyncData(Authenticated(user)),
    );
    return result;
  }

  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required bool acceptTerms,
  }) async {
    final result = await _registerUseCase(
      RegisterParams(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        acceptTerms: acceptTerms,
      ),
    );
    result.fold(
      (_) => null,
      (user) => state = AsyncData(Authenticated(user)),
    );
    return result;
  }

  Future<Either<Failure, void>> forgotPassword({required String email}) =>
      _forgotPasswordUseCase(ForgotPasswordParams(email: email));

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AsyncData(Unauthenticated());
  }

  User? get currentUser {
    final s = state.valueOrNull;
    return s is Authenticated ? s.user : null;
  }

  bool get isAuthenticated => state.valueOrNull is Authenticated;
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final authProvider =
    AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
