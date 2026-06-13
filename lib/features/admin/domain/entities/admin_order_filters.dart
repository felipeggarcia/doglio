library;

import 'admin_order.dart';

/// Filtros da listagem admin de pedidos.
class AdminOrderFilters {
  const AdminOrderFilters({
    this.search = '',
    this.status,
    this.deliveryType,
    this.dateFrom,
    this.dateTo,
  });

  final String search;
  final AdminOrderStatus? status;

  /// 'delivery' | 'pickup' | null (todos)
  final String? deliveryType;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  static const empty = AdminOrderFilters();

  bool get hasActiveFilters =>
      status != null || deliveryType != null || dateFrom != null || dateTo != null;

  int get activeFilterCount {
    var n = 0;
    if (status != null) n++;
    if (deliveryType != null) n++;
    if (dateFrom != null || dateTo != null) n++;
    return n;
  }

  AdminOrderFilters copyWith({
    String? search,
    Object? status = _sentinel,
    Object? deliveryType = _sentinel,
    Object? dateFrom = _sentinel,
    Object? dateTo = _sentinel,
  }) =>
      AdminOrderFilters(
        search: search ?? this.search,
        status: status == _sentinel ? this.status : status as AdminOrderStatus?,
        deliveryType:
            deliveryType == _sentinel ? this.deliveryType : deliveryType as String?,
        dateFrom: dateFrom == _sentinel ? this.dateFrom : dateFrom as DateTime?,
        dateTo: dateTo == _sentinel ? this.dateTo : dateTo as DateTime?,
      );

  static const _sentinel = Object();
}
