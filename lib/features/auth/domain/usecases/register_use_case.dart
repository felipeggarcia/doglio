library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import 'base_use_case.dart';

class RegisterUseCase extends UseCase<Either<Failure, User>, RegisterParams>
    with ParamsValidation {
  const RegisterUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    if (!isNotEmpty(params.name)) {
      return const Left(ValidationFailure({'name': ['Nome é obrigatório']}));
    }
    if (!isValidName(params.name)) {
      return const Left(
          ValidationFailure({'name': ['Use apenas letras e espaços']}));
    }
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
    if (!isValidPassword(params.password)) {
      return const Left(ValidationFailure({
        'password': ['Mínimo 8 caracteres com maiúscula, minúscula e número']
      }));
    }
    if (params.password != params.confirmPassword) {
      return const Left(
          ValidationFailure({'confirmPassword': ['Senhas não coincidem']}));
    }
    if (!params.acceptTerms) {
      return const Left(
          ValidationFailure({'terms': ['Aceite os termos para continuar']}));
    }

    return _authRepository.createUserWithEmailAndPassword(
      name: params.name.trim(),
      email: params.email.toLowerCase().trim(),
      password: params.password,
    );
  }
}

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
