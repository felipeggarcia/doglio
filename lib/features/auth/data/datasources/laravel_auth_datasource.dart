/// Laravel API authentication datasource implementation
///
/// This class provides concrete Laravel REST API implementation for authentication
/// operations, consuming the Laravel backend endpoints.
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../../domain/repositories/auth_repository.dart' as domain;
import 'auth_remote_datasource.dart';

/// Laravel API implementation of AuthRemoteDatasource
///
/// This class handles real Laravel API authentication operations.
class LaravelAuthDatasource implements AuthRemoteDatasource {
  LaravelAuthDatasource({required this.baseUrl, http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  final String baseUrl;
  final http.Client _httpClient;
  String? _token;
  UserModel? _currentUser;

  /// Get authentication token
  Future<String?> get _authToken async {
    if (_token != null) return _token;

    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    return _token;
  }

  /// Save authentication token
  Future<void> _saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  /// Remove authentication token
  Future<void> _removeToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  /// Get headers with authentication
  Future<Map<String, String>> _getHeaders() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final token = await _authToken;
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: await _getHeaders(),
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveToken(data['token']);

        _currentUser = UserModel.fromJson(data['user']);
        return _currentUser!;
      } else if (response.statusCode == 401) {
        throw const InvalidCredentialsException();
      } else if (response.statusCode == 404) {
        throw const UserNotFoundException();
      } else {
        final error = jsonDecode(response.body);
        throw domain.UnknownAuthException(error['message'] ?? 'Login failed');
      }
    } catch (e) {
      if (e is domain.AuthException) rethrow;
      throw domain.UnknownAuthException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: await _getHeaders(),
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        await _saveToken(data['token']);

        _currentUser = UserModel.fromJson(data['user']);
        return _currentUser!;
      } else if (response.statusCode == 422) {
        final error = jsonDecode(response.body);
        if (error['errors']?['email'] != null) {
          throw const EmailAlreadyInUseException();
        }
        throw domain.UnknownAuthException(
          error['message'] ?? 'Validation failed',
        );
      } else {
        final error = jsonDecode(response.body);
        throw domain.UnknownAuthException(
          error['message'] ?? 'Registration failed',
        );
      }
    } catch (e) {
      if (e is domain.AuthException) rethrow;
      throw domain.UnknownAuthException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl/api/auth/forgot-password'),
        headers: await _getHeaders(),
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 404) {
        throw const UserNotFoundException();
      } else {
        final error = jsonDecode(response.body);
        throw domain.UnknownAuthException(
          error['message'] ?? 'Password reset failed',
        );
      }
    } catch (e) {
      if (e is domain.AuthException) rethrow;
      throw domain.UnknownAuthException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      final token = await _authToken;
      if (token != null) {
        await _httpClient.post(
          Uri.parse('$baseUrl/api/auth/logout'),
          headers: await _getHeaders(),
        );
      }
    } finally {
      await _removeToken();
      _currentUser = null;
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    if (_currentUser != null) return _currentUser;

    final token = await _authToken;
    if (token == null) return null;

    try {
      final response = await _httpClient.get(
        Uri.parse('$baseUrl/api/auth/user'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _currentUser = UserModel.fromJson(data);
        return _currentUser;
      } else if (response.statusCode == 401) {
        await _removeToken();
        return null;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    // For REST API, we simulate auth state with periodic checks
    return Stream.periodic(
      const Duration(seconds: 5),
      (_) async => await getCurrentUser(),
    ).asyncMap((futureUser) => futureUser);
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
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (profileImageUrl != null) body['profile_image_url'] = profileImageUrl;
      if (phoneNumber != null) body['phone_number'] = phoneNumber;

      final response = await _httpClient.put(
        Uri.parse('$baseUrl/api/auth/profile'),
        headers: await _getHeaders(),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _currentUser = UserModel.fromJson(data);
        return _currentUser!;
      } else if (response.statusCode == 401) {
        throw const InvalidCredentialsException();
      } else {
        final error = jsonDecode(response.body);
        throw domain.UnknownAuthException(error['message'] ?? 'Update failed');
      }
    } catch (e) {
      if (e is domain.AuthException) rethrow;
      throw domain.UnknownAuthException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteUserAccount(String userId) async {
    try {
      final response = await _httpClient.delete(
        Uri.parse('$baseUrl/api/auth/account'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        await _removeToken();
        _currentUser = null;
      } else if (response.statusCode == 401) {
        throw const InvalidCredentialsException();
      } else {
        final error = jsonDecode(response.body);
        throw domain.UnknownAuthException(error['message'] ?? 'Delete failed');
      }
    } catch (e) {
      if (e is domain.AuthException) rethrow;
      throw domain.UnknownAuthException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<void> refreshToken() async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl/api/auth/refresh'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveToken(data['token']);
      } else {
        await _removeToken();
        _currentUser = null;
        throw const InvalidCredentialsException();
      }
    } catch (e) {
      if (e is domain.AuthException) rethrow;
      throw domain.UnknownAuthException(
        'Token refresh failed: ${e.toString()}',
      );
    }
  }
}
