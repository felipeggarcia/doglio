library;

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/product.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
abstract class ProductImageModel with _$ProductImageModel {
  const ProductImageModel._();

  const factory ProductImageModel({
    required String id,
    @JsonKey(fromJson: _imagePathFromJson) required String imagePath,
    @JsonKey(defaultValue: 0) required int order,
    @JsonKey(name: 'is_primary', defaultValue: false) required bool isPrimary,
  }) = _ProductImageModel;

  factory ProductImageModel.fromJson(Map<String, dynamic> json) =>
      _$ProductImageModelFromJson(json);

  ProductImage toEntity() => ProductImage(
        id: id,
        imagePath: imagePath,
        order: order,
        isPrimary: isPrimary,
      );
}

String _imagePathFromJson(dynamic value) =>
    (value is String) ? value : '';

@freezed
abstract class PromotionModel with _$PromotionModel {
  const PromotionModel._();

  const factory PromotionModel({
    required String id,
    @JsonKey(defaultValue: '') required String name,
    @JsonKey(defaultValue: '') required String type,
    @JsonKey(name: 'discount_value', defaultValue: 0.0)
    required double discountValue,
  }) = _PromotionModel;

  factory PromotionModel.fromJson(Map<String, dynamic> json) =>
      _$PromotionModelFromJson(json);

  Promotion toEntity() => Promotion(
        id: id,
        name: name,
        type: type,
        discountValue: discountValue,
      );
}

@freezed
abstract class CategoryModel with _$CategoryModel {
  const CategoryModel._();

  const factory CategoryModel({
    required String id,
    @JsonKey(defaultValue: '') required String name,
    @JsonKey(defaultValue: '') required String slug,
    @JsonKey(name: 'is_highlighted', defaultValue: false)
    required bool isHighlighted,
    @JsonKey(name: 'is_active', defaultValue: true) required bool isActive,
    @JsonKey(name: 'products_count') int? productsCount,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Category toEntity() => Category(
        id: id,
        name: name,
        slug: slug,
        isHighlighted: isHighlighted,
        isActive: isActive,
        productsCount: productsCount,
      );
}

@freezed
abstract class ProductModel with _$ProductModel {
  const ProductModel._();

  const factory ProductModel({
    required String id,
    @JsonKey(defaultValue: '') required String name,
    @JsonKey(defaultValue: '') required String description,
    required String price,
    @JsonKey(name: 'original_price') String? originalPrice,
    @JsonKey(name: 'effective_price') String? effectivePrice,
    @JsonKey(name: 'discount_amount') String? discountAmount,
    @JsonKey(name: 'in_stock', defaultValue: false) required bool inStock,
    @JsonKey(name: 'is_highlighted', defaultValue: false)
    required bool isHighlighted,
    @JsonKey(name: 'is_active', defaultValue: true) required bool isActive,
    PromotionModel? promotion,
    @JsonKey(name: 'primary_image') ProductImageModel? primaryImage,
    @JsonKey(defaultValue: []) required List<ProductImageModel> images,
    @JsonKey(defaultValue: []) required List<CategoryModel> categories,
    @JsonKey(name: 'average_rating') double? averageRating,
    @JsonKey(name: 'reviews_count', defaultValue: 0) required int reviewsCount,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Product toEntity() => Product(
        id: id,
        name: name,
        description: description,
        price: price,
        originalPrice: originalPrice,
        effectivePrice: effectivePrice,
        discountAmount: discountAmount,
        inStock: inStock,
        isHighlighted: isHighlighted,
        isActive: isActive,
        promotion: promotion?.toEntity(),
        primaryImage: primaryImage?.toEntity(),
        images: images.map((i) => i.toEntity()).toList(),
        categories: categories.map((c) => c.toEntity()).toList(),
        averageRating: averageRating,
        reviewsCount: reviewsCount,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
