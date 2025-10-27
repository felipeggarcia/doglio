/// Authentication remote datasource contract
///
/// This abstract class defines the contract for remote authentication operations.
/// It abstracts the specific implementation details (Firebase, REST API, etc).
library;

import '../models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';

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

/// Implementation of AuthRemoteDatasource using simulation
///
/// This is a mock implementation for development/testing.
/// In production, this would be replaced with Firebase implementation.
class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  // Simulated user database
  final Map<String, UserModel> _users = {
    'test@doglio.com': UserModel(
      id: 'user_1',
      email: 'test@doglio.com',
      name: 'Test User',
      role: UserRole.user,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    'admin@doglio.com': UserModel(
      id: 'admin_1',
      email: 'admin@doglio.com',
      name: 'Admin User',
      role: UserRole.admin,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    ),
  };

  // Simulated current user
  UserModel? _currentUser;

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulate authentication logic
    if (email == 'test@doglio.com' && password == 'Test123!') {
      _currentUser = _users[email]!;
      return _currentUser!;
    } else if (email == 'admin@doglio.com' && password == 'Admin123!') {
      _currentUser = _users[email]!;
      return _currentUser!;
    } else if (!_users.containsKey(email)) {
      throw const UserNotFoundException();
    } else {
      throw const InvalidCredentialsException();
    }
  }

  @override
  Future<UserModel> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Check if email already exists
    if (_users.containsKey(email)) {
      throw const EmailAlreadyInUseException();
    }

    // Create new user
    final newUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: name,
      role: UserRole.user,
      isActive: true,
      createdAt: DateTime.now(),
    );

    // Save to simulated database
    _users[email] = newUser;
    _currentUser = newUser;

    return newUser;
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Check if user exists
    if (!_users.containsKey(email)) {
      throw const UserNotFoundException();
    }

    // Simulate email sending (would integrate with email service)
    print('Password reset email sent to: $email');
  }

  @override
  Future<void> signOut() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    _currentUser = null;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    return _currentUser;
  }

  @override
  Stream<UserModel?> get authStateChanges {
    // Simulate auth state stream
    return Stream.periodic(
      const Duration(seconds: 1),
      (_) => _currentUser,
    ).distinct();
  }

  @override
  Future<bool> get isAuthenticated async {
    final user = await getCurrentUser();
    return user != null;
  }

  @override
  Future<UserModel> updateUserProfile({
    required String userId,
    String? name,
    String? profileImageUrl,
    String? phoneNumber,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (_currentUser?.id != userId) {
      throw const InvalidCredentialsException();
    }

    final updatedUser = _currentUser!.copyWith(
      name: name ?? _currentUser!.name,
      profileImageUrl: profileImageUrl ?? _currentUser!.profileImageUrl,
      phoneNumber: phoneNumber ?? _currentUser!.phoneNumber,
    );

    _currentUser = updatedUser;
    _users[updatedUser.email] = updatedUser;

    return updatedUser;
  }

  @override
  Future<void> deleteUserAccount(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (_currentUser?.id != userId) {
      throw const InvalidCredentialsException();
    }

    _users.remove(_currentUser!.email);
    _currentUser = null;
  }

  @override
  Future<void> refreshToken() async {
    // Simulate token refresh
    await Future.delayed(const Duration(milliseconds: 500));

    if (_currentUser == null) {
      throw const InvalidCredentialsException();
    }
  }
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
