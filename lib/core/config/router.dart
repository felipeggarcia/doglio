/// Application routes configuration for Doglio Marketplace
///
/// This file defines all routes using simple MaterialPageRoute navigation.
library;

import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/user_home_page.dart';
import '../../features/store/presentation/pages/store_home_page.dart';

/// Route paths constants
abstract class AppRoutes {
  // Store routes
  static const String storeHome = '/';

  // Authentication routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String userHome = '/user-home';

  // Main application routes
  static const String profile = '/profile';
  static const String cart = '/cart';
  static const String search = '/search';
  static const String productDetails = '/product/:id';

  // Admin routes
  static const String adminDashboard = '/admin';
  static const String adminProducts = '/admin/products';
  static const String adminOrders = '/admin/orders';
  static const String adminUsers = '/admin/users';
}

/// Application router configuration
class AppRouter {
  /// Creates the router configuration
  static final router = _createRouter();

  static _createRouter() {
    return AppRouterConfig(
      initialRoute: AppRoutes.storeHome,
      routes: {
        AppRoutes.storeHome: (context) => const StoreHomePage(),
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.register: (context) => const RegisterPage(),
        AppRoutes.forgotPassword: (context) => const ForgotPasswordPage(),
        AppRoutes.userHome: (context) => const UserHomePage(),
        // Additional routes will be added here
      },
    );
  }
}

/// Simple router configuration without external dependencies
class AppRouterConfig {
  const AppRouterConfig({required this.initialRoute, required this.routes});

  final String initialRoute;
  final Map<String, Widget Function(BuildContext)> routes;

  /// Navigates to a specific route
  void go(BuildContext context, String route) {
    Navigator.of(context).pushReplacementNamed(route);
  }

  /// Pushes a route onto the navigation stack
  void push(BuildContext context, String route) {
    Navigator.of(context).pushNamed(route);
  }

  /// Pops the current route
  void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// Creates MaterialPageRoute for the given route
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final builder = routes[settings.name];
    if (builder != null) {
      return MaterialPageRoute(builder: builder, settings: settings);
    }
    return null;
  }
}

/// Route extensions for easy navigation
extension AppNavigationContext on BuildContext {
  /// Navigate to route (replaces current route)
  void goToRoute(String route) {
    AppRouter.router.go(this, route);
  }

  /// Push route to navigation stack
  void pushRoute(String route) {
    AppRouter.router.push(this, route);
  }

  /// Pop current route
  void popRoute() {
    AppRouter.router.pop(this);
  }

  // Convenience navigation methods
  void goToStoreHome() => goToRoute(AppRoutes.storeHome);
  void goToLogin() => goToRoute(AppRoutes.login);
  void goToRegister() => goToRoute(AppRoutes.register);
  void goToUserHome() => goToRoute(AppRoutes.userHome);
  void goToProfile() => goToRoute(AppRoutes.profile);
  void goToCart() => goToRoute(AppRoutes.cart);

  void pushLogin() => pushRoute(AppRoutes.login);
  void pushRegister() => pushRoute(AppRoutes.register);
  void pushForgotPassword() => pushRoute(AppRoutes.forgotPassword);
}
