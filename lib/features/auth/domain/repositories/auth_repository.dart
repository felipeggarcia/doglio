/// Authentication repository contract
library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> sendPasswordResetEmail({required String email});

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, User?>> getCurrentUser();
}

// ─── Exceptions do datasource (usadas internamente na camada data) ─────────────

abstract class AuthException implements Exception {
  const AuthException(this.message, this.code);
  final String message;
  final String code;
  @override
  String toString() => 'AuthException($code): $message';
}

class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException()
      : super('Invalid email or password', 'invalid-credentials');
}

class UserNotFoundException extends AuthException {
  const UserNotFoundException() : super('User not found', 'user-not-found');
}

class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException()
      : super('Email is already in use', 'email-already-in-use');
}

class WeakPasswordException extends AuthException {
  const WeakPasswordException()
      : super('Password is too weak', 'weak-password');
}

class NetworkException extends AuthException {
  const NetworkException() : super('Network error occurred', 'network-error');
}

class AccountInactiveException extends AuthException {
  const AccountInactiveException()
      : super('Account is inactive', 'account-inactive');
}

class UnknownAuthException extends AuthException {
  const UnknownAuthException(String message) : super(message, 'unknown-error');
}
