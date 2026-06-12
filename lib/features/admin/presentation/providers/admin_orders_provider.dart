library;

import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/datasources/admin_orders_remote_datasource.dart';
import '../../data/repositories/admin_orders_repository_impl.dart';
import '../../domain/entities/admin_order.dart';
import '../../domain/entities/page_meta.dart';
import '../../domain/usecases/add_order_item_use_case.dart';
import '../../domain/usecases/get_admin_order_detail_use_case.dart';
import '../../domain/usecases/get_admin_orders_use_case.dart';
import '../../domain/usecases/remove_order_item_use_case.dart';
import '../../domain/usecases/update_admin_order_status_use_case.dart';
import '../../domain/usecases/update_order_item_use_case.dart';

// ─── Estado da listagem ────────────────────────────────────────────────────────

class AdminOrdersState {
  const AdminOrdersState({
    this.orders = const [],
    this.meta = PageMeta.empty,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.statusFilter,
    this.deliveryTypeFilter,
    this.dateRange,
  });

  final List<AdminOrder> orders;
  final PageMeta meta;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final AdminOrderStatus? statusFilter;

  /// 'delivery' | 'pickup' | null (todos)
  final String? deliveryTypeFilter;
  final DateTimeRange? dateRange;

  bool get hasMore => meta.hasMore;

  AdminOrdersState copyWith({
    List<AdminOrder>? orders,
    PageMeta? meta,
    bool? isLoading,
    bool? isLoadingMore,
    Object? errorMessage = _sentinel,
    Object? statusFilter = _sentinel,
    Object? deliveryTypeFilter = _sentinel,
    Object? dateRange = _sentinel,
  }) =>
      AdminOrdersState(
        orders: orders ?? this.orders,
        meta: meta ?? this.meta,
        isLoading: isLoading ?? this.isLoading,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        errorMessage:
            errorMessage == _sentinel ? this.errorMessage : errorMessage as String?,
        statusFilter: statusFilter == _sentinel
            ? this.statusFilter
            : statusFilter as AdminOrderStatus?,
        deliveryTypeFilter: deliveryTypeFilter == _sentinel
            ? this.deliveryTypeFilter
            : deliveryTypeFilter as String?,
        dateRange:
            dateRange == _sentinel ? this.dateRange : dateRange as DateTimeRange?,
      );

  static const _sentinel = Object();
}

class AdminOrdersNotifier extends AutoDisposeNotifier<AdminOrdersState> {
  late final GetAdminOrdersUseCase _getOrders;

  @override
  AdminOrdersState build() {
    final repo = AdminOrdersRepositoryImpl(AdminOrdersRemoteDatasource());
    _getOrders = GetAdminOrdersUseCase(repo);
    Future(_loadFirstPage);
    return const AdminOrdersState(isLoading: true);
  }

  // ─── Filtros ─────────────────────────────────────────────────────────────────

  void setStatusFilter(AdminOrderStatus? status) {
    state = state.copyWith(statusFilter: status);
    _loadFirstPage();
  }

  void setDeliveryTypeFilter(String? type) {
    state = state.copyWith(deliveryTypeFilter: type);
    _loadFirstPage();
  }

  void setDateRange(DateTimeRange? range) {
    state = state.copyWith(dateRange: range);
    _loadFirstPage();
  }

  // ─── Carregamento ─────────────────────────────────────────────────────────────

  Future<void> refresh() => _loadFirstPage();

  Future<void> _loadFirstPage() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _getOrders(
      status: state.statusFilter,
      deliveryType: state.deliveryTypeFilter,
      dateFrom: state.dateRange?.start,
      dateTo: state.dateRange?.end,
      page: 1,
    );
    result.fold(
      (failure) => state =
          state.copyWith(isLoading: false, errorMessage: failure.userMessage),
      (data) {
        final (orders, meta) = data;
        state = state.copyWith(isLoading: false, orders: orders, meta: meta);
      },
    );
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    final result = await _getOrders(
      status: state.statusFilter,
      deliveryType: state.deliveryTypeFilter,
      dateFrom: state.dateRange?.start,
      dateTo: state.dateRange?.end,
      page: state.meta.currentPage + 1,
    );
    result.fold(
      (failure) => state = state.copyWith(
        isLoadingMore: false,
        errorMessage: failure.userMessage,
      ),
      (data) {
        final (orders, meta) = data;
        state = state.copyWith(
          isLoadingMore: false,
          orders: [...state.orders, ...orders],
          meta: meta,
        );
      },
    );
  }
}

final adminOrdersProvider =
    AutoDisposeNotifierProvider<AdminOrdersNotifier, AdminOrdersState>(
  AdminOrdersNotifier.new,
);

// ─── Estado do detalhe ────────────────────────────────────────────────────────

class AdminOrderDetailState {
  const AdminOrderDetailState({
    this.order,
    this.isLoading = false,
    this.isMutating = false,
    this.errorMessage,
  });

  final AdminOrder? order;
  final bool isLoading;

  /// Mutação em andamento (update status / add/update/remove item).
  final bool isMutating;
  final String? errorMessage;

  AdminOrderDetailState copyWith({
    Object? order = _sentinel,
    bool? isLoading,
    bool? isMutating,
    Object? errorMessage = _sentinel,
  }) =>
      AdminOrderDetailState(
        order: order == _sentinel ? this.order : order as AdminOrder?,
        isLoading: isLoading ?? this.isLoading,
        isMutating: isMutating ?? this.isMutating,
        errorMessage:
            errorMessage == _sentinel ? this.errorMessage : errorMessage as String?,
      );

  static const _sentinel = Object();
}

class AdminOrderDetailNotifier
    extends AutoDisposeFamilyNotifier<AdminOrderDetailState, String> {
  late final GetAdminOrderDetailUseCase _getDetail;
  late final UpdateAdminOrderStatusUseCase _updateStatus;
  late final AddOrderItemUseCase _addItem;
  late final UpdateOrderItemUseCase _updateItem;
  late final RemoveOrderItemUseCase _removeItem;

  String get _orderId => arg;

  @override
  AdminOrderDetailState build(String arg) {
    final repo = AdminOrdersRepositoryImpl(AdminOrdersRemoteDatasource());
    _getDetail = GetAdminOrderDetailUseCase(repo);
    _updateStatus = UpdateAdminOrderStatusUseCase(repo);
    _addItem = AddOrderItemUseCase(repo);
    _updateItem = UpdateOrderItemUseCase(repo);
    _removeItem = RemoveOrderItemUseCase(repo);
    Future(refresh);
    return const AdminOrderDetailState(isLoading: true);
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _getDetail(_orderId);
    result.fold(
      (f) =>
          state = state.copyWith(isLoading: false, errorMessage: f.userMessage),
      (order) => state = state.copyWith(isLoading: false, order: order),
    );
  }

  Future<Either<Failure, Unit>> updateStatus(
    AdminOrderStatus status, {
    String? notes,
  }) async {
    state = state.copyWith(isMutating: true);
    final result = await _updateStatus(_orderId, status, notes: notes);
    result.fold(
      (f) => state = state.copyWith(isMutating: false, errorMessage: f.userMessage),
      (updated) {
        state = state.copyWith(isMutating: false, order: updated);
        // Invalida a lista para o tile refletir o novo status.
        try {
          ref.invalidate(adminOrdersProvider);
        } catch (_) {}
      },
    );
    return result.map((_) => unit);
  }

  Future<Either<Failure, Unit>> addItem({
    required String productId,
    required int quantity,
  }) async {
    state = state.copyWith(isMutating: true);
    final result =
        await _addItem(_orderId, productId: productId, quantity: quantity);
    result.fold(
      (f) => state = state.copyWith(isMutating: false, errorMessage: f.userMessage),
      (updated) => state = state.copyWith(isMutating: false, order: updated),
    );
    return result.map((_) => unit);
  }

  Future<Either<Failure, Unit>> updateItem(
    String itemId, {
    required int quantity,
  }) async {
    state = state.copyWith(isMutating: true);
    final result =
        await _updateItem(_orderId, itemId, quantity: quantity);
    result.fold(
      (f) => state = state.copyWith(isMutating: false, errorMessage: f.userMessage),
      (updated) => state = state.copyWith(isMutating: false, order: updated),
    );
    return result.map((_) => unit);
  }

  Future<Either<Failure, Unit>> removeItem(String itemId) async {
    state = state.copyWith(isMutating: true);
    final result = await _removeItem(_orderId, itemId);
    result.fold(
      (f) => state = state.copyWith(isMutating: false, errorMessage: f.userMessage),
      (updated) => state = state.copyWith(isMutating: false, order: updated),
    );
    return result.map((_) => unit);
  }
}

final adminOrderDetailProvider = AutoDisposeNotifierProvider.family<
    AdminOrderDetailNotifier, AdminOrderDetailState, String>(
  AdminOrderDetailNotifier.new,
);
