library;

enum DiscountType {
  percentage,
  fixed;

  String toApi() => switch (this) {
        DiscountType.percentage => 'percentage',
        DiscountType.fixed => 'fixed',
      };

  static DiscountType fromApi(String value) => switch (value) {
        'fixed' => DiscountType.fixed,
        _ => DiscountType.percentage,
      };
}

class AdminPromotionProduct {
  const AdminPromotionProduct({
    required this.id,
    required this.name,
    required this.usesCount,
    this.useLimit,
  });

  final String id;
  final String name;
  final int? useLimit;
  final int usesCount;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AdminPromotionProduct && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

class AdminPromotion {
  const AdminPromotion({
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

  bool get isExpired => endsAt != null && endsAt!.isBefore(DateTime.now());

  AdminPromotion copyWith({
    String? id,
    String? name,
    Object? description = _sentinel,
    DiscountType? type,
    String? discountValue,
    DateTime? startsAt,
    Object? endsAt = _sentinel,
    bool? isActive,
    bool? isCurrentlyActive,
    int? minQuantity,
    List<AdminPromotionProduct>? products,
  }) {
    return AdminPromotion(
      id: id ?? this.id,
      name: name ?? this.name,
      description:
          description == _sentinel ? this.description : description as String?,
      type: type ?? this.type,
      discountValue: discountValue ?? this.discountValue,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt == _sentinel ? this.endsAt : endsAt as DateTime?,
      isActive: isActive ?? this.isActive,
      isCurrentlyActive: isCurrentlyActive ?? this.isCurrentlyActive,
      minQuantity: minQuantity ?? this.minQuantity,
      products: products ?? this.products,
    );
  }

  static const _sentinel = Object();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is AdminPromotion && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
