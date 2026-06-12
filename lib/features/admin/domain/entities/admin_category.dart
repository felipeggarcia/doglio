library;

class AdminCategory {
  const AdminCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.isHighlighted,
    required this.isActive,
    required this.productsCount,
  });

  final String id;
  final String name;
  final String slug;
  final bool isHighlighted;
  final bool isActive;
  final int productsCount;

  AdminCategory copyWith({
    String? id,
    String? name,
    String? slug,
    bool? isHighlighted,
    bool? isActive,
    int? productsCount,
  }) {
    return AdminCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      isActive: isActive ?? this.isActive,
      productsCount: productsCount ?? this.productsCount,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is AdminCategory && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
