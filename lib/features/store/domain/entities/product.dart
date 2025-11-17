/// Product entity for the store
library;

import 'package:flutter/foundation.dart';

@immutable
class Product {
  final String id;
  final String name;
  final String description;
  final String price;
  final int stockQuantity;
  final bool isHighlighted;
  final ProductImage? primaryImage;
  final List<ProductImage> images;
  final List<Category> categories;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stockQuantity,
    required this.isHighlighted,
    this.primaryImage,
    required this.images,
    required this.categories,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get inStock => stockQuantity > 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class ProductImage {
  final String id;
  final String imagePath;
  final int order;
  final bool isPrimary;

  const ProductImage({
    required this.id,
    required this.imagePath,
    required this.order,
    required this.isPrimary,
  });
}

class Category {
  final String id;
  final String name;
  final String slug;
  final bool isHighlighted;
  final int? productsCount;

  const Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.isHighlighted,
    this.productsCount,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
