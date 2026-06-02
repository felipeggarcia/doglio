/// Secure storage for sensitive data
///
/// Uses flutter_secure_storage for token and credentials
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _keyToken = 'auth_token';
  static const _keyUserId = 'user_id';
  static const _keyUserEmail = 'user_email';

  /// Save authentication token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  /// Get authentication token
  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  /// Delete authentication token
  Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }

  /// Check if user is authenticated
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Save user ID
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _keyUserId, value: userId);
  }

  /// Get user ID
  Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }

  /// Save user email
  Future<void> saveUserEmail(String email) async {
    await _storage.write(key: _keyUserEmail, value: email);
  }

  /// Get user email
  Future<String?> getUserEmail() async {
    return await _storage.read(key: _keyUserEmail);
  }

  /// Clear all stored data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
