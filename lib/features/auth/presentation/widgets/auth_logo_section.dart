/// Reusable logo section widget for authentication pages
///
/// This widget provides a consistent logo display across all auth pages
/// with proper styling and shadow effects.
library;

import 'package:flutter/material.dart';
import '../../../../core/utils/app_assets.dart';

class AuthLogoSection extends StatelessWidget {
  const AuthLogoSection({super.key, this.size = 60, this.showAppName = false});

  final double size;
  final bool showAppName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Logo Container
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: AppLogo(size: size),
        ),

        // App Name (optional)
        if (showAppName) ...[
          const SizedBox(height: 12),
          Text(
            'Doglio',
            style: theme.textTheme.headlineLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}
