import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doglio/core/errors/failures.dart';
import 'package:doglio/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:doglio/features/auth/data/models/user_model.dart';
import 'package:doglio/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:doglio/features/auth/domain/entities/user.dart';
import 'package:doglio/features/auth/domain/repositories/auth_repository.dart';

class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

void main() {
  late MockAuthRemoteDatasource mockDatasource;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockAuthRemoteDatasource();
    repository = AuthRepositoryImpl(mockDatasource);
  });

  final tUserModel = UserModel(
    id: 'abc',
    name: 'João',
    email: 'joao@email.com',
    role: UserRole.user,
  );

  group('signInWithEmailAndPassword', () {
    test('retorna Right(User) quando datasource tem sucesso', () async {
      when(() => mockDatasource.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => tUserModel);

      final result = await repository.signInWithEmailAndPassword(
        email: 'joao@email.com',
        password: 'senha123',
      );

      expect(result.isRight(), isTrue);
      expect(result.fold((_) => null, (u) => u.id), 'abc');
    });

    test('retorna Left(AuthFailure) quando datasource lança InvalidCredentialsException',
        () async {
      when(() => mockDatasource.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(const InvalidCredentialsException());

      final result = await repository.signInWithEmailAndPassword(
        email: 'joao@email.com',
        password: 'errada',
      );

      expect(result.isLeft(), isTrue);
      expect(result.fold((f) => f, (_) => null), isA<AuthFailure>());
    });

    test('retorna Left(ForbiddenFailure) quando conta inativa', () async {
      when(() => mockDatasource.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(const AccountInactiveException());

      final result = await repository.signInWithEmailAndPassword(
        email: 'joao@email.com',
        password: 'senha123',
      );

      expect(result.isLeft(), isTrue);
      expect(result.fold((f) => f, (_) => null), isA<ForbiddenFailure>());
    });

    test('retorna Left(NetworkFailure) quando erro de rede', () async {
      when(() => mockDatasource.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(const NetworkException());

      final result = await repository.signInWithEmailAndPassword(
        email: 'joao@email.com',
        password: 'senha123',
      );

      expect(result.isLeft(), isTrue);
      expect(result.fold((f) => f, (_) => null), isA<NetworkFailure>());
    });
  });

  group('signOut', () {
    test('retorna Right(null) quando datasource tem sucesso', () async {
      when(() => mockDatasource.signOut()).thenAnswer((_) async {});

      final result = await repository.signOut();

      expect(result.isRight(), isTrue);
    });
  });

  group('getCurrentUser', () {
    test('retorna Right(User) quando token válido', () async {
      when(() => mockDatasource.getCurrentUser())
          .thenAnswer((_) async => tUserModel);

      final result = await repository.getCurrentUser();

      expect(result.isRight(), isTrue);
      expect(result.fold((_) => null, (u) => u?.id), 'abc');
    });

    test('retorna Right(null) quando sem sessão', () async {
      when(() => mockDatasource.getCurrentUser()).thenAnswer((_) async => null);

      final result = await repository.getCurrentUser();

      expect(result.isRight(), isTrue);
      expect(result.fold((_) => null, (u) => u), isNull);
    });
  });
}
