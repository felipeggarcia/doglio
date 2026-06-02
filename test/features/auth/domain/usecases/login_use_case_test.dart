import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doglio/features/auth/domain/entities/user.dart';
import 'package:doglio/features/auth/domain/repositories/auth_repository.dart';
import 'package:doglio/features/auth/domain/usecases/login_use_case.dart';
import 'package:doglio/features/auth/domain/usecases/base_use_case.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class FakeUser extends Fake implements User {}

void main() {
  late MockAuthRepository mockRepository;
  late LoginUseCase useCase;

  setUpAll(() {
    registerFallbackValue(FakeUser());
  });

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  group('LoginUseCase — validação de parâmetros', () {
    test('lança InvalidParametersException se email vazio', () {
      expect(
        () => useCase(const LoginParams(email: '', password: 'senha123')),
        throwsA(isA<InvalidParametersException>()),
      );
    });

    test('lança InvalidParametersException se email inválido', () {
      expect(
        () => useCase(
          const LoginParams(email: 'email-invalido', password: 'senha123'),
        ),
        throwsA(isA<InvalidParametersException>()),
      );
    });

    test('lança InvalidParametersException se senha vazia', () {
      expect(
        () => useCase(
          const LoginParams(email: 'joao@email.com', password: ''),
        ),
        throwsA(isA<InvalidParametersException>()),
      );
    });

    test('lança InvalidParametersException se senha menor que 6 caracteres',
        () {
      expect(
        () => useCase(
          const LoginParams(email: 'joao@email.com', password: '123'),
        ),
        throwsA(isA<InvalidParametersException>()),
      );
    });
  });

  group('LoginUseCase — chamada ao repositório', () {
    const validParams = LoginParams(
      email: 'joao@email.com',
      password: 'senha123',
    );

    test('chama signInWithEmailAndPassword com parâmetros corretos', () async {
      final user = User(
        id: 'abc',
        name: 'João',
        email: 'joao@email.com',
        role: UserRole.user,
      );
      when(
        () => mockRepository.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => user);

      final result = await useCase(validParams);

      expect(result, user);
      verify(
        () => mockRepository.signInWithEmailAndPassword(
          email: 'joao@email.com',
          password: 'senha123',
        ),
      ).called(1);
    });

    test('propaga InvalidCredentialsException do repositório', () {
      when(
        () => mockRepository.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const InvalidCredentialsException());

      expect(
        () => useCase(validParams),
        throwsA(isA<InvalidCredentialsException>()),
      );
    });

    test('propaga AccountInactiveException do repositório', () {
      when(
        () => mockRepository.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const AccountInactiveException());

      expect(
        () => useCase(validParams),
        throwsA(isA<AccountInactiveException>()),
      );
    });
  });
}
