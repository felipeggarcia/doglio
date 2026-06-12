library;

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/datasources/admin_categories_remote_datasource.dart';
import '../../data/repositories/admin_categories_repository_impl.dart';
import '../../domain/entities/admin_category.dart';
import '../../domain/usecases/create_admin_category_use_case.dart';
import '../../domain/usecases/delete_admin_category_use_case.dart';
import '../../domain/usecases/get_admin_categories_use_case.dart';
import '../../domain/usecases/update_admin_category_use_case.dart';

class AdminCategoriesState {
  const AdminCategoriesState({
    this.categories = const [],
    this.isLoading = false,
    this.errorMessage,
    this.search = '',
    this.activeFilter,
  });

  final List<AdminCategory> categories;
  final bool isLoading;
  final String? errorMessage;
  final String search;
  final bool? activeFilter; // null = todos, true = ativos, false = inativos

  AdminCategoriesState copyWith({
    List<AdminCategory>? categories,
    bool? isLoading,
    Object? errorMessage = _sentinel,
    String? search,
    Object? activeFilter = _sentinel,
  }) {
    return AdminCategoriesState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
      search: search ?? this.search,
      activeFilter: activeFilter == _sentinel
          ? this.activeFilter
          : activeFilter as bool?,
    );
  }

  static const _sentinel = Object();
}

class AdminCategoriesNotifier extends AutoDisposeNotifier<AdminCategoriesState> {
  late final GetAdminCategoriesUseCase _getCategories;
  late final CreateAdminCategoryUseCase _createCategory;
  late final UpdateAdminCategoryUseCase _updateCategory;
  late final DeleteAdminCategoryUseCase _deleteCategory;
  Timer? _debounce;

  @override
  AdminCategoriesState build() {
    final repo =
        AdminCategoriesRepositoryImpl(AdminCategoriesRemoteDatasource());
    _getCategories = GetAdminCategoriesUseCase(repo);
    _createCategory = CreateAdminCategoryUseCase(repo);
    _updateCategory = UpdateAdminCategoryUseCase(repo);
    _deleteCategory = DeleteAdminCategoryUseCase(repo);
    ref.onDispose(() => _debounce?.cancel());
    Future(_load);
    return const AdminCategoriesState(isLoading: true);
  }

  // ─── Filtros ────────────────────────────────────────────────────────────────

  void setSearch(String value) {
    state = state.copyWith(search: value);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _load);
  }

  void setActiveFilter(bool? active) {
    state = state.copyWith(activeFilter: active);
    _load();
  }

  // ─── Carregamento ─────────────────────────────────────────────────────────

  Future<void> refresh() => _load();

  Future<void> _load() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _getCategories(
      search: state.search,
      isActive: state.activeFilter,
    );
    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, errorMessage: failure.userMessage),
      (categories) =>
          state = state.copyWith(isLoading: false, categories: categories),
    );
  }

  // ─── Mutações ─────────────────────────────────────────────────────────────

  Future<Either<Failure, AdminCategory>> createCategory(
      AdminCategory category) async {
    final result = await _createCategory(category);
    result.fold((_) {}, (_) => _load());
    return result;
  }

  Future<Either<Failure, AdminCategory>> updateCategory(
      AdminCategory category) async {
    final result = await _updateCategory(category);
    result.fold((_) {}, (_) => _load());
    return result;
  }

  Future<Either<Failure, Unit>> deleteCategory(String id) async {
    final result = await _deleteCategory(id);
    result.fold(
      (_) {},
      (_) => state = state.copyWith(
        categories: state.categories.where((c) => c.id != id).toList(),
      ),
    );
    return result;
  }
}

final adminCategoriesProvider =
    AutoDisposeNotifierProvider<AdminCategoriesNotifier, AdminCategoriesState>(
  AdminCategoriesNotifier.new,
);
