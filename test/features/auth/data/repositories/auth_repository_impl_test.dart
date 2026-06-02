import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doglio/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:doglio/features/auth/data/models/user_model.dart';
import 'package:doglio/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:doglio/features/auth/domain/entities/user.dart';


class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

void main() {
  late MockAuthRemoteDatasource mockDatasource;
  late AuthRepositoryImpl repository;

  final tUserModel = UserModel(
    id: 'abc123',
    name: 'João Silva',
    email: 'joao@email.com',
    role: UserRole.user,
  );

  setUp(() {
    mockDatasource = MockAuthRemoteDatasource();
    repository = AuthRepositoryImpl(mockDatasource);
  });

  group('signInWithEmailAndPassword', () {
    test('retorna User quando datasource tem sucesso', () async {
      when(
        () => mockDatasource.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => tUserModel);

      final result = await repository.signInWithEmailAndPassword(
        email: 'joao@email.com',
        password: 'senha123',
      );

      expect(result, tUserModel);
    });

    test('propaga InvalidCredentialsException do datasource', () {
      when(
        () => mockDatasource.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const InvalidCredentialsException());

      expect(
        () => repository.signInWithEmailAndPassword(
          email: 'joao@email.com',
          password: 'errada',
        ),
        throwsA(isA<InvalidCredentialsException>()),
      );
    });

    test('propaga EmailAlreadyInUseException do datasource no register', () {
      when(
        () => mockDatasource.createUserWithEmailAndPassword(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const EmailAlreadyInUseException());

      expect(
        () => repository.createUserWithEmailAndPassword(
          name: 'João',
          email: 'joao@email.com',
          password: 'senha123',
        ),
        throwsA(isA<EmailAlreadyInUseException>()),
      );
    });
  });

  group('signOut', () {
    test('chama datasource.signOut sem lançar exceção', () async {
      when(() => mockDatasource.signOut()).thenAnswer((_) async {});

      await expectLater(repository.signOut(), completes);
      verify(() => mockDatasource.signOut()).called(1);
    });
  });

  group('getCurrentUser', () {
    test('retorna User quando token válido', () async {
      when(() => mockDatasource.getCurrentUser())
          .thenAnswer((_) async => tUserModel);

      final result = await repository.getCurrentUser();

      expect(result, tUserModel);
    });

    test('retorna null quando datasource retorna null', () async {
      when(() => mockDatasource.getCurrentUser()).thenAnswer((_) async => null);

      final result = await repository.getCurrentUser();

      expect(result, isNull);
    });
  });
}
