library;

import '../../domain/entities/admin_category.dart';

class AdminCategoryModel {
  const AdminCategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.isHighlighted,
    required this.isActive,
    required this.productsCount,
  });

  final String id;
  final String name;
  final String slug;
  final bool isHighlighted;
  final bool isActive;
  final int productsCount;

  factory AdminCategoryModel.fromJson(Map<String, dynamic> json) {
    return AdminCategoryModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      isHighlighted: _boolFromJson(json['is_highlighted']) ?? false,
      isActive: _boolFromJson(json['is_active']) ?? true,
      productsCount: (json['products_count'] as num?)?.toInt() ?? 0,
    );
  }

  /// Corpo enviado no POST/PUT. Slug e productsCount são gerenciados pelo servidor.
  Map<String, dynamic> toJson() => {
        'name': name,
        'is_highlighted': isHighlighted,
        'is_active': isActive,
      };

  AdminCategory toEntity() => AdminCategory(
        id: id,
        name: name,
        slug: slug,
        isHighlighted: isHighlighted,
        isActive: isActive,
        productsCount: productsCount,
      );

  factory AdminCategoryModel.fromEntity(AdminCategory e) =>
      AdminCategoryModel(
        id: e.id,
        name: e.name,
        slug: e.slug,
        isHighlighted: e.isHighlighted,
        isActive: e.isActive,
        productsCount: e.productsCount,
      );

  static bool? _boolFromJson(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) return value == '1' || value.toLowerCase() == 'true';
    return null;
  }
}
