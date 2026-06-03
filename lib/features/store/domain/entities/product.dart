/// Product entity for the store
library;

import 'package:flutter/foundation.dart';

@immutable
class Product {
  final String id;
  final String name;
  final String description;
  final String price;
  final String? originalPrice;
  final String? effectivePrice;
  final String? discountAmount;
  final bool inStock;
  final bool isHighlighted;
  final bool isActive;
  final Promotion? promotion;
  final ProductImage? primaryImage;
  final List<ProductImage> images;
  final List<Category> categories;
  final double? averageRating;
  final int reviewsCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    this.effectivePrice,
    this.discountAmount,
    required this.inStock,
    required this.isHighlighted,
    required this.isActive,
    this.promotion,
    this.primaryImage,
    required this.images,
    required this.categories,
    this.averageRating,
    this.reviewsCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Preço a exibir: usa effectivePrice se houver promoção, senão price
  String get displayPrice => effectivePrice ?? price;

  bool get hasPromotion => promotion != null && effectivePrice != null;

  /// Melhor caminho de imagem disponível: primaryImage → isPrimary em images → primeira imagem
  String? get bestImagePath {
    if (primaryImage != null && primaryImage!.imagePath.isNotEmpty) {
      return primaryImage!.imagePath;
    }
    return images
            .where((i) => i.isPrimary && i.imagePath.isNotEmpty)
            .firstOrNull
            ?.imagePath ??
        images.where((i) => i.imagePath.isNotEmpty).firstOrNull?.imagePath;
  }

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

class Promotion {
  final String id;
  final String name;
  final String type;
  final double discountValue;

  const Promotion({
    required this.id,
    required this.name,
    required this.type,
    required this.discountValue,
  });
}

class Category {
  final String id;
  final String name;
  final String slug;
  final bool isHighlighted;
  final bool isActive;
  final int? productsCount;

  const Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.isHighlighted,
    this.isActive = true,
    this.productsCount,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
