library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../domain/entities/admin_promotion.dart';
import '../providers/admin_promotions_provider.dart';

class AdminPromotionsPage extends ConsumerStatefulWidget {
  const AdminPromotionsPage({super.key});

  @override
  ConsumerState<AdminPromotionsPage> createState() =>
      _AdminPromotionsPageState();
}

class _AdminPromotionsPageState extends ConsumerState<AdminPromotionsPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openForm({AdminPromotion? promotion}) async {
    await context.pushNamed('admin-promotion-form', extra: promotion);
    if (!mounted) return;
    await ref.read(adminPromotionsProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminPromotionsProvider);
    final notifier = ref.read(adminPromotionsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.adminPromotions)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(context.l10n.adminPromotionNew),
      ),
      body: Column(
        children: [
          _SearchField(
            controller: _searchController,
            hint: context.l10n.adminPromotionsSearchHint,
            onChanged: notifier.setSearch,
          ),
          _Filters(state: state, notifier: notifier),
          const Divider(height: 1),
          Expanded(
            child: _Body(
              state: state,
              notifier: notifier,
              onTap: (p) => _openForm(promotion: p),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Search ───────────────────────────────────────────────────────────────────

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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          isDense: true,
        ),
      ),
    );
  }
}

// ─── Filters ──────────────────────────────────────────────────────────────────

class _Filters extends StatelessWidget {
  const _Filters({required this.state, required this.notifier});

  final AdminPromotionsState state;
  final AdminPromotionsNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _chip(
            context,
            l10n.adminPromotionFilterActive,
            state.isActiveFilter == true,
            () => notifier.setActiveFilter(
              state.isActiveFilter == true ? null : true,
            ),
          ),
          _chip(
            context,
            l10n.adminPromotionFilterExpired,
            state.expiredFilter == true,
            () => notifier.setExpiredFilter(
              state.expiredFilter == true ? null : true,
            ),
          ),
        ],
      ),
    );
  }

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
      side: BorderSide(color: selected ? scheme.primary : scheme.outline),
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _Body extends StatelessWidget {
  const _Body({
    required this.state,
    required this.notifier,
    required this.onTap,
  });

  final AdminPromotionsState state;
  final AdminPromotionsNotifier notifier;
  final void Function(AdminPromotion) onTap;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && state.promotions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.promotions.isEmpty) {
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
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(context.l10n.retry),
            ),
          ],
        ),
      );
    }

    if (state.promotions.isEmpty) {
      return Center(child: Text(context.l10n.adminPromotionsEmpty));
    }

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: ListView.separated(
        itemCount: state.promotions.length + (state.hasMore ? 1 : 0),
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          if (index == state.promotions.length) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: state.isLoadingMore
                    ? const CircularProgressIndicator()
                    : OutlinedButton(
                        onPressed: notifier.loadMore,
                        child: Text(context.l10n.loadMore),
                      ),
              ),
            );
          }
          final promotion = state.promotions[index];
          return _PromotionTile(
            promotion: promotion,
            onTap: () => onTap(promotion),
          );
        },
      ),
    );
  }
}

// ─── Tile ─────────────────────────────────────────────────────────────────────

class _PromotionTile extends StatelessWidget {
  const _PromotionTile({required this.promotion, required this.onTap});

  final AdminPromotion promotion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fmt = DateFormat('dd/MM/yyyy');
    final period = promotion.endsAt != null
        ? '${fmt.format(promotion.startsAt)} — ${fmt.format(promotion.endsAt!)}'
        : 'A partir de ${fmt.format(promotion.startsAt)}';

    final discountLabel = promotion.type == DiscountType.percentage
        ? '${promotion.discountValue}%'
        : 'R\$ ${promotion.discountValue}';

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: scheme.primaryContainer,
        child: Icon(
          Icons.local_offer_outlined,
          color: scheme.onPrimaryContainer,
          size: 20,
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              promotion.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          _TypeBadge(type: promotion.type, label: discountLabel),
        ],
      ),
      subtitle: Text(period, style: Theme.of(context).textTheme.bodySmall),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            promotion.isCurrentlyActive ? Icons.circle : Icons.circle_outlined,
            size: 12,
            color: promotion.isCurrentlyActive ? Colors.green : scheme.outline,
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: onTap,
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type, required this.label});

  final DiscountType type;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color =
        type == DiscountType.percentage ? Colors.purple : Colors.teal;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
