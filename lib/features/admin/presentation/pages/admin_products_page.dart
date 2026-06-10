library;

import 'package:flutter/material.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../widgets/admin_placeholder_scaffold.dart';

/// Seção de gestão de produtos e estoque (`/admin/products`).
class AdminProductsPage extends StatelessWidget {
  const AdminProductsPage({super.key});

  @override
  Widget build(BuildContext context) => AdminPlaceholderScaffold(
        title: context.l10n.adminProducts,
        icon: Icons.inventory_2_outlined,
      );
}
