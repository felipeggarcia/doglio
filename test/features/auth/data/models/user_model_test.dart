import 'package:flutter_test/flutter_test.dart';
import 'package:doglio/features/auth/data/models/user_model.dart';
import 'package:doglio/features/auth/domain/entities/user.dart';

void main() {
  group('UserModel.fromJson', () {
    test('mapeia role "customer" para UserRole.user', () {
      final json = {
        'id': 'abc123',
        'name': 'João Silva',
        'email': 'joao@email.com',
        'role': 'customer',
      };

      final user = UserModel.fromJson(json);

      expect(user.role, UserRole.user);
      expect(user.id, 'abc123');
      expect(user.name, 'João Silva');
      expect(user.email, 'joao@email.com');
    });

    test('mapeia role "admin" para UserRole.admin', () {
      final json = {
        'id': 'adm1',
        'name': 'Admin',
        'email': 'admin@doglio.com',
        'role': 'admin',
      };

      final user = UserModel.fromJson(json);

      expect(user.role, UserRole.admin);
    });

    test('aceita campos opcionais nulos', () {
      final json = {
        'id': 'abc123',
        'name': 'João',
        'email': 'joao@email.com',
        'role': 'customer',
        'city': null,
        'state': null,
        'cpf_cnpj': null,
        'birth_date': null,
      };

      final user = UserModel.fromJson(json);

      expect(user.city, isNull);
      expect(user.state, isNull);
      expect(user.cpfCnpj, isNull);
      expect(user.birthDate, isNull);
    });

    test('serializa campos opcionais quando presentes', () {
      final json = {
        'id': 'abc123',
        'name': 'João',
        'email': 'joao@email.com',
        'role': 'customer',
        'city': 'São Paulo',
        'state': 'SP',
        'cpf_cnpj': '123.456.789-09',
        'birth_date': '1990-05-15',
      };

      final user = UserModel.fromJson(json);

      expect(user.city, 'São Paulo');
      expect(user.state, 'SP');
      expect(user.cpfCnpj, '123.456.789-09');
      expect(user.birthDate, '1990-05-15');
    });
  });

  group('UserModel.toJson', () {
    test('serializa UserRole.user como "customer"', () {
      final user = UserModel(
        id: 'abc123',
        name: 'João',
        email: 'joao@email.com',
        role: UserRole.user,
      );

      final json = user.toJson();

      expect(json['role'], 'customer');
      expect(json['id'], 'abc123');
      expect(json['email'], 'joao@email.com');
    });

    test('serializa UserRole.admin como "admin"', () {
      final user = UserModel(
        id: 'adm1',
        name: 'Admin',
        email: 'admin@doglio.com',
        role: UserRole.admin,
      );

      expect(user.toJson()['role'], 'admin');
    });
  });

  group('UserModel.copyWith', () {
    test('retorna novo modelo com campos atualizados', () {
      final original = UserModel(
        id: 'abc',
        name: 'João',
        email: 'joao@email.com',
        role: UserRole.user,
      );

      final updated = original.copyWith(name: 'João Silva');

      expect(updated.name, 'João Silva');
      expect(updated.id, original.id);
      expect(updated.email, original.email);
    });
  });
}
