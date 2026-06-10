/// Model de dados do usuário admin — ponte entre o JSON da API e a entidade.
///
/// Escrito à mão (sem Freezed) porque este ambiente não roda build_runner.
/// Responsável por: parsear o JSON (`fromJson`), montar o corpo das requisições
/// (`toJson`) e converter para a entidade de domínio (`toEntity`).
library;

import '../../domain/entities/admin_user.dart';

class AdminUserModel {
  const AdminUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
    this.city,
    this.state,
    this.cpfCnpj,
    this.birthDate,
    this.lastLogin,
    this.createdAt,
  });

  final String id;
  final String name;
  final String email;
  final String role; // mantém a string crua da API ('admin' | 'customer')
  final bool isActive;
  final String? city;
  final String? state;
  final String? cpfCnpj;
  final String? birthDate;
  final String? lastLogin;
  final String? createdAt;

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      // id pode vir como int (hashids desativados) → normaliza para String.
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      role: (json['role'] ?? 'customer').toString(),
      // is_active pode vir como bool, 1/0 ou string → normaliza. Default: true.
      isActive: _boolFromJson(json['is_active']),
      city: json['city'] as String?,
      state: json['state'] as String?,
      cpfCnpj: json['cpf_cnpj'] as String?,
      birthDate: json['birth_date'] as String?,
      lastLogin: json['last_login'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  /// Corpo enviado no POST/PUT. Campos nulos são omitidos para não sobrescrever
  /// dados no backend sem querer (o PUT trata todos como `sometimes`).
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'role': role,
        'is_active': isActive,
        if (city != null) 'city': city,
        if (state != null) 'state': state,
        if (cpfCnpj != null) 'cpf_cnpj': cpfCnpj,
        if (birthDate != null) 'birth_date': birthDate,
      };

  AdminUser toEntity() => AdminUser(
        id: id,
        name: name,
        email: email,
        role: AdminUserRole.fromApi(role),
        isActive: isActive,
        city: city,
        state: state,
        cpfCnpj: cpfCnpj,
        birthDate: birthDate,
        lastLogin: lastLogin,
        createdAt: createdAt,
      );

  factory AdminUserModel.fromEntity(AdminUser user) => AdminUserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role.toApi(),
        isActive: user.isActive,
        city: user.city,
        state: user.state,
        cpfCnpj: user.cpfCnpj,
        birthDate: user.birthDate,
        lastLogin: user.lastLogin,
        createdAt: user.createdAt,
      );

  static bool _boolFromJson(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) return value == '1' || value.toLowerCase() == 'true';
    return true; // default: usuário ativo
  }
}
