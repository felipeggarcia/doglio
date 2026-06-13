library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/datasources/admin_orders_remote_datasource.dart';
import '../../data/repositories/admin_orders_repository_impl.dart';
import '../../domain/entities/admin_order.dart';
import '../../domain/entities/admin_order_filters.dart';
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
    this.filters = AdminOrderFilters.empty,
  });

  final List<AdminOrder> orders;
  final PageMeta meta;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final AdminOrderFilters filters;

  bool get hasMore => meta.hasMore;

  AdminOrdersState copyWith({
    List<AdminOrder>? orders,
    PageMeta? meta,
    bool? isLoading,
    bool? isLoadingMore,
    Object? errorMessage = _sentinel,
    Object? filters = _sentinel,
  }) =>
      AdminOrdersState(
        orders: orders ?? this.orders,
        meta: meta ?? this.meta,
        isLoading: isLoading ?? this.isLoading,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        errorMessage:
            errorMessage == _sentinel ? this.errorMessage : errorMessage as String?,
        filters: filters == _sentinel ? this.filters : filters as AdminOrderFilters,
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

  /// Atualiza apenas o campo de busca, preservando os demais filtros.
  void setSearch(String search) {
    state = state.copyWith(filters: state.filters.copyWith(search: search));
    _loadFirstPage();
  }

  /// Aplica os filtros do modal; preserva o campo de busca atual.
  void applyFilters(AdminOrderFilters filters) {
    state = state.copyWith(
      filters: filters.copyWith(search: state.filters.search),
    );
    _loadFirstPage();
  }

  // ─── Carregamento ─────────────────────────────────────────────────────────────

  Future<void> refresh() => _loadFirstPage();

  Future<void> _loadFirstPage() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _getOrders(
      search: _normalizedSearch(),
      status: state.filters.status,
      deliveryType: state.filters.deliveryType,
      dateFrom: state.filters.dateFrom,
      dateTo: state.filters.dateTo,
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
      search: _normalizedSearch(),
      status: state.filters.status,
      deliveryType: state.filters.deliveryType,
      dateFrom: state.filters.dateFrom,
      dateTo: state.filters.dateTo,
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

  /// Normaliza separadores (vírgula, ponto-e-vírgula, espaços) em vírgulas
  /// para o backend interpretar múltiplos números de pedido.
  String? _normalizedSearch() {
    final raw = state.filters.search.trim();
    if (raw.isEmpty) return null;
    return raw
        .split(RegExp(r'[,;\s]+'))
        .where((s) => s.isNotEmpty)
        .join(',');
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
        // Se o PATCH não retornar customer.name (backend pode omitir),
        // preserva o customer que já estava em memória para não crashar a UI.
        final existing = state.order;
        final merged = existing != null && updated.customer.name.isEmpty
            ? updated.copyWith(customer: existing.customer)
            : updated;
        state = state.copyWith(isMutating: false, order: merged);
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
