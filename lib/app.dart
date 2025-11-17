/// Main application widget for Doglio Marketplace
///
/// This file contains the root widget that configures the app's theme,
/// routing, and global settings for the pet products marketplace.
library;

import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/config/router.dart';

/// The root widget for the Doglio Marketplace application
class DoglioApp extends StatelessWidget {
  const DoglioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App configuration
      title: 'Doglio - Pet Products Marketplace',
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Navigation configuration
      initialRoute: AppRoutes.storeHome,
      onGenerateRoute: AppRouter.router.onGenerateRoute,

      // Localization configuration (placeholder)
      // locale: const Locale('en'),
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      // supportedLocales: AppLocalizations.supportedLocales,

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

  /// Initialize dependency injection
  static Future<void> _initializeDependencies() async {
    // Initialize GetIt service locator
    // This will be implemented when we add more features
  }

  /// Initialize other application services
  static Future<void> _initializeServices() async {
    // Initialize shared preferences, local storage, etc.
    // These will be added as needed
  }
}
