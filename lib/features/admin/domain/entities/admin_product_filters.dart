/// Filtros da listagem admin de produtos.
///
/// Agrupados em um objeto imutável para evitar assinaturas gigantes em
/// use case, repositório e datasource.
library;

enum AdminProductSort {
  name,
  price,
  stockQuantity,
  createdAt,
  updatedAt;

  String toApi() => switch (this) {
        AdminProductSort.name => 'name',
        AdminProductSort.price => 'price',
        AdminProductSort.stockQuantity => 'stock_quantity',
        AdminProductSort.createdAt => 'created_at',
        AdminProductSort.updatedAt => 'updated_at',
      };
}

class AdminProductFilters {
  const AdminProductFilters({
    this.search = '',
    this.isActive,
    this.isHighlighted,
    this.outOfStock,
    this.categoryIds = const [],
    this.priceMin,
    this.priceMax,
    this.dateFrom,
    this.dateTo,
    this.sortBy = AdminProductSort.createdAt,
    this.sortDesc = true,
  });

  final String search;
  final bool? isActive;
  final bool? isHighlighted;
  final bool? outOfStock;
  final List<String> categoryIds;
  final String? priceMin;
  final String? priceMax;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final AdminProductSort sortBy;
  final bool sortDesc;

  static const empty = AdminProductFilters();

  /// Há algum filtro do bottom sheet ativo (badge no botão "Filtros").
  bool get hasAdvancedFilters =>
      categoryIds.isNotEmpty ||
      priceMin != null ||
      priceMax != null ||
      dateFrom != null ||
      dateTo != null ||
      sortBy != AdminProductSort.createdAt ||
      !sortDesc;

  AdminProductFilters copyWith({
    String? search,
    Object? isActive = _sentinel,
    Object? isHighlighted = _sentinel,
    Object? outOfStock = _sentinel,
    List<String>? categoryIds,
    Object? priceMin = _sentinel,
    Object? priceMax = _sentinel,
    Object? dateFrom = _sentinel,
    Object? dateTo = _sentinel,
    AdminProductSort? sortBy,
    bool? sortDesc,
  }) {
    return AdminProductFilters(
      search: search ?? this.search,
      isActive: isActive == _sentinel ? this.isActive : isActive as bool?,
      isHighlighted: isHighlighted == _sentinel
          ? this.isHighlighted
          : isHighlighted as bool?,
      outOfStock:
          outOfStock == _sentinel ? this.outOfStock : outOfStock as bool?,
      categoryIds: categoryIds ?? this.categoryIds,
      priceMin: priceMin == _sentinel ? this.priceMin : priceMin as String?,
      priceMax: priceMax == _sentinel ? this.priceMax : priceMax as String?,
      dateFrom: dateFrom == _sentinel ? this.dateFrom : dateFrom as DateTime?,
      dateTo: dateTo == _sentinel ? this.dateTo : dateTo as DateTime?,
      sortBy: sortBy ?? this.sortBy,
      sortDesc: sortDesc ?? this.sortDesc,
    );
  }

  static const _sentinel = Object();
}
