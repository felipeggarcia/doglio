/// Product model for data layer
library;

import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    super.originalPrice,
    super.effectivePrice,
    super.discountAmount,
    required super.inStock,
    required super.isHighlighted,
    required super.isActive,
    super.promotion,
    super.primaryImage,
    required super.images,
    required super.categories,
    super.averageRating,
    super.reviewsCount,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: json['price'].toString(),
      originalPrice: json['original_price']?.toString(),
      effectivePrice: json['effective_price']?.toString(),
      discountAmount: json['discount_amount']?.toString(),
      inStock: json['in_stock'] as bool? ?? false,
      isHighlighted: json['is_highlighted'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      promotion: json['promotion'] != null
          ? PromotionModel.fromJson(json['promotion'] as Map<String, dynamic>)
          : null,
      primaryImage: json['primary_image'] != null
          ? ProductImageModel.fromJson(
              json['primary_image'] as Map<String, dynamic>,
            )
          : null,
      images:
          (json['images'] as List<dynamic>?)
              ?.map(
                (img) =>
                    ProductImageModel.fromJson(img as Map<String, dynamic>),
              )
              .toList() ??
          [],
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map(
                (cat) => CategoryModel.fromJson(cat as Map<String, dynamic>),
              )
              .toList() ??
          [],
      averageRating: (json['average_rating'] as num?)?.toDouble(),
      reviewsCount: json['reviews_count'] as int? ?? 0,
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

class PromotionModel extends Promotion {
  const PromotionModel({
    required super.id,
    required super.name,
    required super.type,
    required super.discountValue,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      discountValue: (json['discount_value'] as num?)?.toDouble() ?? 0,
    );
  }
}

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.isHighlighted,
    super.isActive,
    super.productsCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      isHighlighted: json['is_highlighted'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      productsCount: json['products_count'] as int?,
    );
  }
}
