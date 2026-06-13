library;

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/datasources/admin_promotions_remote_datasource.dart';
import '../../data/repositories/admin_promotions_repository_impl.dart';
import '../../domain/entities/admin_promotion.dart';
import '../../domain/entities/page_meta.dart';
import '../../domain/usecases/create_admin_promotion_use_case.dart';
import '../../domain/usecases/delete_admin_promotion_use_case.dart';
import '../../domain/usecases/get_admin_promotions_use_case.dart';
import '../../domain/usecases/link_promotion_products_use_case.dart';
import '../../domain/usecases/unlink_promotion_products_use_case.dart';
import '../../domain/usecases/update_admin_promotion_use_case.dart';

// ─── Estado da listagem ───────────────────────────────────────────────────────

class AdminPromotionsState {
  const AdminPromotionsState({
    this.promotions = const [],
    this.meta = PageMeta.empty,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.search = '',
    this.isActiveFilter,
    this.expiredFilter,
  });

  final List<AdminPromotion> promotions;
  final PageMeta meta;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final String search;
  final bool? isActiveFilter;
  final bool? expiredFilter;

  bool get hasMore => meta.hasMore;

  AdminPromotionsState copyWith({
    List<AdminPromotion>? promotions,
    PageMeta? meta,
    bool? isLoading,
    bool? isLoadingMore,
    Object? errorMessage = _sentinel,
    String? search,
    Object? isActiveFilter = _sentinel,
    Object? expiredFilter = _sentinel,
  }) =>
      AdminPromotionsState(
        promotions: promotions ?? this.promotions,
        meta: meta ?? this.meta,
        isLoading: isLoading ?? this.isLoading,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        errorMessage:
            errorMessage == _sentinel ? this.errorMessage : errorMessage as String?,
        search: search ?? this.search,
        isActiveFilter: isActiveFilter == _sentinel
            ? this.isActiveFilter
            : isActiveFilter as bool?,
        expiredFilter: expiredFilter == _sentinel
            ? this.expiredFilter
            : expiredFilter as bool?,
      );

  static const _sentinel = Object();
}

// ─── Notifier da listagem ─────────────────────────────────────────────────────

class AdminPromotionsNotifier
    extends AutoDisposeNotifier<AdminPromotionsState> {
  late final GetAdminPromotionsUseCase _getPromotions;
  late final CreateAdminPromotionUseCase _createPromotion;
  late final UpdateAdminPromotionUseCase _updatePromotion;
  late final DeleteAdminPromotionUseCase _deletePromotion;
  late final LinkPromotionProductsUseCase _linkProducts;
  late final UnlinkPromotionProductsUseCase _unlinkProducts;
  Timer? _debounce;

  @override
  AdminPromotionsState build() {
    final datasource = AdminPromotionsRemoteDatasource();
    final repo = AdminPromotionsRepositoryImpl(datasource);
    _getPromotions = GetAdminPromotionsUseCase(repo);
    _createPromotion = CreateAdminPromotionUseCase(repo);
    _updatePromotion = UpdateAdminPromotionUseCase(repo);
    _deletePromotion = DeleteAdminPromotionUseCase(repo);
    _linkProducts = LinkPromotionProductsUseCase(repo);
    _unlinkProducts = UnlinkPromotionProductsUseCase(repo);
    ref.onDispose(() => _debounce?.cancel());
    Future(_loadFirstPage);
    return const AdminPromotionsState(isLoading: true);
  }

  // ─── Filtros ─────────────────────────────────────────────────────────────────

  void setSearch(String value) {
    state = state.copyWith(search: value);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _loadFirstPage);
  }

  void setActiveFilter(bool? value) {
    state = state.copyWith(isActiveFilter: value);
    _loadFirstPage();
  }

  void setExpiredFilter(bool? value) {
    state = state.copyWith(expiredFilter: value);
    _loadFirstPage();
  }

  // ─── Carregamento ─────────────────────────────────────────────────────────────

  Future<void> refresh() => _loadFirstPage();

  Future<void> _loadFirstPage() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _getPromotions(
      isActive: state.isActiveFilter,
      expired: state.expiredFilter,
      search: state.search.trim().isEmpty ? null : state.search.trim(),
      page: 1,
    );
    result.fold(
      (failure) => state =
          state.copyWith(isLoading: false, errorMessage: failure.userMessage),
      (data) {
        final (promotions, meta) = data;
        state =
            state.copyWith(isLoading: false, promotions: promotions, meta: meta);
      },
    );
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    final result = await _getPromotions(
      isActive: state.isActiveFilter,
      expired: state.expiredFilter,
      search: state.search.trim().isEmpty ? null : state.search.trim(),
      page: state.meta.currentPage + 1,
    );
    result.fold(
      (failure) =>
          state = state.copyWith(isLoadingMore: false, errorMessage: failure.userMessage),
      (data) {
        final (promotions, meta) = data;
        state = state.copyWith(
          isLoadingMore: false,
          promotions: [...state.promotions, ...promotions],
          meta: meta,
        );
      },
    );
  }

  // ─── Mutações ─────────────────────────────────────────────────────────────────

  Future<Either<Failure, AdminPromotion>> createPromotion(
      AdminPromotion promotion) async {
    final result = await _createPromotion(promotion);
    result.fold((_) {}, (_) => unawaited(_loadFirstPage()));
    return result;
  }

  Future<Either<Failure, AdminPromotion>> updatePromotion(
      AdminPromotion promotion) async {
    final result = await _updatePromotion(promotion);
    result.fold((_) {}, (_) => unawaited(_loadFirstPage()));
    return result;
  }

  Future<Either<Failure, Unit>> deletePromotion(String id) async {
    final result = await _deletePromotion(id);
    result.fold(
      (_) {},
      (_) => state = state.copyWith(
        promotions: state.promotions.where((p) => p.id != id).toList(),
      ),
    );
    return result;
  }

  Future<Either<Failure, AdminPromotion>> linkProducts(
    String id,
    List<({String productId, int? useLimit})> products,
  ) async {
    final result = await _linkProducts(id, products);
    result.fold(
      (_) {},
      (updated) => state = state.copyWith(
        promotions: state.promotions
            .map((p) => p.id == id ? updated : p)
            .toList(),
      ),
    );
    return result;
  }

  Future<Either<Failure, AdminPromotion>> unlinkProducts(
    String id,
    List<String> productIds,
  ) async {
    final result = await _unlinkProducts(id, productIds);
    result.fold(
      (_) {},
      (updated) => state = state.copyWith(
        promotions: state.promotions
            .map((p) => p.id == id ? updated : p)
            .toList(),
      ),
    );
    return result;
  }
}

final adminPromotionsProvider = AutoDisposeNotifierProvider<
    AdminPromotionsNotifier, AdminPromotionsState>(
  AdminPromotionsNotifier.new,
);

// ─── Provider family para promoções de um produto específico ──────────────────

class AdminProductPromotionsNotifier
    extends AutoDisposeFamilyNotifier<AsyncValue<List<AdminPromotion>>, String> {
  late final GetAdminPromotionsUseCase _getPromotions;
  late final LinkPromotionProductsUseCase _linkProducts;
  late final UnlinkPromotionProductsUseCase _unlinkProducts;

  @override
  AsyncValue<List<AdminPromotion>> build(String arg) {
    final datasource = AdminPromotionsRemoteDatasource();
    final repo = AdminPromotionsRepositoryImpl(datasource);
    _getPromotions = GetAdminPromotionsUseCase(repo);
    _linkProducts = LinkPromotionProductsUseCase(repo);
    _unlinkProducts = UnlinkPromotionProductsUseCase(repo);
    Future(() => _load(arg));
    return const AsyncValue.loading();
  }

  Future<void> refresh() => _load(arg);

  Future<Either<Failure, AdminPromotion>> linkProducts(
    List<({String productId, int? useLimit})> products,
  ) async {
    final result = await _linkProducts(arg, products);
    result.fold((_) {}, (_) => unawaited(_load(arg)));
    return result;
  }

  Future<Either<Failure, AdminPromotion>> unlinkProducts(
    List<String> productIds,
  ) async {
    final result = await _unlinkProducts(arg, productIds);
    result.fold((_) {}, (_) => unawaited(_load(arg)));
    return result;
  }

  Future<void> _load(String productId) async {
    state = const AsyncValue.loading();
    final result = await _getPromotions(
      productIds: [productId],
      page: 1,
    );
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.userMessage, StackTrace.current),
      (data) {
        final (promotions, _) = data;
        state = AsyncValue.data(promotions);
      },
    );
  }
}

final adminProductPromotionsProvider = AutoDisposeNotifierProvider.family<
    AdminProductPromotionsNotifier,
    AsyncValue<List<AdminPromotion>>,
    String>(AdminProductPromotionsNotifier.new);
