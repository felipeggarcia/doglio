library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import 'base_use_case.dart';

class ForgotPasswordUseCase
    extends UseCase<Either<Failure, void>, ForgotPasswordParams>
    with ParamsValidation {
  const ForgotPasswordUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, void>> call(ForgotPasswordParams params) async {
    if (!isNotEmpty(params.email)) {
      return const Left(ValidationFailure({'email': ['E-mail é obrigatório']}));
    }
    if (!isValidEmail(params.email)) {
      return const Left(ValidationFailure({'email': ['E-mail inválido']}));
    }
    return _authRepository.sendPasswordResetEmail(
      email: params.email.toLowerCase().trim(),
    );
  }
}

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

class GetCurrentUserUseCase extends UseCaseNoParams<Either<Failure, User?>> {
  const GetCurrentUserUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, User?>> call() => _authRepository.getCurrentUser();
}

class SignOutUseCase extends UseCaseNoParams<Either<Failure, void>> {
  const SignOutUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, void>> call() => _authRepository.signOut();
}
