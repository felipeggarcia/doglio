import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:doglio/core/errors/failures.dart';
import 'package:doglio/features/auth/domain/entities/user.dart';
import 'package:doglio/features/auth/domain/repositories/auth_repository.dart';
import 'package:doglio/features/auth/domain/usecases/login_use_case.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late LoginUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  const validParams = LoginParams(email: 'joao@email.com', password: 'senha123');

  final tUser = User(
    id: 'abc',
    name: 'João',
    email: 'joao@email.com',
    role: UserRole.user,
  );

  group('LoginUseCase — validação de parâmetros', () {
    test('retorna Left(ValidationFailure) se email vazio', () async {
      final result = await useCase(
          const LoginParams(email: '', password: 'senha123'));
      expect(result.isLeft(), isTrue);
      expect(result.fold((f) => f, (_) => null), isA<ValidationFailure>());
    });

    test('retorna Left(ValidationFailure) se email inválido', () async {
      final result = await useCase(
          const LoginParams(email: 'email-invalido', password: 'senha123'));
      expect(result.isLeft(), isTrue);
    });

    test('retorna Left(ValidationFailure) se senha vazia', () async {
      final result = await useCase(
          const LoginParams(email: 'joao@email.com', password: ''));
      expect(result.isLeft(), isTrue);
    });

    test('retorna Left(ValidationFailure) se senha menor que 6 caracteres',
        () async {
      final result = await useCase(
          const LoginParams(email: 'joao@email.com', password: '123'));
      expect(result.isLeft(), isTrue);
    });

    test('não chama o repositório quando parâmetros inválidos', () async {
      await useCase(const LoginParams(email: '', password: 'senha123'));
      verifyNever(() => mockRepository.signInWithEmailAndPassword(
          email: any(named: 'email'), password: any(named: 'password')));
    });
  });

  group('LoginUseCase — chamada ao repositório', () {
    test('retorna Right(user) quando credenciais válidas', () async {
      when(() => mockRepository.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => Right(tUser));

      final result = await useCase(validParams);

      expect(result.isRight(), isTrue);
      expect(result.fold((_) => null, (u) => u), tUser);
      verify(() => mockRepository.signInWithEmailAndPassword(
            email: 'joao@email.com',
            password: 'senha123',
          )).called(1);
    });

    test('propaga Left(AuthFailure) do repositório', () async {
      when(() => mockRepository.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer(
              (_) async => const Left(AuthFailure('E-mail ou senha inválidos.')));

      final result = await useCase(validParams);

      expect(result.isLeft(), isTrue);
      expect(result.fold((f) => f, (_) => null), isA<AuthFailure>());
    });
  });
}
