/// Laravel API authentication datasource implementation
library;

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_remote_datasource.dart';

/// Laravel API implementation of [AuthRemoteDatasource]
class LaravelAuthDatasource implements AuthRemoteDatasource {
  LaravelAuthDatasource({http.Client? httpClient, SecureStorage? secureStorage})
    : _httpClient = httpClient ?? http.Client(),
      _secureStorage = secureStorage ?? SecureStorage();

  final http.Client _httpClient;
  final SecureStorage _secureStorage;
  final _authStateController = StreamController<UserModel?>.broadcast();

  Map<String, String> _baseHeaders() => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Host': ApiConfig.virtualHost,
  };

  Future<Map<String, String>> _authHeaders() async {
    final headers = _baseHeaders();
    final token = await _secureStorage.getToken();
    if (token != null) headers['Authorization'] = 'Bearer $token';
    return headers;
  }

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/login');
      final headers = _baseHeaders();
      final body = jsonEncode({'email': email, 'password': password});

      final response = await _httpClient
          .post(uri, headers: headers, body: body)
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final data = body['data'] as Map<String, dynamic>;
        await _secureStorage.saveToken(data['token'] as String);
        final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
        _authStateController.add(user);
        return user;
      } else if (response.statusCode == 401) {
        throw const InvalidCredentialsException();
      } else if (response.statusCode == 403) {
        throw const AccountInactiveException();
      } else {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        throw UnknownAuthException(
          body['message'] as String? ?? 'Login failed',
        );
      }
    } on AuthException {
      rethrow;
    } catch (e) {
      throw UnknownAuthException('Network error: $e');
    }
  }

  @override
  Future<UserModel> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _httpClient
          .post(
            Uri.parse('${ApiConfig.baseUrl}/register'),
            headers: _baseHeaders(),
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
              'password_confirmation': password,
            }),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 201) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final data = body['data'] as Map<String, dynamic>;
        await _secureStorage.saveToken(data['token'] as String);
        final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
        _authStateController.add(user);
        return user;
      } else if (response.statusCode == 422) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        if ((body['errors'] as Map<String, dynamic>?)?.containsKey('email') ==
            true) {
          throw const EmailAlreadyInUseException();
        }
        throw UnknownAuthException(
          body['message'] as String? ?? 'Validation failed',
        );
      } else {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        throw UnknownAuthException(
          body['message'] as String? ?? 'Registration failed',
        );
      }
    } on AuthException {
      rethrow;
    } catch (e) {
      throw UnknownAuthException('Network error: $e');
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      final response = await _httpClient
          .post(
            Uri.parse('${ApiConfig.baseUrl}/forgot-password'),
            headers: _baseHeaders(),
            body: jsonEncode({'email': email}),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) return;
      if (response.statusCode == 404) throw const UserNotFoundException();
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      throw UnknownAuthException(
        body['message'] as String? ?? 'Password reset failed',
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      throw UnknownAuthException('Network error: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      final headers = await _authHeaders();
      await _httpClient
          .post(Uri.parse('${ApiConfig.baseUrl}/logout'), headers: headers)
          .timeout(ApiConfig.timeout);
    } finally {
      await _secureStorage.clearAll();
      _authStateController.add(null);
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final token = await _secureStorage.getToken();
    if (token == null) return null;

    try {
      final response = await _httpClient
          .get(
            Uri.parse('${ApiConfig.baseUrl}/user'),
            headers: await _authHeaders(),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return UserModel.fromJson(body['data'] as Map<String, dynamic>);
      }
      if (response.statusCode == 401) {
        await _secureStorage.clearAll();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Stream<UserModel?> get authStateChanges => _authStateController.stream;

  @override
  Future<bool> get isAuthenticated async =>
      (await _secureStorage.getToken()) != null;

  @override
  Future<UserModel> updateUserProfile({
    required String userId,
    String? name,
    String? profileImageUrl,
    String? phoneNumber,
  }) {
    throw UnimplementedError('updateUserProfile not yet implemented');
  }

  @override
  Future<void> deleteUserAccount(String userId) {
    throw UnimplementedError('deleteUserAccount not yet implemented');
  }

  @override
  Future<void> refreshToken() async {
    // Sanctum tokens do not expire — no-op
  }

  void dispose() {
    _authStateController.close();
    _httpClient.close();
  }
}
