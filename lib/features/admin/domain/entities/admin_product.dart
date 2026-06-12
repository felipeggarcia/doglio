library;

import 'admin_category.dart';

class AdminProduct {
  const AdminProduct({
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

  /// Preço como string ("89.90") — formato da API.
  final String price;
  final bool isHighlighted;
  final bool isActive;
  final bool inStock;

  /// Quantidade em estoque — só presente nas respostas admin.
  final int stockQuantity;
  final List<AdminProductImage> images;
  final AdminProductImage? primaryImage;
  final List<AdminCategory> categories;
  final String? createdAt;
  final String? updatedAt;

  AdminProduct copyWith({
    String? id,
    String? name,
    String? description,
    String? price,
    bool? isHighlighted,
    bool? isActive,
    bool? inStock,
    int? stockQuantity,
    List<AdminProductImage>? images,
    AdminProductImage? primaryImage,
    List<AdminCategory>? categories,
    String? createdAt,
    String? updatedAt,
  }) {
    return AdminProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      isActive: isActive ?? this.isActive,
      inStock: inStock ?? this.inStock,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      images: images ?? this.images,
      primaryImage: primaryImage ?? this.primaryImage,
      categories: categories ?? this.categories,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is AdminProduct && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

class AdminProductImage {
  const AdminProductImage({
    required this.id,
    required this.url,
    required this.isPrimary,
    required this.order,
  });

  final String id;
  final String url;
  final bool isPrimary;
  final int order;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is AdminProductImage && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
