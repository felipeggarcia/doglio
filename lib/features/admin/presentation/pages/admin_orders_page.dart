library;

import 'package:flutter/material.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../widgets/admin_placeholder_scaffold.dart';

/// Seção de gestão de pedidos e troca de status (`/admin/orders`).
class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) => AdminPlaceholderScaffold(
        title: context.l10n.adminOrders,
        icon: Icons.receipt_long_outlined,
      );
}
