/// Main application widget for Doglio Marketplace
///
/// This file contains the root widget that configures the app's theme,
/// routing, and global settings for the pet products marketplace.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/environment.dart';
import 'core/theme/app_theme.dart';
import 'core/config/router.dart';
import 'core/utils/app_logger.dart';
import 'generated/l10n/app_localizations.dart';

/// The root widget for the Doglio Marketplace application
class DoglioApp extends ConsumerWidget {
  const DoglioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      // App configuration
      title: 'Doglio - Pet Products Marketplace',
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      // Navigation configuration (go_router)
      routerConfig: ref.watch(routerProvider),

      // Localization configuration
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'), // Português Brasil (padrão)
        Locale('pt'), // Fallback técnico (mesmo conteúdo do pt_BR)
        Locale('en'), // Inglês
      ],

      // Builder for additional configuration
      builder: (context, child) {
        // Add any global providers or wrappers here
        return _GlobalProviders(child: child ?? const SizedBox.shrink());
      },
    );
  }
}

/// Global providers wrapper for dependency injection
class _GlobalProviders extends StatelessWidget {
  const _GlobalProviders({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // This is where we would wrap with Riverpod providers
    // For now, just return the child
    return child;
  }
}

/// Application startup and initialization
class DoglioAppInitializer {
  /// Initialize app dependencies and configuration
  static Future<void> initialize() async {
    // Ensure Flutter is initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize dependency injection
    await _initializeDependencies();

    // Initialize other services
    await _initializeServices();
  }

  static Future<void> _initializeDependencies() async {
    EnvironmentConfig.setEnvironment(
      kDebugMode ? Environment.development : Environment.production,
    );
  }

  static Future<void> _initializeServices() async {
    AppLogger.init();
    AppLogger.i('Doglio starting — env: ${EnvironmentConfig.currentEnvironment.name}');
  }
}
