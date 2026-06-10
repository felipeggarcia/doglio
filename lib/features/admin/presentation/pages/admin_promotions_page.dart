library;

import 'package:flutter/material.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../widgets/admin_placeholder_scaffold.dart';

/// Seção de gestão de promoções (`/admin/promotions`).
class AdminPromotionsPage extends StatelessWidget {
  const AdminPromotionsPage({super.key});

  @override
  Widget build(BuildContext context) => AdminPlaceholderScaffold(
        title: context.l10n.adminPromotions,
        icon: Icons.local_offer_outlined,
      );
}
