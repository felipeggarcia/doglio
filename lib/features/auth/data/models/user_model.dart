/// User model for Doglio Marketplace
///
/// This file defines the User model for data layer operations.
/// It handles JSON serialization/deserialization and extends the domain entity.
library;

import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.role,
    required super.isActive,
    required super.createdAt,
    super.profileImageUrl,
    super.phoneNumber,
    super.lastLoginAt,
  });

  /// Create UserModel from User entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role,
      isActive: user.isActive,
      createdAt: user.createdAt,
      profileImageUrl: user.profileImageUrl,
      phoneNumber: user.phoneNumber,
      lastLoginAt: user.lastLoginAt,
    );
  }

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: _parseUserRole(json['role'] as String),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      profileImageUrl: json['profileImageUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
    );
  }

  /// Create UserModel from Firestore document
  factory UserModel.fromFirestore(Map<String, dynamic> doc, String id) {
    return UserModel(
      id: id,
      email: doc['email'] as String,
      name: doc['name'] as String,
      role: _parseUserRole(doc['role'] as String),
      isActive: doc['isActive'] as bool? ?? true,
      createdAt: (doc['createdAt'] as dynamic).toDate() as DateTime,
      profileImageUrl: doc['profileImageUrl'] as String?,
      phoneNumber: doc['phoneNumber'] as String?,
      lastLoginAt: doc['lastLoginAt'] != null
          ? (doc['lastLoginAt'] as dynamic).toDate() as DateTime
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': _userRoleToString(role),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'profileImageUrl': profileImageUrl,
      'phoneNumber': phoneNumber,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'role': _userRoleToString(role),
      'isActive': isActive,
      'createdAt': createdAt,
      'profileImageUrl': profileImageUrl,
      'phoneNumber': phoneNumber,
      'lastLoginAt': lastLoginAt,
    };
  }

  /// Helper method to parse UserRole from string
  static UserRole _parseUserRole(String roleString) {
    switch (roleString.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'user':
      default:
        return UserRole.user;
    }
  }

  /// Helper method to convert UserRole to string
  static String _userRoleToString(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'admin';
      case UserRole.user:
        return 'user';
    }
  }

  @override
  UserModel copyWith({
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
    return UserModel(
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
}
