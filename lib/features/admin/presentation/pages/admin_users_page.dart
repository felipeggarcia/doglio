library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../domain/entities/admin_user.dart';
import '../providers/admin_users_provider.dart';

/// Listagem de usuários (admin) com busca, filtros e paginação.
class AdminUsersPage extends ConsumerStatefulWidget {
  const AdminUsersPage({super.key});

  @override
  ConsumerState<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends ConsumerState<AdminUsersPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminUsersProvider);
    final notifier = ref.read(adminUsersProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.adminUsers)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('admin-user-create'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_alt_1),
        label: Text(context.l10n.adminUserNew),
      ),
      body: Column(
        children: [
          _SearchField(
            controller: _searchController,
            hint: context.l10n.adminUsersSearchHint,
            onChanged: notifier.setSearch,
          ),
          _Filters(state: state, notifier: notifier),
          const Divider(height: 1),
          Expanded(child: _Body(state: state, notifier: notifier)),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          isDense: true,
        ),
      ),
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({required this.state, required this.notifier});

  final AdminUsersState state;
  final AdminUsersNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Wrap quebra para a linha de baixo quando não há espaço na horizontal.
    // Linha 1: função (role). Linha 2: status.
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip(context, l10n.adminFilterAll, state.roleFilter == null,
                  () => notifier.setRoleFilter(null)),
              _chip(context, l10n.adminRoleAdmin,
                  state.roleFilter == AdminUserRole.admin,
                  () => notifier.setRoleFilter(AdminUserRole.admin)),
              _chip(context, l10n.adminRoleCustomer,
                  state.roleFilter == AdminUserRole.customer,
                  () => notifier.setRoleFilter(AdminUserRole.customer)),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip(context, l10n.adminStatusActive, state.activeFilter == true,
                  () => notifier
                      .setActiveFilter(state.activeFilter == true ? null : true)),
              _chip(context, l10n.adminStatusInactive,
                  state.activeFilter == false,
                  () => notifier.setActiveFilter(
                      state.activeFilter == false ? null : false)),
            ],
          ),
        ],
      ),
    );
  }

  /// Chip de filtro com contraste forte: selecionado = preenchido com a cor
  /// primária; não-selecionado = fundo neutro com borda visível.
  Widget _chip(
    BuildContext context,
    String label,
    bool selected,
    VoidCallback onTap,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: scheme.primary,
      backgroundColor: scheme.surfaceContainerHighest,
      labelStyle: TextStyle(
        color: selected ? scheme.onPrimary : scheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide(
        color: selected ? scheme.primary : scheme.outline,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state, required this.notifier});

  final AdminUsersState state;
  final AdminUsersNotifier notifier;

  @override
  Widget build(BuildContext context) {
    // Loading inicial (sem dados ainda)
    if (state.isLoading && state.users.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Erro sem dados → mensagem + tentar novamente
    if (state.errorMessage != null && state.users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: notifier.refresh,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(context.l10n.retry),
            ),
          ],
        ),
      );
    }

    // Lista vazia
    if (state.users.isEmpty) {
      return Center(child: Text(context.l10n.adminUsersEmpty));
    }

    // Lista + botão "carregar mais"
    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: ListView.separated(
        itemCount: state.users.length + (state.hasMore ? 1 : 0),
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          if (index >= state.users.length) {
            return _LoadMoreButton(state: state, notifier: notifier);
          }
          return _UserTile(user: state.users[index]);
        },
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({required this.user});

  final AdminUser user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initial = user.name.isNotEmpty ? user.name[0].toUpperCase() : '?';

    return ListTile(
      leading: CircleAvatar(child: Text(initial)),
      title: Text(user.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(user.email, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RoleChip(role: user.role),
          const SizedBox(width: 8),
          // Indicador de ativo/inativo
          Icon(
            user.isActive ? Icons.circle : Icons.circle_outlined,
            size: 12,
            color: user.isActive ? Colors.green : theme.disabledColor,
          ),
        ],
      ),
      onTap: () => context.pushNamed(
        'admin-user-edit',
        pathParameters: {'id': user.id},
        extra: user,
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({required this.role});

  final AdminUserRole role;

  @override
  Widget build(BuildContext context) {
    final isAdmin = role == AdminUserRole.admin;
    final color = isAdmin ? const Color(0xFFDB2777) : const Color(0xFF0891B2);
    final label =
        isAdmin ? context.l10n.adminRoleAdmin : context.l10n.adminRoleCustomer;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _LoadMoreButton extends StatelessWidget {
  const _LoadMoreButton({required this.state, required this.notifier});

  final AdminUsersState state;
  final AdminUsersNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: state.isLoadingMore
            ? const CircularProgressIndicator()
            : OutlinedButton(
                onPressed: notifier.loadMore,
                child: Text(context.l10n.adminLoadMore),
              ),
      ),
    );
  }
}
