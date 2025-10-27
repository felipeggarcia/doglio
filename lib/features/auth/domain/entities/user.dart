/// User entity for Doglio Marketplace
///
/// This file defines the core User entity used throughout the domain layer.
/// It represents a user in the system (both customers and admins).
library;

enum UserRole { user, admin }

class User {
  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.isActive,
    required this.createdAt,
    this.profileImageUrl,
    this.phoneNumber,
    this.lastLoginAt,
  });

  final String id;
  final String email;
  final String name;
  final UserRole role;
  final bool isActive;
  final DateTime createdAt;
  final String? profileImageUrl;
  final String? phoneNumber;
  final DateTime? lastLoginAt;

  bool get isAdmin => role == UserRole.admin;
  bool get isCustomer => role == UserRole.user;

  User copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    bool? isActive,
    DateTime? createdAt,
    String? profileImageUrl,
    String? phoneNumber,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
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
  String toString() {
    return 'User(id: $id, email: $email, name: $name, role: $role)';
  }
}
