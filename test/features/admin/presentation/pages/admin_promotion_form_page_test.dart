import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:doglio/features/admin/domain/entities/admin_category.dart';
import 'package:doglio/features/admin/domain/entities/admin_product.dart';
import 'package:doglio/features/admin/domain/entities/admin_promotion.dart';
import 'package:doglio/features/admin/presentation/pages/admin_promotion_form_page.dart';
import 'package:doglio/features/admin/presentation/providers/admin_promotions_provider.dart';
import 'package:doglio/generated/l10n/app_localizations.dart';

// ─── Fake notifier ────────────────────────────────────────────────────────────

class _FakeNotifier extends AdminPromotionsNotifier {
  @override
  AdminPromotionsState build() => const AdminPromotionsState();

  @override
  Future<void> refresh() async {}
}

// ─── Fixtures ─────────────────────────────────────────────────────────────────

AdminPromotion _promo() => AdminPromotion(
      id: 'p1',
      name: 'Black Friday',
      description: 'Desconto especial',
      discountValue: '15.00',
      type: DiscountType.percentage,
      startsAt: DateTime(2025, 11, 28),
      endsAt: DateTime(2025, 11, 30),
      isActive: true,
      isCurrentlyActive: true,
      minQuantity: 2,
      products: [
        AdminPromotionProduct(
          id: 'prod1',
          name: 'Camiseta',
          useLimit: 10,
          usesCount: 3,
        ),
      ],
    );

AdminProduct _product() => AdminProduct(
      id: 'prod1',
      name: 'Camiseta',
      description: 'Desc',
      price: '49.90',
      isHighlighted: false,
      isActive: true,
      inStock: true,
      stockQuantity: 10,
      images: const [],
      categories: const [
        AdminCategory(
          id: 'c1',
          name: 'Roupas',
          slug: 'roupas',
          isHighlighted: false,
          isActive: true,
          productsCount: 5,
        ),
      ],
    );

Widget _app(Widget page) {
  final router = GoRouter(
    initialLocation: '/admin/promotions/new',
    routes: [
      GoRoute(
        path: '/admin/promotions/new',
        name: 'admin-promotion-form',
        builder: (_, _) => page,
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      adminPromotionsProvider.overrideWith(_FakeNotifier.new),
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

// O formulário tem muitos campos que podem ultrapassar o viewport padrão (600px).
// Usamos uma tela grande para garantir que todos os itens da ListView sejam renderizados.
void _setLargeScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 3000);
  tester.view.devicePixelRatio = 1.0;
}

// ─── Testes ───────────────────────────────────────────────────────────────────

void main() {
  group('AdminPromotionFormPage — criação', () {
    testWidgets('exibe título "Nova promoção"', (tester) async {
      await tester.pumpWidget(_app(const AdminPromotionFormPage()));
      await tester.pump();
      expect(find.text('Nova promoção'), findsOneWidget);
    });

    testWidgets('exibe campos obrigatórios', (tester) async {
      _setLargeScreen(tester);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(_app(const AdminPromotionFormPage()));
      await tester.pump();
      expect(find.text('Nome'), findsOneWidget);
      expect(find.text('Tipo de desconto'), findsOneWidget);
      expect(find.text('Valor do desconto'), findsOneWidget);
      expect(find.text('Início'), findsOneWidget);
    });

    testWidgets('não exibe botão Excluir em criação', (tester) async {
      await tester.pumpWidget(_app(const AdminPromotionFormPage()));
      await tester.pump();
      expect(find.byIcon(Icons.delete_outline), findsNothing);
    });

    testWidgets('exibe seção de produtos vinculados (vazia) em criação pura', (tester) async {
      _setLargeScreen(tester);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(_app(const AdminPromotionFormPage()));
      await tester.pump();
      expect(find.text('Produtos vinculados'), findsOneWidget);
    });
  });

  group('AdminPromotionFormPage — edição', () {
    testWidgets('exibe título "Editar promoção"', (tester) async {
      await tester.pumpWidget(_app(AdminPromotionFormPage(promotion: _promo())));
      await tester.pump();
      expect(find.text('Editar promoção'), findsOneWidget);
    });

    testWidgets('exibe botão Excluir em edição', (tester) async {
      await tester.pumpWidget(_app(AdminPromotionFormPage(promotion: _promo())));
      await tester.pump();
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('exibe seção de produtos vinculados em edição', (tester) async {
      _setLargeScreen(tester);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(_app(AdminPromotionFormPage(promotion: _promo())));
      await tester.pump();
      expect(find.text('Produtos vinculados'), findsOneWidget);
      expect(find.text('Camiseta'), findsOneWidget);
    });

    testWidgets('pré-preenche nome da promoção', (tester) async {
      await tester.pumpWidget(_app(AdminPromotionFormPage(promotion: _promo())));
      await tester.pump();
      final nameField = find.widgetWithText(TextField, 'Black Friday');
      expect(nameField, findsOneWidget);
    });
  });

  group('AdminPromotionFormPage — criação via produto', () {
    testWidgets('exibe chip read-only do produto pré-vinculado', (tester) async {
      _setLargeScreen(tester);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        _app(AdminPromotionFormPage(initialLinkedProduct: _product())),
      );
      await tester.pump();
      expect(find.text('Produtos vinculados'), findsOneWidget);
      expect(find.text('Camiseta'), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('não exibe botão Excluir ao criar via produto', (tester) async {
      await tester.pumpWidget(
        _app(AdminPromotionFormPage(initialLinkedProduct: _product())),
      );
      await tester.pump();
      expect(find.byIcon(Icons.delete_outline), findsNothing);
    });
  });
}
