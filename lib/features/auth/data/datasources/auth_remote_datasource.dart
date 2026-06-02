/// Authentication remote datasource contract
///
/// This abstract class defines the contract for remote authentication operations.
/// It abstracts the specific implementation details (Laravel API, REST API, etc).
library;

import '../models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

/// Remote datasource contract for authentication operations
///
/// This interface defines low-level data access operations
/// for authentication, independent of the specific backend.
abstract class AuthRemoteDatasource {
  /// Authenticates user with email and password
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Creates a new user account
  Future<UserModel> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  /// Sends password reset email
  Future<void> sendPasswordResetEmail({required String email});

  /// Signs out current user
  Future<void> signOut();

  /// Gets current authenticated user
  Future<UserModel?> getCurrentUser();

  /// Stream of authentication state changes
  Stream<UserModel?> get authStateChanges;

  /// Checks if user is authenticated
  Future<bool> get isAuthenticated;

  /// Updates user profile
  Future<UserModel> updateUserProfile({
    required String userId,
    String? name,
    String? profileImageUrl,
    String? phoneNumber,
  });

  /// Deletes user account
  Future<void> deleteUserAccount(String userId);

  /// Refreshes authentication token
  Future<void> refreshToken();
}

/// Authentication exceptions (imported from domain)
class UserNotFoundException extends AuthException {
  const UserNotFoundException() : super('User not found', 'user-not-found');
}

class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException()
    : super('Invalid credentials', 'invalid-credentials');
}

class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException()
    : super('Email already in use', 'email-already-in-use');
}
