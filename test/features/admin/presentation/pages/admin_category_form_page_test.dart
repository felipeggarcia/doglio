import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:doglio/core/errors/failures.dart';
import 'package:doglio/features/admin/domain/entities/admin_category.dart';
import 'package:doglio/features/admin/presentation/pages/admin_category_form_page.dart';
import 'package:doglio/features/admin/presentation/providers/admin_categories_provider.dart';
import 'package:doglio/generated/l10n/app_localizations.dart';

class _FakeNotifier extends AdminCategoriesNotifier {
  AdminCategory? created;
  AdminCategory? updated;

  @override
  AdminCategoriesState build() => const AdminCategoriesState();

  @override
  Future<Either<Failure, AdminCategory>> createCategory(
      AdminCategory category) async {
    created = category;
    return Right(category);
  }

  @override
  Future<Either<Failure, AdminCategory>> updateCategory(
      AdminCategory category) async {
    updated = category;
    return Right(category);
  }
}

const _existingCategory = AdminCategory(
  id: '5',
  name: 'Eletrônicos',
  slug: 'eletronicos',
  isHighlighted: true,
  isActive: false,
  productsCount: 8,
);

Widget _wrap(_FakeNotifier notifier, {AdminCategory? category}) =>
    ProviderScope(
      overrides: [adminCategoriesProvider.overrideWith(() => notifier)],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('pt'),
        home: AdminCategoryFormPage(category: category),
      ),
    );

void main() {
  group('AdminCategoryFormPage', () {
    testWidgets('modo criação exibe título e sem ícone de excluir',
        (tester) async {
      await tester.pumpWidget(_wrap(_FakeNotifier()));
      await tester.pump();

      expect(find.text('Nova categoria'), findsWidgets);
      expect(find.byIcon(Icons.delete_outline), findsNothing);
    });

    testWidgets('modo edição: título, prefill e ícone de excluir',
        (tester) async {
      await tester.pumpWidget(_wrap(_FakeNotifier(), category: _existingCategory));
      await tester.pump();

      expect(find.text('Editar categoria'), findsOneWidget);
      expect(find.text('Eletrônicos'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('salvar na criação chama createCategory com os dados',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final notifier = _FakeNotifier();

      // Router com home → push para o form, para que context.pop() funcione.
      final router = GoRouter(
        initialLocation: '/home',
        routes: [
          GoRoute(
            path: '/home',
            builder: (_, _) => Scaffold(
              body: Builder(
                builder: (c) => ElevatedButton(
                  onPressed: () => c.push('/form'),
                  child: const Text('GO'),
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/form',
            builder: (_, _) => const AdminCategoryFormPage(),
          ),
        ],
      );

      await tester.pumpWidget(ProviderScope(
        overrides: [adminCategoriesProvider.overrideWith(() => notifier)],
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
      ));

      await tester.tap(find.text('GO'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'Nova Cat');
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();

      expect(notifier.created, isNotNull);
      expect(notifier.created!.name, 'Nova Cat');
      // Após pop voltou para a home
      expect(find.text('GO'), findsOneWidget);
    });
  });
}
