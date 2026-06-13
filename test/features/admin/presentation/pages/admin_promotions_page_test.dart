import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:doglio/features/admin/domain/entities/admin_promotion.dart';
import 'package:doglio/features/admin/presentation/pages/admin_promotions_page.dart';
import 'package:doglio/features/admin/presentation/providers/admin_promotions_provider.dart';
import 'package:doglio/generated/l10n/app_localizations.dart';

// ─── Fake notifier ────────────────────────────────────────────────────────────

class _FakeNotifier extends AdminPromotionsNotifier {
  _FakeNotifier(this._initial);
  final AdminPromotionsState _initial;

  @override
  AdminPromotionsState build() => _initial;

  @override
  void setSearch(String v) {}
  @override
  void setActiveFilter(bool? v) {}
  @override
  void setExpiredFilter(bool? v) {}
  @override
  Future<void> refresh() async {}
  @override
  Future<void> loadMore() async {}
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

AdminPromotion _promo({
  String id = '1',
  String name = 'Promo Teste',
  bool isCurrentlyActive = true,
}) =>
    AdminPromotion(
      id: id,
      name: name,
      discountValue: '10.00',
      type: DiscountType.percentage,
      startsAt: DateTime(2025),
      isActive: true,
      isCurrentlyActive: isCurrentlyActive,
      minQuantity: 1,
      products: const [],
    );

Widget _app(AdminPromotionsState state) {
  final router = GoRouter(
    initialLocation: '/admin/promotions',
    routes: [
      GoRoute(
        path: '/admin/promotions',
        name: 'admin-promotions',
        builder: (_, _) => const AdminPromotionsPage(),
      ),
      GoRoute(
        path: '/admin/promotions/new',
        name: 'admin-promotion-form',
        builder: (_, _) => const Scaffold(body: Text('FORM_STUB')),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      adminPromotionsProvider.overrideWith(() => _FakeNotifier(state)),
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

// ─── Testes ───────────────────────────────────────────────────────────────────

void main() {
  group('AdminPromotionsPage', () {
    testWidgets('exibe spinner durante carregamento', (tester) async {
      await tester.pumpWidget(_app(
        const AdminPromotionsState(isLoading: true),
      ));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('exibe mensagem de vazio quando lista está vazia', (tester) async {
      await tester.pumpWidget(_app(const AdminPromotionsState()));
      await tester.pump();
      expect(find.text('Nenhuma promoção encontrada'), findsOneWidget);
    });

    testWidgets('exibe tiles de promoção na lista', (tester) async {
      await tester.pumpWidget(_app(
        AdminPromotionsState(
          promotions: [
            _promo(id: '1', name: 'Black Friday'),
            _promo(id: '2', name: 'Natal'),
          ],
        ),
      ));
      await tester.pump();
      expect(find.text('Black Friday'), findsOneWidget);
      expect(find.text('Natal'), findsOneWidget);
    });

    testWidgets('exibe campo de busca', (tester) async {
      await tester.pumpWidget(_app(const AdminPromotionsState()));
      await tester.pump();
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('exibe chips de filtro Ativas e Expiradas', (tester) async {
      await tester.pumpWidget(_app(const AdminPromotionsState()));
      await tester.pump();
      expect(find.text('Ativas'), findsOneWidget);
      expect(find.text('Expiradas'), findsOneWidget);
    });

    testWidgets('exibe FAB Nova promoção', (tester) async {
      await tester.pumpWidget(_app(const AdminPromotionsState()));
      await tester.pump();
      expect(find.text('Nova promoção'), findsOneWidget);
    });

    testWidgets('exibe mensagem de erro quando errorMessage está preenchido e lista vazia',
        (tester) async {
      await tester.pumpWidget(_app(
        const AdminPromotionsState(errorMessage: 'Falha de rede'),
      ));
      await tester.pump();
      expect(find.text('Falha de rede'), findsOneWidget);
    });
  });
}
