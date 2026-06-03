library;

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/cart_remote_datasource.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/usecases/clear_cart_use_case.dart';
import '../../domain/usecases/get_cart_use_case.dart';
import '../../domain/usecases/sync_cart_use_case.dart';
import '../../../store/domain/entities/product.dart';

// ─── Estado ────────────────────────────────────────────────────────────────────

class CartState {
  const CartState({
    this.items = const [],
    this.total = '0.00',
    this.isSyncing = false,
    this.isLoading = false,
    this.hasStockWarning = false,
    this.hasPriceChange = false,
    this.errorMessage,
  });

  final List<CartItem> items;
  final String total;
  final bool isSyncing;
  final bool isLoading;
  final bool hasStockWarning;
  final bool hasPriceChange;
  final String? errorMessage;

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => items.isEmpty;

  /// Total calculado localmente — sempre qty × price, não depende do backend
  String get computedTotal {
    final sum = items.fold(
      0.0,
      (acc, item) =>
          acc + (double.tryParse(item.displayUnitPrice) ?? 0.0) * item.quantity,
    );
    return sum.toStringAsFixed(2);
  }

  CartState copyWith({
    List<CartItem>? items,
    String? total,
    bool? isSyncing,
    bool? isLoading,
    bool? hasStockWarning,
    bool? hasPriceChange,
    Object? errorMessage = _sentinel,
  }) {
    return CartState(
      items: items ?? this.items,
      total: total ?? this.total,
      isSyncing: isSyncing ?? this.isSyncing,
      isLoading: isLoading ?? this.isLoading,
      hasStockWarning: hasStockWarning ?? this.hasStockWarning,
      hasPriceChange: hasPriceChange ?? this.hasPriceChange,
      errorMessage:
          errorMessage == _sentinel ? this.errorMessage : errorMessage as String?,
    );
  }
}

const _sentinel = Object();

// ─── Notifier ─────────────────────────────────────────────────────────────────

class CartNotifier extends Notifier<CartState> {
  late final GetCartUseCase _getCart;
  late final SyncCartUseCase _syncCart;
  late final ClearCartUseCase _clearCart;

  Timer? _debounceTimer;

  @override
  CartState build() {
    final repo = CartRepositoryImpl(CartRemoteDatasource());
    _getCart = GetCartUseCase(repo);
    _syncCart = SyncCartUseCase(repo);
    _clearCart = ClearCartUseCase(repo);

    ref.onDispose(() => _debounceTimer?.cancel());

    Future(() => _loadCart());
    return const CartState();
  }

  Future<void> _loadCart() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _getCart();
    result.fold(
      (failure) => state = state.copyWith(isLoading: false),
      (cart) => state = CartState(
        items: cart.items,
        total: cart.total,
        hasStockWarning: cart.hasStockWarning,
        hasPriceChange: cart.hasPriceChange,
      ),
    );
  }

  List<Map<String, dynamic>> _toSyncPayload() {
    return state.items
        .map((item) => {'product_id': item.productId, 'quantity': item.quantity})
        .toList();
  }

  void _scheduleSync() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(
      const Duration(milliseconds: 500),
      _syncToBackend,
    );
  }

  Future<void> _syncToBackend() async {
    if (state.items.isEmpty) {
      await _clearCartOnBackend();
      return;
    }
    state = state.copyWith(isSyncing: true, errorMessage: null);
    final result = await _syncCart(_toSyncPayload());
    result.fold(
      (failure) =>
          state = state.copyWith(isSyncing: false, errorMessage: failure.userMessage),
      (cart) => state = CartState(
        items: cart.items,
        total: cart.total,
        isSyncing: false,
        hasStockWarning: cart.hasStockWarning,
        hasPriceChange: cart.hasPriceChange,
      ),
    );
  }

  Future<void> _clearCartOnBackend() async {
    final result = await _clearCart();
    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, errorMessage: failure.userMessage),
      (_) => state = const CartState(),
    );
  }

  // ─── Ações públicas ──────────────────────────────────────────────────────────

  void addItem(Product product, {int quantity = 1}) {
    final existingIndex =
        state.items.indexWhere((i) => i.productId == product.id);

    List<CartItem> updated;

    if (existingIndex >= 0) {
      final existing = state.items[existingIndex];
      final newQty = existing.quantity + quantity;
      final subtotal =
          (double.tryParse(existing.displayUnitPrice) ?? 0.0) * newQty;
      updated = List.of(state.items);
      updated[existingIndex] = CartItem(
        productId: existing.productId,
        product: existing.product,
        quantity: newQty,
        unitPrice: existing.unitPrice,
        effectiveUnitPrice: existing.effectiveUnitPrice,
        subtotal: subtotal.toStringAsFixed(2),
      );
    } else {
      final unitPrice = product.displayPrice;
      final subtotal =
          (double.tryParse(unitPrice) ?? 0.0) * quantity;
      updated = [
        ...state.items,
        CartItem(
          productId: product.id,
          product: product,
          quantity: quantity,
          unitPrice: unitPrice,
          effectiveUnitPrice: product.hasPromotion ? product.effectivePrice : null,
          subtotal: subtotal.toStringAsFixed(2),
        ),
      ];
    }

    state = state.copyWith(items: updated);
    _scheduleSync();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    final updated = state.items.map((item) {
      if (item.productId != productId) return item;
      final subtotal =
          (double.tryParse(item.displayUnitPrice) ?? 0.0) * quantity;
      return CartItem(
        productId: item.productId,
        product: item.product,
        quantity: quantity,
        unitPrice: item.unitPrice,
        effectiveUnitPrice: item.effectiveUnitPrice,
        subtotal: subtotal.toStringAsFixed(2),
      );
    }).toList();

    state = state.copyWith(items: updated);
    _scheduleSync();
  }

  void removeItem(String productId) {
    final updated = state.items.where((i) => i.productId != productId).toList();
    state = state.copyWith(items: updated);
    _scheduleSync();
  }

  Future<void> clear() async {
    _debounceTimer?.cancel();
    state = state.copyWith(isLoading: true);
    await _clearCartOnBackend();
  }

  Future<void> refresh() => _loadCart();

  // ─── Queries ─────────────────────────────────────────────────────────────────

  bool hasProduct(String productId) =>
      state.items.any((i) => i.productId == productId);

  int quantityOf(String productId) =>
      state.items
          .where((i) => i.productId == productId)
          .firstOrNull
          ?.quantity ??
      0;
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final cartProvider = NotifierProvider<CartNotifier, CartState>(
  CartNotifier.new,
);
