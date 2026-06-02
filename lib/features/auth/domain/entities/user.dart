/// User entity for Doglio Marketplace
library;

enum UserRole { user, admin }

class User {
  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.city,
    this.state,
    this.cpfCnpj,
    this.birthDate,
  });

  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? city;
  final String? state;
  final String? cpfCnpj;
  final String? birthDate;

  bool get isAdmin => role == UserRole.admin;
  bool get isCustomer => role == UserRole.user;

  User copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    String? city,
    String? state,
    String? cpfCnpj,
    String? birthDate,
  }) {
    return User(
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'User(id: $id, email: $email, name: $name, role: $role)';
}
