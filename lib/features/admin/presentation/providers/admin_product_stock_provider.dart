/// Provider (family por productId) do histórico e ajuste de estoque.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/datasources/admin_products_remote_datasource.dart';
import '../../data/repositories/admin_products_repository_impl.dart';
import '../../domain/entities/page_meta.dart';
import '../../domain/entities/stock_movement.dart';
import '../../domain/usecases/adjust_product_stock_use_case.dart';
import '../../domain/usecases/get_product_stock_movements_use_case.dart';
import 'admin_products_provider.dart';

/// Estado imutável da tela de estoque de um produto.
class AdminProductStockState {
  const AdminProductStockState({
    this.movements = const [],
    this.meta = PageMeta.empty,
    this.currentStock,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  final List<StockMovement> movements;
  final PageMeta meta;

  /// Estoque atual conhecido — atualizado pelo `stockAfter` da movimentação
  /// mais recente; null até o primeiro carregamento com dados.
  final int? currentStock;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;

  bool get hasMore => meta.hasMore;

  AdminProductStockState copyWith({
    List<StockMovement>? movements,
    PageMeta? meta,
    Object? currentStock = _sentinel,
    bool? isLoading,
    bool? isLoadingMore,
    Object? errorMessage = _sentinel,
  }) {
    return AdminProductStockState(
      movements: movements ?? this.movements,
      meta: meta ?? this.meta,
      currentStock:
          currentStock == _sentinel ? this.currentStock : currentStock as int?,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage:
          errorMessage == _sentinel ? this.errorMessage : errorMessage as String?,
    );
  }

  static const _sentinel = Object();
}

class AdminProductStockNotifier
    extends AutoDisposeFamilyNotifier<AdminProductStockState, String> {
  late final GetProductStockMovementsUseCase _getMovements;
  late final AdjustProductStockUseCase _adjustStock;

  String get _productId => arg;

  @override
  AdminProductStockState build(String arg) {
    final repo =
        AdminProductsRepositoryImpl(AdminProductsRemoteDatasource());
    _getMovements = GetProductStockMovementsUseCase(repo);
    _adjustStock = AdjustProductStockUseCase(repo);
    Future(_loadFirstPage);
    return const AdminProductStockState(isLoading: true);
  }

  Future<void> refresh() => _loadFirstPage();

  Future<void> _loadFirstPage() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _getMovements(_productId, page: 1);
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.userMessage,
      ),
      (data) {
        final (movements, meta) = data;
        state = state.copyWith(
          isLoading: false,
          movements: movements,
          meta: meta,
          // A primeira movimentação é a mais recente (histórico desc).
          currentStock: movements.isNotEmpty
              ? movements.first.stockAfter
              : state.currentStock,
        );
      },
    );
  }

  /// Carrega a próxima página e concatena no histórico atual.
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    final result =
        await _getMovements(_productId, page: state.meta.currentPage + 1);
    result.fold(
      (failure) => state = state.copyWith(
        isLoadingMore: false,
        errorMessage: failure.userMessage,
      ),
      (data) {
        final (movements, meta) = data;
        state = state.copyWith(
          isLoadingMore: false,
          movements: [...state.movements, ...movements],
          meta: meta,
        );
      },
    );
  }

  /// Movimenta o estoque e, em caso de sucesso, recarrega o histórico e a
  /// listagem de produtos (para o `stock_quantity` refletir lá).
  Future<Either<Failure, StockMovement>> adjust({
    StockMovementType? type,
    int? quantity,
    int? absolute,
    StockMovementReason reason = StockMovementReason.manualAdjustment,
    String? notes,
  }) async {
    final result = await _adjustStock(
      _productId,
      type: type,
      quantity: quantity,
      absolute: absolute,
      reason: reason,
      notes: notes,
    );
    result.fold(
      (_) {},
      (movement) {
        state = state.copyWith(currentStock: movement.stockAfter);
        _loadFirstPage();
        ref.read(adminProductsProvider.notifier).refresh();
      },
    );
    return result;
  }
}

final adminProductStockProvider = AutoDisposeNotifierProvider.family<
    AdminProductStockNotifier, AdminProductStockState, String>(
  AdminProductStockNotifier.new,
);
