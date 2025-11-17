/// Product model for data layer
library;

import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.stockQuantity,
    required super.isHighlighted,
    super.primaryImage,
    required super.images,
    required super.categories,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: json['price'].toString(),
      stockQuantity: json['stock_quantity'] as int? ?? 0,
      isHighlighted: json['is_highlighted'] as bool? ?? false,
      primaryImage: json['primary_image'] != null
          ? ProductImageModel.fromJson(json['primary_image'])
          : null,
      images:
          (json['images'] as List<dynamic>?)
              ?.map((img) => ProductImageModel.fromJson(img))
              .toList() ??
          [],
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((cat) => CategoryModel.fromJson(cat))
              .toList() ??
          [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }
}

class ProductImageModel extends ProductImage {
  const ProductImageModel({
    required super.id,
    required super.imagePath,
    required super.order,
    required super.isPrimary,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    // API pode retornar 'url' ou 'image_path'
    final imagePath =
        (json['url'] as String?) ?? (json['image_path'] as String?) ?? '';
    return ProductImageModel(
      id: json['id'] as String,
      imagePath: imagePath,
      order: json['order'] as int? ?? 0,
      isPrimary: json['is_primary'] as bool? ?? false,
    );
  }
}

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.isHighlighted,
    super.productsCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      isHighlighted: json['is_highlighted'] as bool? ?? false,
      productsCount: json['products_count'] as int?,
    );
  }
}
