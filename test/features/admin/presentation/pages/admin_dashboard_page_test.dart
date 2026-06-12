import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:doglio/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:doglio/features/admin/presentation/pages/admin_categories_page.dart';
import 'package:doglio/features/admin/presentation/pages/admin_orders_page.dart';
import 'package:doglio/features/admin/presentation/pages/admin_products_page.dart';
import 'package:doglio/features/admin/presentation/pages/admin_promotions_page.dart';
import 'package:doglio/features/admin/presentation/pages/admin_users_page.dart';
import 'package:doglio/features/admin/presentation/providers/admin_products_provider.dart';
import 'package:doglio/features/auth/domain/entities/user.dart';
import 'package:doglio/features/auth/presentation/providers/auth_notifier.dart';
import 'package:doglio/generated/l10n/app_localizations.dart';

class _FakeAuthNotifier extends AuthNotifier {
  _FakeAuthNotifier(this._state);
  final AuthState _state;

  @override
  Future<AuthState> build() async => _state;

  @override
  Future<void> signOut() async => state = const AsyncData(Unauthenticated());
}

/// Evita que a AdminProductsPage real dispare HTTP ao navegar até ela.
class _FakeProductsNotifier extends AdminProductsNotifier {
  @override
  AdminProductsState build() => const AdminProductsState();
}

class _LoginStub extends StatelessWidget {
  const _LoginStub();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Text('LOGIN_STUB'));
}

Widget _app(AuthState auth) {
  final router = GoRouter(
    initialLocation: '/admin',
    routes: [
      GoRoute(
        path: '/admin',
        name: 'admin-dashboard',
        builder: (_, _) => const AdminDashboardPage(),
      ),
      GoRoute(
        path: '/admin/products',
        name: 'admin-products',
        builder: (_, _) => const AdminProductsPage(),
      ),
      GoRoute(
        path: '/admin/orders',
        name: 'admin-orders',
        builder: (_, _) => const AdminOrdersPage(),
      ),
      GoRoute(
        path: '/admin/categories',
        name: 'admin-categories',
        builder: (_, _) => const AdminCategoriesPage(),
      ),
      GoRoute(
        path: '/admin/promotions',
        name: 'admin-promotions',
        builder: (_, _) => const AdminPromotionsPage(),
      ),
      GoRoute(
        path: '/admin/users',
        name: 'admin-users',
        builder: (_, _) => const AdminUsersPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (_, _) => const _LoginStub(),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      authProvider.overrideWith(() => _FakeAuthNotifier(auth)),
      adminProductsProvider.overrideWith(_FakeProductsNotifier.new),
    ],
    child: MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('pt'),
    ),
  );
}

AuthState _admin() => Authenticated(
      User(
        id: '1',
        email: 'admin@doglio.com',
        name: 'Maria Admin',
        role: UserRole.admin,
      ),
    );

void main() {
  group('AdminDashboardPage', () {
    testWidgets('exibe as 5 seções de gestão', (tester) async {
      await tester.pumpWidget(_app(_admin()));
      await tester.pumpAndSettle();

      expect(find.text('Produtos'), findsOneWidget);
      expect(find.text('Pedidos'), findsOneWidget);
      expect(find.text('Categorias'), findsOneWidget);
      expect(find.text('Promoções'), findsOneWidget);
      expect(find.text('Usuários'), findsOneWidget);
    });

    testWidgets('exibe saudação com o nome do admin', (tester) async {
      await tester.pumpWidget(_app(_admin()));
      await tester.pumpAndSettle();

      expect(find.textContaining('Maria Admin'), findsOneWidget);
    });

    testWidgets('tocar em um card navega para a seção', (tester) async {
      await tester.pumpWidget(_app(_admin()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Produtos'));
      await tester.pumpAndSettle();

      expect(find.byType(AdminProductsPage), findsOneWidget);
    });

    testWidgets('logout abre diálogo de confirmação', (tester) async {
      await tester.pumpWidget(_app(_admin()));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      expect(find.text('Tem certeza que deseja sair?'), findsOneWidget);
    });

    testWidgets('confirmar logout navega para o login', (tester) async {
      await tester.pumpWidget(_app(_admin()));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      // Botão "Sair" do diálogo (o último com esse texto).
      await tester.tap(find.text('Sair').last);
      await tester.pumpAndSettle();

      expect(find.text('LOGIN_STUB'), findsOneWidget);
    });
  });
}
