import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:doglio/core/config/router.dart';
import 'package:doglio/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:doglio/features/auth/domain/entities/user.dart';
import 'package:doglio/features/auth/presentation/providers/auth_notifier.dart';
import 'package:doglio/features/cart/presentation/providers/cart_provider.dart';
import 'package:doglio/features/store/presentation/pages/store_home_page.dart';
import 'package:doglio/features/store/presentation/providers/store_notifier.dart';
import 'package:doglio/generated/l10n/app_localizations.dart';

// Auth falso: devolve um estado fixo sem tocar na rede/secure storage.
class _FakeAuthNotifier extends AuthNotifier {
  _FakeAuthNotifier(this._state);
  final AuthState _state;

  @override
  Future<AuthState> build() async => _state;

  @override
  Future<void> signOut() async => state = const AsyncData(Unauthenticated());
}

// Store/Cart falsos: evitam chamadas HTTP no build da StoreHomePage (destino do
// redirect quando o usuário não é admin).
class _FakeStoreNotifier extends StoreNotifier {
  @override
  StoreState build() => const StoreState();
}

class _FakeCartNotifier extends CartNotifier {
  @override
  CartState build() => const CartState();
}

User _user(UserRole role) => User(
      id: '1',
      email: 'u@e.com',
      name: 'Fulano',
      role: role,
    );

ProviderContainer _container(AuthState auth) => ProviderContainer(
      overrides: [
        authProvider.overrideWith(() => _FakeAuthNotifier(auth)),
        storeProvider.overrideWith(_FakeStoreNotifier.new),
        cartProvider.overrideWith(_FakeCartNotifier.new),
      ],
    );

Widget _app(ProviderContainer container, GoRouter router) {
  return UncontrolledProviderScope(
    container: container,
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

void main() {
  group('routerProvider guard de role admin', () {
    testWidgets('admin acessa /admin e vê o dashboard', (tester) async {
      final container = _container(Authenticated(_user(UserRole.admin)));
      addTearDown(container.dispose);
      final router = container.read(routerProvider);

      await tester.pumpWidget(_app(container, router));
      await tester.pumpAndSettle();

      router.go('/admin');
      await tester.pumpAndSettle();

      expect(find.byType(AdminDashboardPage), findsOneWidget);
    });

    testWidgets('admin em / é redirecionado automaticamente para /admin (hot restart)',
        (tester) async {
      final container = _container(Authenticated(_user(UserRole.admin)));
      addTearDown(container.dispose);
      final router = container.read(routerProvider);

      // Simula hot restart: admin já autenticado, app inicia na rota raiz
      await tester.pumpWidget(_app(container, router));
      await tester.pumpAndSettle();

      expect(find.byType(AdminDashboardPage), findsOneWidget);
      expect(find.byType(StoreHomePage), findsNothing);
    });

    testWidgets('customer é redirecionado de /admin para a loja',
        (tester) async {
      final container = _container(Authenticated(_user(UserRole.user)));
      addTearDown(container.dispose);
      final router = container.read(routerProvider);

      await tester.pumpWidget(_app(container, router));
      await tester.pumpAndSettle();

      router.go('/admin');
      await tester.pumpAndSettle();

      expect(find.byType(AdminDashboardPage), findsNothing);
      expect(find.byType(StoreHomePage), findsOneWidget);
    });

    testWidgets('não autenticado é redirecionado de /admin para a loja',
        (tester) async {
      final container = _container(const Unauthenticated());
      addTearDown(container.dispose);
      final router = container.read(routerProvider);

      await tester.pumpWidget(_app(container, router));
      await tester.pumpAndSettle();

      router.go('/admin/products');
      await tester.pumpAndSettle();

      expect(find.byType(AdminDashboardPage), findsNothing);
      expect(find.byType(StoreHomePage), findsOneWidget);
    });
  });
}
