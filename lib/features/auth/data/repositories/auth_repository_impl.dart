/// Authentication repository implementation
///
/// This class implements the AuthRepository contract from the domain layer,
/// providing concrete implementation using remote datasources.
library;

import '../datasources/auth_remote_datasource.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart' as domain;

/// Implementation of AuthRepository
///
/// This class bridges the domain and data layers,
/// converting between entities and models.
class AuthRepositoryImpl implements domain.AuthRepository {
  const AuthRepositoryImpl(this._remoteDatasource);

  final AuthRemoteDatasource _remoteDatasource;

  @override
  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDatasource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userModel; // UserModel extends User
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<User> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDatasource.createUserWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      );
      return userModel; // UserModel extends User
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _remoteDatasource.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _remoteDatasource.signOut();
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final userModel = await _remoteDatasource.getCurrentUser();
      return userModel; // UserModel extends User
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Stream<User?> get authStateChanges {
    return _remoteDatasource.authStateChanges; // UserModel extends User
  }

  @override
  Future<bool> get isAuthenticated async {
    try {
      return await _remoteDatasource.isAuthenticated;
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<User> updateUserProfile({
    required String userId,
    String? name,
    String? profileImageUrl,
    String? phoneNumber,
  }) async {
    try {
      final userModel = await _remoteDatasource.updateUserProfile(
        userId: userId,
        name: name,
        profileImageUrl: profileImageUrl,
        phoneNumber: phoneNumber,
      );
      return userModel; // UserModel extends User
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<void> deleteUserAccount(String userId) async {
    try {
      await _remoteDatasource.deleteUserAccount(userId);
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<void> refreshToken() async {
    try {
      await _remoteDatasource.refreshToken();
    } catch (e) {
      throw _handleException(e);
    }
  }

  /// Handles exceptions from datasource and converts them to domain exceptions
  domain.AuthException _handleException(dynamic e) {
    if (e is domain.AuthException) {
      return e;
    }

    // Convert datasource exceptions to domain exceptions
    switch (e.runtimeType.toString()) {
      case 'UserNotFoundException':
        return const domain.UserNotFoundException();
      case 'InvalidCredentialsException':
        return const domain.InvalidCredentialsException();
      case 'EmailAlreadyInUseException':
        return const domain.EmailAlreadyInUseException();
      default:
        return domain.UnknownAuthException(e.toString());
    }
  }
}
