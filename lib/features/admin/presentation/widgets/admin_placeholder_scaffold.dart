library;

import 'package:flutter/material.dart';
import '../../../../core/utils/l10n_helper.dart';

/// Scaffold reutilizável para seções admin ainda não implementadas.
///
/// Cada seção (usuários, produtos, pedidos, categorias, promoções) começa
/// como um placeholder e será substituída pela tela real conforme o CRUD
/// for integrado com os endpoints `/admin/*` do backend.
class AdminPlaceholderScaffold extends StatelessWidget {
  const AdminPlaceholderScaffold({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 72, color: theme.colorScheme.primary),
              const SizedBox(height: 24),
              Text(
                context.l10n.adminUnderConstruction,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.adminUnderConstructionDesc,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
