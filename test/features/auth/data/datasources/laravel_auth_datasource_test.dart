import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:doglio/core/storage/secure_storage.dart';
import 'package:doglio/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:doglio/features/auth/data/datasources/laravel_auth_datasource.dart';
import 'package:doglio/features/auth/domain/repositories/auth_repository.dart'
    hide InvalidCredentialsException;

class MockHttpClient extends Mock implements http.Client {}

class MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  late MockHttpClient mockHttpClient;
  late MockSecureStorage mockSecureStorage;
  late LaravelAuthDatasource datasource;

  final tUserJson = {
    'id': 'abc123',
    'name': 'João Silva',
    'email': 'joao@email.com',
    'role': 'customer',
  };

  final tLoginResponseBody = jsonEncode({
    'success': true,
    'message': 'Login realizado com sucesso.',
    'data': {
      'user': tUserJson,
      'token': '1|test_token_abc',
      'token_type': 'Bearer',
    },
  });

  final tGetUserResponseBody = jsonEncode({'data': tUserJson});

  setUpAll(() {
    registerFallbackValue(Uri.parse('http://example.com'));
    registerFallbackValue(<String, String>{});
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockSecureStorage = MockSecureStorage();
    datasource = LaravelAuthDatasource(
      httpClient: mockHttpClient,
      secureStorage: mockSecureStorage,
    );
  });

  group('signInWithEmailAndPassword', () {
    test('status 200 — salva token e retorna UserModel', () async {
      when(
        () => mockHttpClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer(
        (_) async => http.Response(tLoginResponseBody, 200),
      );
      when(
        () => mockSecureStorage.saveToken(any()),
      ).thenAnswer((_) async {});

      final result = await datasource.signInWithEmailAndPassword(
        email: 'joao@email.com',
        password: 'senha123',
      );

      expect(result.id, 'abc123');
      expect(result.email, 'joao@email.com');
      verify(() => mockSecureStorage.saveToken('1|test_token_abc')).called(1);
    });

    test('status 401 — lança InvalidCredentialsException', () {
      when(
        () => mockHttpClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          jsonEncode({'success': false, 'message': 'Credenciais inválidas.'}),
          401,
        ),
      );

      expect(
        () => datasource.signInWithEmailAndPassword(
          email: 'joao@email.com',
          password: 'errada',
        ),
        throwsA(isA<InvalidCredentialsException>()),
      );
    });

    test('status 403 — lança AccountInactiveException', () {
      when(
        () => mockHttpClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          jsonEncode({'success': false, 'message': 'Conta desativada.'}),
          403,
        ),
      );

      expect(
        () => datasource.signInWithEmailAndPassword(
          email: 'joao@email.com',
          password: 'senha123',
        ),
        throwsA(isA<AccountInactiveException>()),
      );
    });

    test('erro de rede — lança UnknownAuthException', () {
      when(
        () => mockHttpClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenThrow(Exception('Connection refused'));

      expect(
        () => datasource.signInWithEmailAndPassword(
          email: 'joao@email.com',
          password: 'senha123',
        ),
        throwsA(isA<UnknownAuthException>()),
      );
    });
  });

  group('getCurrentUser', () {
    test('sem token — retorna null sem fazer request', () async {
      when(() => mockSecureStorage.getToken()).thenAnswer((_) async => null);

      final result = await datasource.getCurrentUser();

      expect(result, isNull);
      verifyNever(
        () => mockHttpClient.get(any(), headers: any(named: 'headers')),
      );
    });

    test('com token válido — retorna UserModel', () async {
      when(() => mockSecureStorage.getToken())
          .thenAnswer((_) async => '1|test_token');
      when(
        () => mockHttpClient.get(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) async => http.Response(tGetUserResponseBody, 200));

      final result = await datasource.getCurrentUser();

      expect(result?.id, 'abc123');
    });

    test('status 401 — limpa storage e retorna null', () async {
      when(() => mockSecureStorage.getToken())
          .thenAnswer((_) async => '1|expired_token');
      when(
        () => mockHttpClient.get(any(), headers: any(named: 'headers')),
      ).thenAnswer(
        (_) async => http.Response('{"message":"Unauthenticated."}', 401),
      );
      when(() => mockSecureStorage.clearAll()).thenAnswer((_) async {});

      final result = await datasource.getCurrentUser();

      expect(result, isNull);
      verify(() => mockSecureStorage.clearAll()).called(1);
    });
  });

  group('signOut', () {
    test('chama POST /logout e limpa storage', () async {
      when(() => mockSecureStorage.getToken())
          .thenAnswer((_) async => '1|test_token');
      when(
        () => mockHttpClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          jsonEncode({'success': true, 'message': 'Logout realizado.'}),
          200,
        ),
      );
      when(() => mockSecureStorage.clearAll()).thenAnswer((_) async {});

      await datasource.signOut();

      verify(() => mockSecureStorage.clearAll()).called(1);
    });
  });
}
