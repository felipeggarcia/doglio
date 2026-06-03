/// Application routes configuration for Doglio Marketplace
///
/// Uses go_router for declarative, type-safe navigation.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/user_home_page.dart';
import '../../features/store/presentation/pages/store_home_page.dart';
import '../../features/store/presentation/pages/product_detail_page.dart';
import '../../features/store/domain/entities/product.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/orders/presentation/pages/orders_page.dart';
import '../../features/orders/presentation/pages/order_detail_page.dart';
import '../../features/orders/domain/entities/order.dart';
import '../../features/addresses/presentation/pages/addresses_page.dart';

/// Route paths constants
abstract class AppRoutes {
  static const String storeHome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String userHome = '/user-home';
  static const String productDetail = '/product/:id';
  static const String favorites = '/favorites';
  static const String orders = '/orders';
  static const String orderDetail = '/orders/:id';
  static const String addresses = '/addresses';
}

/// Application GoRouter instance
final appRouter = GoRouter(
  debugLogDiagnostics: false,
  initialLocation: AppRoutes.storeHome,
  routes: [
    GoRoute(
      path: AppRoutes.storeHome,
      name: 'home',
      builder: (context, state) => const StoreHomePage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'forgot-password',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: AppRoutes.userHome,
      name: 'user-home',
      builder: (context, state) => const UserHomePage(),
    ),
    GoRoute(
      path: AppRoutes.productDetail,
      name: 'product-detail',
      builder: (context, state) {
        final product = state.extra as Product;
        return ProductDetailPage(product: product);
      },
    ),
    GoRoute(
      path: AppRoutes.favorites,
      name: 'favorites',
      builder: (context, state) => const FavoritesPage(),
    ),
    GoRoute(
      path: AppRoutes.orders,
      name: 'orders',
      builder: (context, state) => const OrdersPage(),
    ),
    GoRoute(
      path: AppRoutes.orderDetail,
      name: 'order-detail',
      builder: (context, state) {
        final order = state.extra as Order;
        return OrderDetailPage(orderId: order.id);
      },
    ),
    GoRoute(
      path: AppRoutes.addresses,
      name: 'addresses',
      builder: (context, state) => const AddressesPage(),
    ),
  ],
);

/// Navigation extensions para manter compatibilidade com código existente
extension AppNavigationContext on BuildContext {
  void goToStoreHome() => go(AppRoutes.storeHome);
  void goToLogin() => go(AppRoutes.login);
  void goToRegister() => go(AppRoutes.register);
  void goToUserHome() => go(AppRoutes.userHome);

  void pushLogin() => push(AppRoutes.login);
  void pushRegister() => push(AppRoutes.register);
  void pushForgotPassword() => push(AppRoutes.forgotPassword);

  void pushProductDetail(Product product) =>
      push('/product/${product.id}', extra: product);

  void goToFavorites() => go(AppRoutes.favorites);
  void goToOrders() => go(AppRoutes.orders);
  void goToAddresses() => go(AppRoutes.addresses);

  void pushFavorites() => push(AppRoutes.favorites);
  void pushOrders() => push(AppRoutes.orders);
  void pushAddresses() => push(AppRoutes.addresses);

  void pushOrderDetail(Order order) =>
      push('/orders/${order.id}', extra: order);
}
