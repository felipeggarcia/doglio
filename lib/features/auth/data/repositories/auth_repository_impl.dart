/// Authentication repository implementation
library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDatasource);

  final AuthRemoteDatasource _remoteDatasource;

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remoteDatasource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(user.toEntity());
    } on InvalidCredentialsException {
      return const Left(AuthFailure('E-mail ou senha inválidos.'));
    } on AccountInactiveException {
      return const Left(ForbiddenFailure());
    } on NetworkException {
      return const Left(NetworkFailure());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remoteDatasource.createUserWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      );
      return Right(user.toEntity());
    } on EmailAlreadyInUseException {
      return const Left(AuthFailure('E-mail já está em uso.'));
    } on WeakPasswordException {
      return const Left(AuthFailure('Senha muito fraca.'));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _remoteDatasource.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on NetworkException {
      return const Left(NetworkFailure());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _remoteDatasource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await _remoteDatasource.getCurrentUser();
      return Right(user?.toEntity());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
