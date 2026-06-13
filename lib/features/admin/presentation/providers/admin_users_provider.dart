/// Provider de estado da listagem de usuários admin.
///
/// Usa Notifier + objeto de estado imutável porque há várias dimensões
/// (lista, paginação, filtros, busca). Espelha o padrão de StoreNotifier.
library;

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/datasources/admin_users_remote_datasource.dart';
import '../../data/repositories/admin_users_repository_impl.dart';
import '../../domain/entities/admin_user.dart';
import '../../domain/entities/page_meta.dart';
import '../../domain/usecases/create_admin_user_use_case.dart';
import '../../domain/usecases/delete_admin_user_use_case.dart';
import '../../domain/usecases/get_admin_users_use_case.dart';
import '../../domain/usecases/update_admin_user_use_case.dart';

/// Estado imutável da tela de usuários.
class AdminUsersState {
  const AdminUsersState({
    this.users = const [],
    this.meta = PageMeta.empty,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.search = '',
    this.roleFilter,
    this.activeFilter,
  });

  final List<AdminUser> users;
  final PageMeta meta;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final String search;
  final AdminUserRole? roleFilter;
  final bool? activeFilter;

  bool get hasMore => meta.hasMore;

  AdminUsersState copyWith({
    List<AdminUser>? users,
    PageMeta? meta,
    bool? isLoading,
    bool? isLoadingMore,
    // Sentinela para permitir voltar errorMessage/filtros a null explicitamente.
    Object? errorMessage = _sentinel,
    String? search,
    Object? roleFilter = _sentinel,
    Object? activeFilter = _sentinel,
  }) {
    return AdminUsersState(
      users: users ?? this.users,
      meta: meta ?? this.meta,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage:
          errorMessage == _sentinel ? this.errorMessage : errorMessage as String?,
      search: search ?? this.search,
      roleFilter:
          roleFilter == _sentinel ? this.roleFilter : roleFilter as AdminUserRole?,
      activeFilter:
          activeFilter == _sentinel ? this.activeFilter : activeFilter as bool?,
    );
  }

  static const _sentinel = Object();
}

class AdminUsersNotifier extends AutoDisposeNotifier<AdminUsersState> {
  late final GetAdminUsersUseCase _getUsers;
  late final CreateAdminUserUseCase _createUser;
  late final UpdateAdminUserUseCase _updateUser;
  late final DeleteAdminUserUseCase _deleteUser;
  Timer? _debounce;

  @override
  AdminUsersState build() {
    final repo = AdminUsersRepositoryImpl(AdminUsersRemoteDatasource());
    _getUsers = GetAdminUsersUseCase(repo);
    _createUser = CreateAdminUserUseCase(repo);
    _updateUser = UpdateAdminUserUseCase(repo);
    _deleteUser = DeleteAdminUserUseCase(repo);
    ref.onDispose(() => _debounce?.cancel());
    // Carrega a primeira página logo após o build.
    Future(_loadFirstPage);
    return const AdminUsersState(isLoading: true);
  }

  // ─── Filtros ────────────────────────────────────────────────────────────────

  /// Busca com debounce: só dispara 400ms após a última tecla.
  void setSearch(String value) {
    state = state.copyWith(search: value);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _loadFirstPage);
  }

  void setRoleFilter(AdminUserRole? role) {
    state = state.copyWith(roleFilter: role);
    _loadFirstPage();
  }

  void setActiveFilter(bool? active) {
    state = state.copyWith(activeFilter: active);
    _loadFirstPage();
  }

  // ─── Carregamento ─────────────────────────────────────────────────────────

  Future<void> refresh() => _loadFirstPage();

  Future<void> _loadFirstPage() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _getUsers(
      search: state.search,
      role: state.roleFilter,
      isActive: state.activeFilter,
      page: 1,
    );
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.userMessage,
      ),
      (data) {
        final (users, meta) = data;
        state = state.copyWith(isLoading: false, users: users, meta: meta);
      },
    );
  }

  /// Carrega a próxima página e concatena na lista atual.
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    final result = await _getUsers(
      search: state.search,
      role: state.roleFilter,
      isActive: state.activeFilter,
      page: state.meta.currentPage + 1,
    );
    result.fold(
      (failure) => state = state.copyWith(
        isLoadingMore: false,
        errorMessage: failure.userMessage,
      ),
      (data) {
        final (users, meta) = data;
        state = state.copyWith(
          isLoadingMore: false,
          users: [...state.users, ...users],
          meta: meta,
        );
      },
    );
  }

  // ─── Mutações (retornam Either para a UI exibir erro) ───────────────────────

  Future<Either<Failure, AdminUser>> createUser(
    AdminUser user, {
    required String password,
  }) async {
    final result = await _createUser(user, password: password);
    result.fold((_) {}, (_) => unawaited(_loadFirstPage()));
    return result;
  }

  Future<Either<Failure, AdminUser>> updateUser(AdminUser user) async {
    final result = await _updateUser(user);
    result.fold((_) {}, (_) => unawaited(_loadFirstPage()));
    return result;
  }

  Future<Either<Failure, Unit>> deleteUser(String id) async {
    final result = await _deleteUser(id);
    result.fold(
      (_) {},
      // Remoção otimista: tira da lista local sem refetch.
      (_) => state = state.copyWith(
        users: state.users.where((u) => u.id != id).toList(),
      ),
    );
    return result;
  }
}

final adminUsersProvider =
    AutoDisposeNotifierProvider<AdminUsersNotifier, AdminUsersState>(
  AdminUsersNotifier.new,
);
