import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:doglio/core/storage/secure_storage.dart';
import 'package:doglio/features/admin/data/datasources/admin_users_remote_datasource.dart';
import 'package:doglio/features/admin/data/models/admin_user_model.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockSecureStorage extends Mock implements SecureStorage {}

Map<String, dynamic> _userJson({String id = '1', String role = 'customer'}) => {
      'id': id,
      'name': 'João',
      'email': 'joao@email.com',
      'role': role,
      'is_active': true,
    };

void main() {
  late MockHttpClient http_;
  late MockSecureStorage storage;
  late AdminUsersRemoteDatasource datasource;

  setUpAll(() {
    registerFallbackValue(Uri.parse('http://example.com'));
    registerFallbackValue(<String, String>{});
  });

  setUp(() {
    http_ = MockHttpClient();
    storage = MockSecureStorage();
    datasource = AdminUsersRemoteDatasource(
      httpClient: http_,
      secureStorage: storage,
    );
    when(() => storage.getToken()).thenAnswer((_) async => 'token');
  });

  group('getUsers', () {
    test('monta query params e parseia data + meta', () async {
      when(() => http_.get(any(), headers: any(named: 'headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'data': [_userJson(id: '1'), _userJson(id: '2', role: 'admin')],
            'meta': {'current_page': 1, 'last_page': 3, 'total': 42},
          }),
          200,
        ),
      );

      final (users, meta) = await datasource.getUsers(
        search: 'jo',
        role: 'admin',
        isActive: true,
        page: 2,
      );

      expect(users.length, 2);
      expect(meta.currentPage, 1);
      expect(meta.lastPage, 3);
      expect(meta.hasMore, isTrue);

      // Verifica os query params enviados na URL
      final captured =
          verify(() => http_.get(captureAny(), headers: any(named: 'headers')))
              .captured
              .single as Uri;
      expect(captured.queryParameters['search'], 'jo');
      expect(captured.queryParameters['role'], 'admin');
      expect(captured.queryParameters['is_active'], '1');
      expect(captured.queryParameters['page'], '2');
    });

    test('lança exceção com a message do servidor quando não-200', () async {
      when(() => http_.get(any(), headers: any(named: 'headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode({'message': 'Acesso negado.'}),
          403,
        ),
      );

      expect(
        () => datasource.getUsers(),
        throwsA(predicate((e) => e.toString().contains('Acesso negado.'))),
      );
    });
  });

  group('createUser', () {
    test('envia password no corpo e parseia o retorno', () async {
      when(() => http_.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer(
        (_) async => http.Response(jsonEncode({'data': _userJson(id: '9')}), 201),
      );

      const model = AdminUserModel(
        id: '',
        name: 'Novo',
        email: 'novo@email.com',
        role: 'customer',
        isActive: true,
      );

      final result = await datasource.createUser(model, password: 'segredo12');

      expect(result.id, '9');
      final body = verify(() => http_.post(any(),
              headers: any(named: 'headers'),
              body: captureAny(named: 'body')))
          .captured
          .single as String;
      final decoded = jsonDecode(body) as Map<String, dynamic>;
      expect(decoded['password'], 'segredo12');
      expect(decoded['email'], 'novo@email.com');
    });
  });

  group('updateUser', () {
    test('faz PUT em /admin/users/{id}', () async {
      when(() => http_.put(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer(
        (_) async => http.Response(jsonEncode({'data': _userJson(id: '7')}), 200),
      );

      const model = AdminUserModel(
        id: '7',
        name: 'Edit',
        email: 'e@e.com',
        role: 'admin',
        isActive: true,
      );

      final result = await datasource.updateUser(model);
      expect(result.id, '7');

      final uri = verify(() => http_.put(captureAny(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .captured
          .single as Uri;
      expect(uri.path, endsWith('/admin/users/7'));
    });
  });

  group('deleteUser', () {
    test('aceita 200/204 sem erro', () async {
      when(() => http_.delete(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('', 204));

      await expectLater(datasource.deleteUser('5'), completes);
    });
  });
}
