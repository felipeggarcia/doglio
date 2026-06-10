import 'package:flutter_test/flutter_test.dart';
import 'package:doglio/features/admin/data/models/admin_user_model.dart';
import 'package:doglio/features/admin/domain/entities/admin_user.dart';

void main() {
  group('AdminUserModel.fromJson', () {
    test('parseia todos os campos', () {
      final model = AdminUserModel.fromJson({
        'id': 'abc123',
        'name': 'João Silva',
        'email': 'joao@email.com',
        'role': 'admin',
        'is_active': true,
        'city': 'São Paulo',
        'state': 'SP',
        'cpf_cnpj': '123.456.789-09',
        'birth_date': '1990-05-15',
        'last_login': '2026-06-07 10:30:00',
        'created_at': '2026-05-01 08:00:00',
      });

      expect(model.id, 'abc123');
      expect(model.name, 'João Silva');
      expect(model.email, 'joao@email.com');
      expect(model.role, 'admin');
      expect(model.isActive, isTrue);
      expect(model.city, 'São Paulo');
      expect(model.cpfCnpj, '123.456.789-09');
      expect(model.lastLogin, '2026-06-07 10:30:00');
    });

    test('normaliza id inteiro para String', () {
      final model = AdminUserModel.fromJson({'id': 42, 'role': 'customer'});
      expect(model.id, '42');
      expect(model.id, isA<String>());
    });

    test('is_active ausente assume true (default)', () {
      final model = AdminUserModel.fromJson({'id': '1'});
      expect(model.isActive, isTrue);
    });

    test('is_active aceita variações (bool/int/string)', () {
      expect(AdminUserModel.fromJson({'id': '1', 'is_active': false}).isActive,
          isFalse);
      expect(
          AdminUserModel.fromJson({'id': '1', 'is_active': 0}).isActive, isFalse);
      expect(AdminUserModel.fromJson({'id': '1', 'is_active': '0'}).isActive,
          isFalse);
      expect(AdminUserModel.fromJson({'id': '1', 'is_active': 1}).isActive,
          isTrue);
    });

    test('campos opcionais ausentes ficam null', () {
      final model = AdminUserModel.fromJson({'id': '1', 'role': 'customer'});
      expect(model.city, isNull);
      expect(model.cpfCnpj, isNull);
      expect(model.birthDate, isNull);
      expect(model.lastLogin, isNull);
    });
  });

  group('AdminUserModel.toJson', () {
    test('inclui campos da API e omite nulos; não envia id', () {
      const model = AdminUserModel(
        id: 'abc123',
        name: 'Maria',
        email: 'maria@email.com',
        role: 'customer',
        isActive: true,
      );

      final json = model.toJson();

      expect(json['name'], 'Maria');
      expect(json['email'], 'maria@email.com');
      expect(json['role'], 'customer');
      expect(json['is_active'], true);
      expect(json.containsKey('id'), isFalse);
      expect(json.containsKey('city'), isFalse); // nulo → omitido
      expect(json.containsKey('password'), isFalse); // senha não vem do model
    });

    test('inclui opcionais quando presentes', () {
      const model = AdminUserModel(
        id: '1',
        name: 'X',
        email: 'x@e.com',
        role: 'admin',
        isActive: false,
        city: 'Rio',
        cpfCnpj: '111',
      );

      final json = model.toJson();
      expect(json['city'], 'Rio');
      expect(json['cpf_cnpj'], '111');
      expect(json['is_active'], false);
    });
  });

  group('conversões de entidade', () {
    test('toEntity converte role string para enum', () {
      const admin = AdminUserModel(
        id: '1',
        name: 'A',
        email: 'a@e.com',
        role: 'admin',
        isActive: true,
      );
      const customer = AdminUserModel(
        id: '2',
        name: 'B',
        email: 'b@e.com',
        role: 'customer',
        isActive: true,
      );

      expect(admin.toEntity().role, AdminUserRole.admin);
      expect(customer.toEntity().role, AdminUserRole.customer);
    });

    test('fromEntity converte enum para string da API', () {
      const user = AdminUser(
        id: '1',
        name: 'A',
        email: 'a@e.com',
        role: AdminUserRole.admin,
        isActive: true,
      );

      expect(AdminUserModel.fromEntity(user).role, 'admin');
    });
  });
}
