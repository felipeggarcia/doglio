library;

import '../../domain/entities/admin_product.dart';
import 'admin_category_model.dart';

class AdminProductModel {
  const AdminProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.isHighlighted,
    required this.isActive,
    required this.inStock,
    required this.stockQuantity,
    this.images = const [],
    this.primaryImage,
    this.categories = const [],
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String description;
  final String price;
  final bool isHighlighted;
  final bool isActive;
  final bool inStock;
  final int stockQuantity;
  final List<AdminProductImageModel> images;
  final AdminProductImageModel? primaryImage;
  final List<AdminCategoryModel> categories;
  final String? createdAt;
  final String? updatedAt;

  factory AdminProductModel.fromJson(Map<String, dynamic> json) {
    return AdminProductModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      price: (json['price'] ?? '0').toString(),
      isHighlighted: _boolFromJson(json['is_highlighted']) ?? false,
      isActive: _boolFromJson(json['is_active']) ?? true,
      inStock: _boolFromJson(json['in_stock']) ?? false,
      stockQuantity: (json['stock_quantity'] as num?)?.toInt() ?? 0,
      images: (json['images'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>()
          .map(AdminProductImageModel.fromJson)
          .toList(),
      primaryImage: json['primary_image'] is Map<String, dynamic>
          ? AdminProductImageModel.fromJson(
              json['primary_image'] as Map<String, dynamic>)
          : null,
      categories: (json['categories'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>()
          .map(AdminCategoryModel.fromJson)
          .toList(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }


  Map<String, String> toMultipartFields({
    bool forUpdate = false,
    List<String> removeImageIds = const [],
    List<String> imageOrder = const [],
  }) {
    final fields = <String, String>{
      'name': name,
      'description': description,
      'price': price,
      'is_highlighted': isHighlighted ? '1' : '0',
      for (var i = 0; i < categories.length; i++)
        'category_ids[$i]': categories[i].id,
    };
    if (forUpdate) {
      fields['_method'] = 'PUT';
      fields['is_active'] = isActive ? '1' : '0';
      for (var i = 0; i < removeImageIds.length; i++) {
        fields['remove_images[$i]'] = removeImageIds[i];
      }
      for (var i = 0; i < imageOrder.length; i++) {
        fields['image_order[$i]'] = imageOrder[i];
      }
    }
    return fields;
  }

  AdminProduct toEntity() => AdminProduct(
        id: id,
        name: name,
        description: description,
        price: price,
        isHighlighted: isHighlighted,
        isActive: isActive,
        inStock: inStock,
        stockQuantity: stockQuantity,
        images: images.map((i) => i.toEntity()).toList(),
        primaryImage: primaryImage?.toEntity(),
        categories: categories.map((c) => c.toEntity()).toList(),
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  factory AdminProductModel.fromEntity(AdminProduct e) => AdminProductModel(
        id: e.id,
        name: e.name,
        description: e.description,
        price: e.price,
        isHighlighted: e.isHighlighted,
        isActive: e.isActive,
        inStock: e.inStock,
        stockQuantity: e.stockQuantity,
        images: e.images.map(AdminProductImageModel.fromEntity).toList(),
        primaryImage: e.primaryImage != null
            ? AdminProductImageModel.fromEntity(e.primaryImage!)
            : null,
        categories: e.categories.map(AdminCategoryModel.fromEntity).toList(),
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  static bool? _boolFromJson(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) return value == '1' || value.toLowerCase() == 'true';
    return null;
  }
}

class AdminProductImageModel {
  const AdminProductImageModel({
    required this.id,
    required this.url,
    required this.isPrimary,
    required this.order,
  });

  final String id;
  final String url;
  final bool isPrimary;
  final int order;

  /// A API ora envia `url`, ora `image_path` (mesma flexibilidade do
  /// ProductImageModel da loja).
  factory AdminProductImageModel.fromJson(Map<String, dynamic> json) {
    return AdminProductImageModel(
      id: (json['id'] ?? '').toString(),
      url: (json['url'] ?? json['image_path'] ?? '').toString(),
      isPrimary: AdminProductModel._boolFromJson(json['is_primary']) ?? false,
      order: (json['order'] as num?)?.toInt() ?? 0,
    );
  }

  AdminProductImage toEntity() => AdminProductImage(
        id: id,
        url: url,
        isPrimary: isPrimary,
        order: order,
      );

  factory AdminProductImageModel.fromEntity(AdminProductImage e) =>
      AdminProductImageModel(
        id: e.id,
        url: e.url,
        isPrimary: e.isPrimary,
        order: e.order,
      );
}
