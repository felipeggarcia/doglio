/// Entidade de domínio para um usuário gerenciado pelo admin.
///
/// Diferente da entidade `User` de auth, esta carrega os campos extra que o
/// endpoint `/admin/users` retorna (is_active, last_login, created_at).
/// É um objeto puro: não conhece JSON nem HTTP.
library;

/// Papel do usuário no sistema. Enum local da feature admin para não acoplar
/// ao `UserRole` de auth (Clean Architecture: sem imports entre features).
enum AdminUserRole {
  admin,
  customer;

  /// Converte o valor que vem da API ('admin' | 'customer') para o enum.
  /// Qualquer valor desconhecido cai em customer (default seguro).
  static AdminUserRole fromApi(String? value) =>
      value == 'admin' ? AdminUserRole.admin : AdminUserRole.customer;

  /// Converte o enum de volta para a string que a API espera.
  String toApi() => this == AdminUserRole.admin ? 'admin' : 'customer';
}

class AdminUser {
  const AdminUser({
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
  final AdminUserRole role;
  final bool isActive;
  final String? city;
  final String? state;
  final String? cpfCnpj;
  final String? birthDate;
  final String? lastLogin;
  final String? createdAt;

  bool get isAdmin => role == AdminUserRole.admin;

  AdminUser copyWith({
    String? id,
    String? name,
    String? email,
    AdminUserRole? role,
    bool? isActive,
    String? city,
    String? state,
    String? cpfCnpj,
    String? birthDate,
    String? lastLogin,
    String? createdAt,
  }) {
    return AdminUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      city: city ?? this.city,
      state: state ?? this.state,
      cpfCnpj: cpfCnpj ?? this.cpfCnpj,
      birthDate: birthDate ?? this.birthDate,
      lastLogin: lastLogin ?? this.lastLogin,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Igualdade por id: dois AdminUser com o mesmo id são o "mesmo" usuário.
  // Isso é o que o Flutter usa para diferenciar itens em listas.
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is AdminUser && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
