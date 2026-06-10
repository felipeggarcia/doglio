library;

import 'package:flutter/material.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../widgets/admin_placeholder_scaffold.dart';

/// Seção de gestão de categorias (`/admin/categories`).
class AdminCategoriesPage extends StatelessWidget {
  const AdminCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) => AdminPlaceholderScaffold(
        title: context.l10n.adminCategories,
        icon: Icons.category_outlined,
      );
}
