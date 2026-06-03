// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductImageModel _$ProductImageModelFromJson(Map<String, dynamic> json) =>
    _ProductImageModel(
      id: json['id'] as String,
      imagePath: json['imagePath'] as String,
      order: (json['order'] as num?)?.toInt() ?? 0,
      isPrimary: json['is_primary'] as bool? ?? false,
    );

Map<String, dynamic> _$ProductImageModelToJson(_ProductImageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imagePath': instance.imagePath,
      'order': instance.order,
      'is_primary': instance.isPrimary,
    };

_PromotionModel _$PromotionModelFromJson(Map<String, dynamic> json) =>
    _PromotionModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      discountValue: (json['discount_value'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$PromotionModelToJson(_PromotionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'discount_value': instance.discountValue,
    };

_CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    _CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      isHighlighted: json['is_highlighted'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      productsCount: (json['products_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CategoryModelToJson(_CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'is_highlighted': instance.isHighlighted,
      'is_active': instance.isActive,
      'products_count': instance.productsCount,
    };

_ProductModel _$ProductModelFromJson(Map<String, dynamic> json) =>
    _ProductModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: _priceFromJson(json['price']),
      originalPrice: _nullablePriceFromJson(json['original_price']),
      effectivePrice: _nullablePriceFromJson(json['effective_price']),
      discountAmount: _nullablePriceFromJson(json['discount_amount']),
      inStock: json['in_stock'] as bool? ?? false,
      isHighlighted: json['is_highlighted'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      promotion: json['promotion'] == null
          ? null
          : PromotionModel.fromJson(json['promotion'] as Map<String, dynamic>),
      primaryImage: json['primary_image'] == null
          ? null
          : ProductImageModel.fromJson(
              json['primary_image'] as Map<String, dynamic>,
            ),
      images:
          (json['images'] as List<dynamic>?)
              ?.map(
                (e) => ProductImageModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      averageRating: (json['average_rating'] as num?)?.toDouble(),
      reviewsCount: (json['reviews_count'] as num?)?.toInt() ?? 0,
      createdAt: _dateTimeFromJson(json['created_at']),
      updatedAt: _dateTimeFromJson(json['updated_at']),
    );

Map<String, dynamic> _$ProductModelToJson(_ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'original_price': instance.originalPrice,
      'effective_price': instance.effectivePrice,
      'discount_amount': instance.discountAmount,
      'in_stock': instance.inStock,
      'is_highlighted': instance.isHighlighted,
      'is_active': instance.isActive,
      'promotion': instance.promotion,
      'primary_image': instance.primaryImage,
      'images': instance.images,
      'categories': instance.categories,
      'average_rating': instance.averageRating,
      'reviews_count': instance.reviewsCount,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
