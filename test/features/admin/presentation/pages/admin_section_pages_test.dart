import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doglio/features/admin/presentation/pages/admin_categories_page.dart';
import 'package:doglio/features/admin/presentation/pages/admin_orders_page.dart';
import 'package:doglio/features/admin/presentation/pages/admin_products_page.dart';
import 'package:doglio/features/admin/presentation/pages/admin_promotions_page.dart';
import 'package:doglio/generated/l10n/app_localizations.dart';

Widget _app(Widget page) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('pt'),
      home: page,
    );

void main() {
  group('Páginas de seção admin (placeholders)', () {
    final cases = <String, (Widget, String)>{
      'Produtos': (const AdminProductsPage(), 'Produtos'),
      'Pedidos': (const AdminOrdersPage(), 'Pedidos'),
      'Categorias': (const AdminCategoriesPage(), 'Categorias'),
      'Promoções': (const AdminPromotionsPage(), 'Promoções'),
    };

    cases.forEach((name, data) {
      final (page, title) = data;
      testWidgets('$name exibe título e estado "em construção"',
          (tester) async {
        await tester.pumpWidget(_app(page));
        await tester.pump();

        // Título aparece na AppBar
        expect(find.text(title), findsOneWidget);
        // Mensagem de placeholder
        expect(find.text('Em construção'), findsOneWidget);
        expect(
          find.text('Esta seção estará disponível em breve.'),
          findsOneWidget,
        );
      });
    });
  });
}
