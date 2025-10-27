/// Authentication repository contract
///
/// This abstract class defines the contract for authentication operations.
/// It's independent of implementation details and frameworks.
library;

import '../entities/user.dart';

/// Repository contract for authentication operations
///
/// This interface defines all authentication-related operations
/// that can be performed in the domain layer.
abstract class AuthRepository {
  /// Authenticates a user with email and password
  ///
  /// Returns the authenticated user on success.
  /// Throws [AuthException] on failure.
  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Creates a new user account
  ///
  /// Returns the created user on success.
  /// Throws [AuthException] on failure.
  Future<User> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  /// Sends a password reset email
  ///
  /// Throws [AuthException] on failure.
  Future<void> sendPasswordResetEmail({required String email});

  /// Signs out the current user
  Future<void> signOut();

  /// Gets the currently authenticated user
  ///
  /// Returns null if no user is authenticated.
  Future<User?> getCurrentUser();

  /// Stream of authentication state changes
  ///
  /// Emits the current user when authenticated, null when not.
  Stream<User?> get authStateChanges;

  /// Checks if a user is currently authenticated
  Future<bool> get isAuthenticated;

  /// Updates user profile information
  Future<User> updateUserProfile({
    required String userId,
    String? name,
    String? profileImageUrl,
    String? phoneNumber,
  });

  /// Deletes the user account
  Future<void> deleteUserAccount(String userId);

  /// Refreshes the current user's token
  Future<void> refreshToken();
}

/// Authentication exceptions
abstract class AuthException implements Exception {
  const AuthException(this.message, this.code);

  final String message;
  final String code;

  @override
  String toString() => 'AuthException($code): $message';
}

/// Specific authentication exceptions
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

class UnknownAuthException extends AuthException {
  const UnknownAuthException(String message) : super(message, 'unknown-error');
}
