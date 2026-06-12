import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:doglio/features/admin/domain/entities/admin_category.dart';
import 'package:doglio/features/admin/presentation/pages/admin_categories_page.dart';
import 'package:doglio/features/admin/presentation/providers/admin_categories_provider.dart';
import 'package:doglio/generated/l10n/app_localizations.dart';

class _FakeNotifier extends AdminCategoriesNotifier {
  _FakeNotifier(this._initial);
  final AdminCategoriesState _initial;

  @override
  AdminCategoriesState build() => _initial;

  @override
  void setSearch(String v) => state = state.copyWith(search: v);
  @override
  void setActiveFilter(bool? a) => state = state.copyWith(activeFilter: a);
  @override
  Future<void> refresh() async {}
}

AdminCategory _cat(String id, String name, {bool active = true, bool highlighted = false}) =>
    AdminCategory(
      id: id,
      name: name,
      slug: name.toLowerCase(),
      isHighlighted: highlighted,
      isActive: active,
      productsCount: 3,
    );

Widget _app(AdminCategoriesState state) {
  final router = GoRouter(
    initialLocation: '/admin/categories',
    routes: [
      GoRoute(
        path: '/admin/categories',
        name: 'admin-categories',
        builder: (_, _) => const AdminCategoriesPage(),
      ),
      GoRoute(
        path: '/admin/categories/new',
        name: 'admin-category-create',
        builder: (_, _) => const Scaffold(body: Text('CREATE_STUB')),
      ),
      GoRoute(
        path: '/admin/categories/:id/edit',
        name: 'admin-category-edit',
        builder: (_, _) => const Scaffold(body: Text('EDIT_STUB')),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      adminCategoriesProvider.overrideWith(() => _FakeNotifier(state)),
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
  group('AdminCategoriesPage', () {
    testWidgets('renderiza tiles com nome e contagem de produtos', (tester) async {
      await tester.pumpWidget(_app(
        AdminCategoriesState(categories: [_cat('1', 'Eletrônicos'), _cat('2', 'Roupas')]),
      ));
      await tester.pump();

      expect(find.text('Eletrônicos'), findsOneWidget);
      expect(find.text('Roupas'), findsOneWidget);
      expect(find.text('3 produtos'), findsNWidgets(2));
    });

    testWidgets('lista vazia mostra mensagem', (tester) async {
      await tester.pumpWidget(_app(const AdminCategoriesState()));
      await tester.pump();

      expect(find.text('Nenhuma categoria encontrada'), findsOneWidget);
    });

    testWidgets('tocar numa categoria navega para edição', (tester) async {
      await tester.pumpWidget(_app(
        AdminCategoriesState(categories: [_cat('1', 'Livros')]),
      ));
      await tester.pump();

      await tester.tap(find.text('Livros'));
      await tester.pumpAndSettle();

      expect(find.text('EDIT_STUB'), findsOneWidget);
    });

    testWidgets('FAB navega para criação', (tester) async {
      await tester.pumpWidget(_app(
        AdminCategoriesState(categories: [_cat('1', 'Games')]),
      ));
      await tester.pump();

      await tester.tap(find.text('Nova categoria'));
      await tester.pumpAndSettle();

      expect(find.text('CREATE_STUB'), findsOneWidget);
    });

    testWidgets('selecionar filtro "Ativo" marca o chip', (tester) async {
      await tester.pumpWidget(_app(
        AdminCategoriesState(categories: [_cat('1', 'Games')]),
      ));
      await tester.pump();

      await tester.tap(find.widgetWithText(ChoiceChip, 'Ativo'));
      await tester.pump();

      final chip =
          tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Ativo'));
      expect(chip.selected, isTrue);
    });

    testWidgets('categoria em destaque exibe ícone de estrela', (tester) async {
      await tester.pumpWidget(_app(
        AdminCategoriesState(
          categories: [_cat('1', 'Destaque', highlighted: true)],
        ),
      ));
      await tester.pump();

      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });
}
