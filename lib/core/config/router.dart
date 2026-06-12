/// Application routes configuration for Doglio Marketplace
///
/// Uses go_router for declarative, type-safe navigation.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_notifier.dart';
import '../../features/admin/domain/entities/admin_user.dart';
import '../../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../../features/admin/presentation/pages/admin_users_page.dart';
import '../../features/admin/presentation/pages/admin_user_form_page.dart';
import '../../features/admin/domain/entities/admin_product.dart';
import '../../features/admin/presentation/pages/admin_products_page.dart';
import '../../features/admin/presentation/pages/admin_product_form_page.dart';
import '../../features/admin/presentation/pages/admin_product_stock_page.dart';
import '../../features/admin/presentation/pages/admin_orders_page.dart';
import '../../features/admin/domain/entities/admin_order.dart';
import '../../features/admin/presentation/pages/admin_order_detail_page.dart';
import '../../features/admin/domain/entities/admin_category.dart';
import '../../features/admin/presentation/pages/admin_categories_page.dart';
import '../../features/admin/presentation/pages/admin_category_form_page.dart';
import '../../features/admin/presentation/pages/admin_promotions_page.dart';
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
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/checkout/presentation/pages/checkout_page.dart';
import '../../features/checkout/presentation/pages/pix_page.dart';
import '../../features/checkout/domain/entities/checkout_result.dart';

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
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String pix = '/pix';

  // Área administrativa (exige role admin)
  static const String adminDashboard = '/admin';
  static const String adminUsers = '/admin/users';
  static const String adminUserCreate = '/admin/users/new';
  static const String adminUserEdit = '/admin/users/:id/edit';
  static const String adminProducts = '/admin/products';
  static const String adminProductCreate = '/admin/products/new';
  static const String adminProductEdit = '/admin/products/:id/edit';
  static const String adminProductStock = '/admin/products/:id/stock';
  static const String adminOrders = '/admin/orders';
  static const String adminOrderDetail = '/admin/orders/:id';
  static const String adminCategories = '/admin/categories';
  static const String adminCategoryCreate = '/admin/categories/new';
  static const String adminCategoryEdit = '/admin/categories/:id/edit';
  static const String adminPromotions = '/admin/promotions';
}

/// Application GoRouter provider.
///
/// O router observa [authProvider] e aplica um guard de role: rotas sob
/// `/admin` só são acessíveis por usuários autenticados com `role: admin`.
/// Qualquer outro acesso é redirecionado para a home da loja.
final routerProvider = Provider<GoRouter>((ref) {
  // Bridge entre o estado de auth (Riverpod) e o refreshListenable do go_router.
  final authRefresh = ValueNotifier<int>(0);
  ref.listen(authProvider, (_, _) => authRefresh.value++);
  ref.onDispose(authRefresh.dispose);

  return GoRouter(
    debugLogDiagnostics: false,
    initialLocation: AppRoutes.storeHome,
    refreshListenable: authRefresh,
    redirect: (context, state) {
      final auth = ref.read(authProvider).valueOrNull;
      final isAdmin = auth is Authenticated && auth.user.isAdmin;
      final goingToAdmin =
          state.matchedLocation.startsWith(AppRoutes.adminDashboard);

      // Admin sempre vai para a área admin (inclusive após hot restart)
      if (isAdmin && !goingToAdmin) return AppRoutes.adminDashboard;

      // Não-admin tentando acessar área admin → home da loja
      if (goingToAdmin && !isAdmin) return AppRoutes.storeHome;

      return null;
    },
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
        final product = state.extra as Product?;
        if (product != null) return ProductDetailPage(product: product);
        return ProductDetailPageLoader(
          productId: state.pathParameters['id']!,
        );
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
    GoRoute(
      path: AppRoutes.cart,
      name: 'cart',
      builder: (context, state) => const CartPage(),
    ),
    GoRoute(
      path: AppRoutes.checkout,
      name: 'checkout',
      builder: (context, state) => const CheckoutPage(),
    ),
    GoRoute(
      path: AppRoutes.pix,
      name: 'pix',
      builder: (context, state) {
        final result = state.extra as CheckoutResult;
        return PixPage(result: result);
      },
    ),
    // ─── Área administrativa (guard de role aplicado no redirect) ───
    GoRoute(
      path: AppRoutes.adminDashboard,
      name: 'admin-dashboard',
      builder: (context, state) => const AdminDashboardPage(),
    ),
    GoRoute(
      path: AppRoutes.adminUsers,
      name: 'admin-users',
      builder: (context, state) => const AdminUsersPage(),
    ),
    GoRoute(
      path: AppRoutes.adminUserCreate,
      name: 'admin-user-create',
      builder: (context, state) => const AdminUserFormPage(),
    ),
    GoRoute(
      path: AppRoutes.adminUserEdit,
      name: 'admin-user-edit',
      builder: (context, state) =>
          AdminUserFormPage(user: state.extra as AdminUser?),
    ),
    GoRoute(
      path: AppRoutes.adminProducts,
      name: 'admin-products',
      builder: (context, state) => const AdminProductsPage(),
    ),
    // `/new` antes de `/:id/...` para o path literal ter precedência.
    GoRoute(
      path: AppRoutes.adminProductCreate,
      name: 'admin-product-create',
      builder: (context, state) => const AdminProductFormPage(),
    ),
    GoRoute(
      path: AppRoutes.adminProductEdit,
      name: 'admin-product-edit',
      builder: (context, state) =>
          AdminProductFormPage(product: state.extra as AdminProduct?),
    ),
    GoRoute(
      path: AppRoutes.adminProductStock,
      name: 'admin-product-stock',
      builder: (context, state) => AdminProductStockPage(
        productId: state.pathParameters['id']!,
        product: state.extra as AdminProduct?,
      ),
    ),
    GoRoute(
      path: AppRoutes.adminOrders,
      name: 'admin-orders',
      builder: (context, state) => const AdminOrdersPage(),
    ),
    GoRoute(
      path: AppRoutes.adminOrderDetail,
      name: 'admin-order-detail',
      builder: (context, state) => AdminOrderDetailPage(
        orderId: state.pathParameters['id']!,
        order: state.extra as AdminOrder?,
      ),
    ),
    GoRoute(
      path: AppRoutes.adminCategories,
      name: 'admin-categories',
      builder: (context, state) => const AdminCategoriesPage(),
    ),
    GoRoute(
      path: AppRoutes.adminCategoryCreate,
      name: 'admin-category-create',
      builder: (context, state) => const AdminCategoryFormPage(),
    ),
    GoRoute(
      path: AppRoutes.adminCategoryEdit,
      name: 'admin-category-edit',
      builder: (context, state) =>
          AdminCategoryFormPage(category: state.extra as AdminCategory?),
    ),
    GoRoute(
      path: AppRoutes.adminPromotions,
      name: 'admin-promotions',
      builder: (context, state) => const AdminPromotionsPage(),
    ),
    ],
  );
});

/// Navigation extensions para manter compatibilidade com código existente
extension AppNavigationContext on BuildContext {
  void goToStoreHome() => go(AppRoutes.storeHome);
  void goToLogin() => go(AppRoutes.login);
  void goToRegister() => go(AppRoutes.register);
  void goToUserHome() => go(AppRoutes.userHome);
  void goToAdminDashboard() => go(AppRoutes.adminDashboard);

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

  void pushCart() => push(AppRoutes.cart);
  void pushCheckout() => push(AppRoutes.checkout);
  void pushPix(CheckoutResult result) =>
      push(AppRoutes.pix, extra: result);
}
