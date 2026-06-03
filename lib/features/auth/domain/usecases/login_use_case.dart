library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import 'base_use_case.dart';

class LoginUseCase extends UseCase<Either<Failure, User>, LoginParams>
    with ParamsValidation {
  const LoginUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    if (!isNotEmpty(params.email)) {
      return const Left(ValidationFailure({'email': ['E-mail é obrigatório']}));
    }
    if (!isValidEmail(params.email)) {
      return const Left(ValidationFailure({'email': ['E-mail inválido']}));
    }
    if (!isNotEmpty(params.password)) {
      return const Left(
          ValidationFailure({'password': ['Senha é obrigatória']}));
    }
    if (params.password.length < 6) {
      return const Left(
          ValidationFailure({'password': ['Mínimo 6 caracteres']}));
    }

    return _authRepository.signInWithEmailAndPassword(
      email: params.email.trim(),
      password: params.password,
    );
  }
}

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
