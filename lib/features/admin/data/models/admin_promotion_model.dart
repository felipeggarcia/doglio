library;

import '../../domain/entities/admin_promotion.dart';

class AdminPromotionModel {
  const AdminPromotionModel({
    required this.id,
    required this.name,
    required this.type,
    required this.discountValue,
    required this.startsAt,
    required this.isActive,
    required this.isCurrentlyActive,
    required this.minQuantity,
    required this.products,
    this.description,
    this.endsAt,
  });

  final String id;
  final String name;
  final String? description;
  final DiscountType type;
  final String discountValue;
  final DateTime startsAt;
  final DateTime? endsAt;
  final bool isActive;
  final bool isCurrentlyActive;
  final int minQuantity;
  final List<AdminPromotionProduct> products;

  factory AdminPromotionModel.fromJson(Map<String, dynamic> json) {
    return AdminPromotionModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      description: json['description'] as String?,
      type: DiscountType.fromApi((json['type'] ?? '').toString()),
      discountValue: (json['discount_value'] ?? '0').toString(),
      startsAt: DateTime.tryParse(json['starts_at']?.toString() ?? '') ??
          DateTime.now(),
      endsAt: json['ends_at'] != null
          ? DateTime.tryParse(json['ends_at'].toString())
          : null,
      isActive: _boolFromJson(json['is_active']) ?? true,
      isCurrentlyActive: _boolFromJson(json['is_currently_active']) ?? false,
      minQuantity: (json['min_quantity'] as num?)?.toInt() ?? 1,
      products: (json['products'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>()
          .map(_productFromJson)
          .toList(),
    );
  }

  static AdminPromotionProduct _productFromJson(Map<String, dynamic> json) =>
      AdminPromotionProduct(
        id: (json['id'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        useLimit: (json['use_limit'] as num?)?.toInt(),
        usesCount: (json['uses_count'] as num?)?.toInt() ?? 0,
      );

  /// Campos editáveis para PUT — sem product_ids (gerenciado por endpoints dedicados).
  Map<String, dynamic> toJson() => {
        'name': name,
        if (description != null) 'description': description,
        'type': type.toApi(),
        'discount_value': discountValue,
        'starts_at': startsAt.toIso8601String(),
        if (endsAt != null) 'ends_at': endsAt!.toIso8601String(),
        'is_active': isActive,
        'min_quantity': minQuantity,
      };

  /// Para POST — inclui product_ids opcionais.
  Map<String, dynamic> toCreateJson({
    List<({String productId, int? useLimit})>? initialProducts,
  }) {
    final base = toJson();
    if (initialProducts != null && initialProducts.isNotEmpty) {
      base['product_ids'] = initialProducts
          .map((p) => {
                'id': p.productId,
                if (p.useLimit != null) 'use_limit': p.useLimit,
              })
          .toList();
    }
    return base;
  }

  AdminPromotion toEntity() => AdminPromotion(
        id: id,
        name: name,
        description: description,
        type: type,
        discountValue: discountValue,
        startsAt: startsAt,
        endsAt: endsAt,
        isActive: isActive,
        isCurrentlyActive: isCurrentlyActive,
        minQuantity: minQuantity,
        products: products,
      );

  factory AdminPromotionModel.fromEntity(AdminPromotion e) =>
      AdminPromotionModel(
        id: e.id,
        name: e.name,
        description: e.description,
        type: e.type,
        discountValue: e.discountValue,
        startsAt: e.startsAt,
        endsAt: e.endsAt,
        isActive: e.isActive,
        isCurrentlyActive: e.isCurrentlyActive,
        minQuantity: e.minQuantity,
        products: e.products,
      );

  static bool? _boolFromJson(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) return value == '1' || value.toLowerCase() == 'true';
    return null;
  }
}
