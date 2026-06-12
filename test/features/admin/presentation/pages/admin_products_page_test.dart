import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:doglio/features/admin/domain/entities/admin_product.dart';
import 'package:doglio/features/admin/domain/entities/page_meta.dart';
import 'package:doglio/features/admin/presentation/pages/admin_products_page.dart';
import 'package:doglio/features/admin/presentation/providers/admin_products_provider.dart';
import 'package:doglio/generated/l10n/app_localizations.dart';

class _FakeNotifier extends AdminProductsNotifier {
  _FakeNotifier(this._initial);
  final AdminProductsState _initial;
  bool loadMoreCalled = false;

  @override
  AdminProductsState build() => _initial;

  @override
  void setSearch(String v) =>
      state = state.copyWith(filters: state.filters.copyWith(search: v));
  @override
  void setActiveFilter(bool? a) =>
      state = state.copyWith(filters: state.filters.copyWith(isActive: a));
  @override
  void toggleHighlightedFilter() => state = state.copyWith(
        filters: state.filters.copyWith(
            isHighlighted: state.filters.isHighlighted == true ? null : true),
      );
  @override
  void toggleOutOfStockFilter() => state = state.copyWith(
        filters: state.filters
            .copyWith(outOfStock: state.filters.outOfStock == true ? null : true),
      );
  @override
  Future<void> refresh() async {}
  @override
  Future<void> loadMore() async => loadMoreCalled = true;
}

AdminProduct _product(
  String id,
  String name, {
  int stock = 5,
  bool active = true,
  bool highlighted = false,
}) =>
    AdminProduct(
      id: id,
      name: name,
      description: 'desc',
      price: '89.90',
      isHighlighted: highlighted,
      isActive: active,
      inStock: stock > 0,
      stockQuantity: stock,
    );

Widget _app(AdminProductsState state, {_FakeNotifier? notifier}) {
  final router = GoRouter(
    initialLocation: '/admin/products',
    routes: [
      GoRoute(
        path: '/admin/products',
        name: 'admin-products',
        builder: (_, _) => const AdminProductsPage(),
      ),
      GoRoute(
        path: '/admin/products/new',
        name: 'admin-product-create',
        builder: (_, _) => const Scaffold(body: Text('CREATE_STUB')),
      ),
      GoRoute(
        path: '/admin/products/:id/edit',
        name: 'admin-product-edit',
        builder: (_, _) => const Scaffold(body: Text('EDIT_STUB')),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      adminProductsProvider.overrideWith(() => notifier ?? _FakeNotifier(state)),
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

void main() {
  group('AdminProductsPage', () {
    testWidgets('renderiza tiles com nome, preço e estoque', (tester) async {
      await tester.pumpWidget(_app(
        AdminProductsState(
          products: [_product('1', 'Ração'), _product('2', 'Coleira', stock: 0)],
        ),
      ));
      await tester.pump();

      expect(find.text('Ração'), findsOneWidget);
      expect(find.text('Coleira'), findsOneWidget);
      expect(find.text('R\$ 89,90'), findsNWidgets(2));
      expect(find.text('5 em estoque'), findsOneWidget);
      expect(find.text('Sem estoque'), findsNWidgets(2)); // badge + chip de filtro
    });

    testWidgets('lista vazia mostra mensagem', (tester) async {
      await tester.pumpWidget(_app(const AdminProductsState()));
      await tester.pump();

      expect(find.text('Nenhum produto encontrado'), findsOneWidget);
    });

    testWidgets('tocar num produto navega para edição', (tester) async {
      await tester.pumpWidget(_app(
        AdminProductsState(products: [_product('1', 'Ração')]),
      ));
      await tester.pump();

      await tester.tap(find.text('Ração'));
      await tester.pumpAndSettle();

      expect(find.text('EDIT_STUB'), findsOneWidget);
    });

    testWidgets('FAB navega para criação', (tester) async {
      await tester.pumpWidget(_app(
        AdminProductsState(products: [_product('1', 'Ração')]),
      ));
      await tester.pump();

      await tester.tap(find.text('Novo produto'));
      await tester.pumpAndSettle();

      expect(find.text('CREATE_STUB'), findsOneWidget);
    });

    testWidgets('selecionar filtro "Ativo" marca o chip', (tester) async {
      await tester.pumpWidget(_app(
        AdminProductsState(products: [_product('1', 'Ração')]),
      ));
      await tester.pump();

      await tester.tap(find.widgetWithText(ChoiceChip, 'Ativo'));
      await tester.pump();

      final chip =
          tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Ativo'));
      expect(chip.selected, isTrue);
    });

    testWidgets('chip "Destaque" alterna o filtro', (tester) async {
      await tester.pumpWidget(_app(
        AdminProductsState(products: [_product('1', 'Ração')]),
      ));
      await tester.pump();

      await tester.tap(find.widgetWithText(ChoiceChip, 'Destaque'));
      await tester.pump();

      final chip = tester
          .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Destaque'));
      expect(chip.selected, isTrue);
    });

    testWidgets('produto em destaque exibe ícone de estrela', (tester) async {
      await tester.pumpWidget(_app(
        AdminProductsState(products: [_product('1', 'X', highlighted: true)]),
      ));
      await tester.pump();

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('hasMore exibe botão "Carregar mais" que chama loadMore',
        (tester) async {
      final notifier = _FakeNotifier(AdminProductsState(
        products: [_product('1', 'Ração')],
        meta: const PageMeta(currentPage: 1, lastPage: 2, total: 30),
      ));
      await tester.pumpWidget(_app(const AdminProductsState(), notifier: notifier));
      await tester.pump();

      expect(find.text('Carregar mais'), findsOneWidget);
      await tester.tap(find.text('Carregar mais'));
      await tester.pump();

      expect(notifier.loadMoreCalled, isTrue);
    });

    testWidgets('erro sem dados mostra mensagem e botão de retry',
        (tester) async {
      await tester.pumpWidget(_app(
        const AdminProductsState(errorMessage: 'Falhou geral'),
      ));
      await tester.pump();

      expect(find.text('Falhou geral'), findsOneWidget);
      expect(find.text('Tentar Novamente'), findsOneWidget);
    });
  });
}
