import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:doglio/core/errors/failures.dart';
import 'package:doglio/features/admin/domain/entities/admin_category.dart';
import 'package:doglio/features/admin/domain/entities/admin_product.dart';
import 'package:doglio/features/admin/presentation/pages/admin_product_form_page.dart';
import 'package:doglio/features/admin/presentation/providers/admin_categories_provider.dart';
import 'package:doglio/features/admin/presentation/providers/admin_products_provider.dart';
import 'package:doglio/generated/l10n/app_localizations.dart';

class _FakeProductsNotifier extends AdminProductsNotifier {
  AdminProduct? created;
  List<String>? createdImagePaths;
  AdminProduct? updated;
  List<String>? updatedRemoveImageIds;
  List<String>? updatedImageOrder;
  String? deletedId;

  @override
  AdminProductsState build() => const AdminProductsState();

  @override
  Future<Either<Failure, AdminProduct>> createProduct(
    AdminProduct product, {
    required List<String> newImagePaths,
  }) async {
    created = product;
    createdImagePaths = newImagePaths;
    return Right(product);
  }

  @override
  Future<Either<Failure, AdminProduct>> updateProduct(
    AdminProduct product, {
    required List<String> newImagePaths,
    required List<String> removeImageIds,
    List<String> imageOrder = const [],
  }) async {
    updated = product;
    updatedRemoveImageIds = removeImageIds;
    updatedImageOrder = imageOrder;
    return Right(product);
  }

  @override
  Future<Either<Failure, Unit>> deleteProduct(String id) async {
    deletedId = id;
    return const Right(unit);
  }
}

class _FakeCategoriesNotifier extends AdminCategoriesNotifier {
  _FakeCategoriesNotifier(this._categories);
  final List<AdminCategory> _categories;

  @override
  AdminCategoriesState build() =>
      AdminCategoriesState(categories: _categories);
}

AdminCategory _cat(String id, String name) => AdminCategory(
      id: id,
      name: name,
      slug: name.toLowerCase(),
      isHighlighted: false,
      isActive: true,
      productsCount: 0,
    );

const _existingProduct = AdminProduct(
  id: 'p1',
  name: 'Ração Premium',
  description: 'Ração para cães adultos e filhotes',
  price: '89.90',
  isHighlighted: true,
  isActive: false,
  inStock: true,
  stockQuantity: 7,
);

const _imgA = AdminProductImage(
  id: 'img1',
  url: 'http://10.0.2.2/storage/img1.jpg',
  isPrimary: true,
  order: 0,
);
const _imgB = AdminProductImage(
  id: 'img2',
  url: 'http://10.0.2.2/storage/img2.jpg',
  isPrimary: false,
  order: 1,
);

const _productWithImages = AdminProduct(
  id: 'p2',
  name: 'Produto com imagens',
  description: 'Descricao longa o suficiente',
  price: '50.00',
  isHighlighted: false,
  isActive: true,
  inStock: true,
  stockQuantity: 3,
  images: [_imgA, _imgB],
);

Widget _wrap(
  _FakeProductsNotifier notifier, {
  AdminProduct? product,
  List<AdminCategory> categories = const [],
}) =>
    ProviderScope(
      overrides: [
        adminProductsProvider.overrideWith(() => notifier),
        adminCategoriesProvider
            .overrideWith(() => _FakeCategoriesNotifier(categories)),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('pt'),
        home: AdminProductFormPage(product: product),
      ),
    );

void main() {
  group('AdminProductFormPage', () {
    testWidgets('modo criação: título, sem excluir e sem switch de ativo',
        (tester) async {
      await tester.pumpWidget(_wrap(_FakeProductsNotifier()));
      await tester.pump();

      expect(find.text('Novo produto'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsNothing);
      expect(find.text('Ativo'), findsNothing);
      // Sem seção de estoque na criação.
      expect(find.text('Gerenciar estoque'), findsNothing);
    });

    testWidgets('modo edição: prefill, excluir, ativo e seção de estoque',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester
          .pumpWidget(_wrap(_FakeProductsNotifier(), product: _existingProduct));
      await tester.pump();

      expect(find.text('Editar produto'), findsOneWidget);
      expect(find.text('Ração Premium'), findsOneWidget);
      expect(find.text('89.90'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
      expect(find.text('Ativo'), findsOneWidget);
      expect(find.text('Gerenciar estoque'), findsOneWidget);
      expect(find.text('7 em estoque'), findsOneWidget);
    });

    testWidgets('campo de categorias abre picker e exibe selecionadas',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_wrap(
        _FakeProductsNotifier(),
        categories: [_cat('c1', 'Rações'), _cat('c2', 'Brinquedos')],
      ));
      await tester.pump();

      // Sem chips — campo exibe placeholder.
      expect(find.byType(FilterChip), findsNothing);
      expect(find.text('Nenhuma selecionada'), findsOneWidget);

      // Abre o picker.
      await tester.tap(find.text('Nenhuma selecionada'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(CheckboxListTile, 'Rações'), findsOneWidget);
      expect(find.widgetWithText(CheckboxListTile, 'Brinquedos'), findsOneWidget);

      // Seleciona "Rações" e confirma.
      await tester.tap(find.widgetWithText(CheckboxListTile, 'Rações'));
      await tester.pump();
      await tester.tap(find.text('Aplicar'));
      await tester.pumpAndSettle();

      // Campo exibe a categoria selecionada.
      expect(find.text('Rações'), findsOneWidget);
    });

    testWidgets('salvar na criação chama createProduct com dados normalizados',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final notifier = _FakeProductsNotifier();

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
            builder: (_, _) => const AdminProductFormPage(),
          ),
        ],
      );

      await tester.pumpWidget(ProviderScope(
        overrides: [
          adminProductsProvider.overrideWith(() => notifier),
          adminCategoriesProvider.overrideWith(
              () => _FakeCategoriesNotifier([_cat('c1', 'Rações')])),
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
      ));

      await tester.tap(find.text('GO'));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Ração Nova');
      await tester.enterText(fields.at(1), 'Descrição longa o suficiente');
      // Vírgula deve ser normalizada para ponto.
      await tester.enterText(fields.at(2), '49,90');

      // Abre o picker de categorias e seleciona "Rações".
      await tester.ensureVisible(find.text('Nenhuma selecionada'));
      await tester.tap(find.text('Nenhuma selecionada'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(CheckboxListTile, 'Rações'));
      await tester.pump();
      await tester.tap(find.text('Aplicar'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Salvar'));
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();

      expect(notifier.created, isNotNull);
      expect(notifier.created!.name, 'Ração Nova');
      expect(notifier.created!.price, '49.90');
      expect(notifier.created!.categories.single.id, 'c1');
      expect(notifier.createdImagePaths, isEmpty);
      // Após pop voltou para a home.
      expect(find.text('GO'), findsOneWidget);
    });

    testWidgets('salvar em edição com imagens envia imageOrder correto',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 3000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final notifier = _FakeProductsNotifier();

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
            builder: (_, _) =>
                const AdminProductFormPage(product: _productWithImages),
          ),
        ],
      );

      await tester.pumpWidget(ProviderScope(
        overrides: [
          adminProductsProvider.overrideWith(() => notifier),
          adminCategoriesProvider
              .overrideWith(() => _FakeCategoriesNotifier(const [])),
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
      ));

      await tester.tap(find.text('GO'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Salvar'));
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();

      // imageOrder deve conter os IDs das imagens existentes na ordem original
      expect(notifier.updatedImageOrder, ['img1', 'img2']);
      expect(notifier.updatedRemoveImageIds, isEmpty);
    });

    testWidgets('imageOrder exclui imagem marcada para remoção',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 3000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final notifier = _FakeProductsNotifier();

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
            builder: (_, _) =>
                const AdminProductFormPage(product: _productWithImages),
          ),
        ],
      );

      await tester.pumpWidget(ProviderScope(
        overrides: [
          adminProductsProvider.overrideWith(() => notifier),
          adminCategoriesProvider
              .overrideWith(() => _FakeCategoriesNotifier(const [])),
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
      ));

      await tester.tap(find.text('GO'));
      await tester.pumpAndSettle();

      // Toca na primeira imagem para marcá-la como removida
      await tester.tap(find.byType(DragTarget<int>).first);
      await tester.pump();

      await tester.ensureVisible(find.text('Salvar'));
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();

      // img1 foi removida: imageOrder só contém img2
      expect(notifier.updatedImageOrder, ['img2']);
      expect(notifier.updatedRemoveImageIds, ['img1']);
    });

    testWidgets('excluir pede confirmação e chama deleteProduct',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final notifier = _FakeProductsNotifier();

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
            builder: (_, _) =>
                const AdminProductFormPage(product: _existingProduct),
          ),
        ],
      );

      await tester.pumpWidget(ProviderScope(
        overrides: [
          adminProductsProvider.overrideWith(() => notifier),
          adminCategoriesProvider
              .overrideWith(() => _FakeCategoriesNotifier(const [])),
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
      ));

      await tester.tap(find.text('GO'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      expect(find.text('Remover este produto?'), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, 'Excluir'));
      await tester.pumpAndSettle();

      expect(notifier.deletedId, 'p1');
      expect(find.text('GO'), findsOneWidget);
    });
  });
}
