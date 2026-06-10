library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/router.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';

/// Ponto de entrada da área administrativa.
///
/// Exibe uma grade de seções de gestão (usuários, produtos, pedidos,
/// categorias, promoções). Cada cartão leva à respectiva tela. As telas
/// reais de CRUD serão integradas conforme os endpoints `/admin/*`.
class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider).valueOrNull;
    final user = authState is Authenticated ? authState.user : null;

    final sections = <_AdminSection>[
      _AdminSection(
        label: context.l10n.adminProducts,
        icon: Icons.inventory_2_outlined,
        routeName: 'admin-products',
        color: const Color(0xFF4F46E5),
      ),
      _AdminSection(
        label: context.l10n.adminOrders,
        icon: Icons.receipt_long_outlined,
        routeName: 'admin-orders',
        color: const Color(0xFF0891B2),
      ),
      _AdminSection(
        label: context.l10n.adminCategories,
        icon: Icons.category_outlined,
        routeName: 'admin-categories',
        color: const Color(0xFF059669),
      ),
      _AdminSection(
        label: context.l10n.adminPromotions,
        icon: Icons.local_offer_outlined,
        routeName: 'admin-promotions',
        color: const Color(0xFFD97706),
      ),
      _AdminSection(
        label: context.l10n.adminUsers,
        icon: Icons.group_outlined,
        routeName: 'admin-users',
        color: const Color(0xFFDB2777),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.adminPanel),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: context.l10n.signOut,
            onPressed: () => _handleLogout(context, ref),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              user != null
                  ? context.l10n.adminGreeting(user.name)
                  : context.l10n.adminPanel,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              context.l10n.adminPanelSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                for (final section in sections)
                  _SectionCard(
                    section: section,
                    onTap: () => context.pushNamed(section.routeName),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.signOut),
        content: Text(ctx.l10n.logoutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(ctx.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(ctx.l10n.signOut),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(authProvider.notifier).signOut();
      if (context.mounted) context.goToLogin();
    }
  }
}

class _AdminSection {
  const _AdminSection({
    required this.label,
    required this.icon,
    required this.routeName,
    required this.color,
  });

  final String label;
  final IconData icon;
  final String routeName;
  final Color color;
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.section, required this.onTap});

  final _AdminSection section;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: section.color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Ícone preenchendo todo o espaço clicável (fundo).
            Padding(
              padding: const EdgeInsets.all(12),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Icon(
                  section.icon,
                  color: section.color.withValues(alpha: 0.22),
                ),
              ),
            ),
            // Texto sobreposto, na frente do ícone.
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                child: Text(
                  section.label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
