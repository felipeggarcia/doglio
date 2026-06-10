import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doglio/features/admin/data/datasources/admin_users_remote_datasource.dart';
import 'package:doglio/features/admin/data/models/admin_user_model.dart';
import 'package:doglio/features/admin/data/repositories/admin_users_repository_impl.dart';
import 'package:doglio/features/admin/domain/entities/admin_user.dart';
import 'package:doglio/features/admin/domain/entities/page_meta.dart';

class MockDatasource extends Mock implements AdminUsersRemoteDatasource {}

const _model = AdminUserModel(
  id: '1',
  name: 'João',
  email: 'joao@email.com',
  role: 'customer',
  isActive: true,
);

const _user = AdminUser(
  id: '1',
  name: 'João',
  email: 'joao@email.com',
  role: AdminUserRole.customer,
  isActive: true,
);

void main() {
  late MockDatasource datasource;
  late AdminUsersRepositoryImpl repository;

  setUpAll(() => registerFallbackValue(_model));

  setUp(() {
    datasource = MockDatasource();
    repository = AdminUsersRepositoryImpl(datasource);
  });

  group('getUsers', () {
    test('Right com (usuários, meta) no sucesso', () async {
      when(() => datasource.getUsers(
            search: any(named: 'search'),
            role: any(named: 'role'),
            isActive: any(named: 'isActive'),
            page: any(named: 'page'),
          )).thenAnswer(
        (_) async => ([_model], const PageMeta(currentPage: 1, lastPage: 2, total: 1)),
      );

      final result = await repository.getUsers();

      expect(result.isRight(), isTrue);
      final (users, meta) = result.getRight().toNullable()!;
      expect(users.first.id, '1');
      expect(users.first.role, AdminUserRole.customer);
      expect(meta.lastPage, 2);
    });

    test('Left quando datasource lança', () async {
      when(() => datasource.getUsers(
            search: any(named: 'search'),
            role: any(named: 'role'),
            isActive: any(named: 'isActive'),
            page: any(named: 'page'),
          )).thenThrow(Exception('falha'));

      final result = await repository.getUsers();
      expect(result.isLeft(), isTrue);
    });
  });

  group('createUser', () {
    test('Right no sucesso', () async {
      when(() => datasource.createUser(any(), password: any(named: 'password')))
          .thenAnswer((_) async => _model);

      final result = await repository.createUser(_user, password: 'segredo12');
      expect(result.isRight(), isTrue);
    });

    test('Left quando datasource lança', () async {
      when(() => datasource.createUser(any(), password: any(named: 'password')))
          .thenThrow(Exception('email em uso'));

      final result = await repository.createUser(_user, password: 'x');
      expect(result.isLeft(), isTrue);
    });
  });

  group('updateUser', () {
    test('Right no sucesso', () async {
      when(() => datasource.updateUser(any())).thenAnswer((_) async => _model);
      final result = await repository.updateUser(_user);
      expect(result.isRight(), isTrue);
    });
  });

  group('deleteUser', () {
    test('Right(unit) no sucesso', () async {
      when(() => datasource.deleteUser(any())).thenAnswer((_) async {});
      final result = await repository.deleteUser('1');
      expect(result.isRight(), isTrue);
    });

    test('Left quando datasource lança', () async {
      when(() => datasource.deleteUser(any())).thenThrow(Exception('erro'));
      final result = await repository.deleteUser('1');
      expect(result.isLeft(), isTrue);
    });
  });
}
