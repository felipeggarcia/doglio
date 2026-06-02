/// User model for Doglio Marketplace
library;

import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.role,
    super.city,
    super.state,
    super.cpfCnpj,
    super.birthDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: _parseUserRole(json['role'] as String? ?? 'customer'),
      city: json['city'] as String?,
      state: json['state'] as String?,
      cpfCnpj: json['cpf_cnpj'] as String?,
      birthDate: json['birth_date'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': _userRoleToString(role),
      'city': city,
      'state': state,
      'cpf_cnpj': cpfCnpj,
      'birth_date': birthDate,
    };
  }

  static UserRole _parseUserRole(String roleString) {
    return switch (roleString.toLowerCase()) {
      'admin' => UserRole.admin,
      _ => UserRole.user,
    };
  }

  static String _userRoleToString(UserRole role) {
    return switch (role) {
      UserRole.admin => 'admin',
      UserRole.user => 'customer',
    };
  }

  @override
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    String? city,
    String? state,
    String? cpfCnpj,
    String? birthDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      city: city ?? this.city,
      state: state ?? this.state,
      cpfCnpj: cpfCnpj ?? this.cpfCnpj,
      birthDate: birthDate ?? this.birthDate,
    );
  }
}

