import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doglio/core/widgets/cart_bubble.dart';
import 'package:doglio/generated/l10n/app_localizations.dart';

// ─── Helper de app ────────────────────────────────────────────────────────────

// Usa locale 'en' para evitar ausência de GlobalCupertinoLocalizations em 'pt'
Widget _app({required Widget Function(BuildContext) body}) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(body: Builder(builder: body)),
    );

/// Avança o tempo além do auto-dismiss para esvaziar timers pendentes.
/// Todo teste que abre um balão e não testa o desaparecimento deve chamar isto.
Future<void> _clearTimer(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 2200)); // dispara reverse
  await tester.pump(const Duration(milliseconds: 300));  // conclui animação
  await tester.pump();                                   // processa remoção
}

// ─── CartBubble ───────────────────────────────────────────────────────────────

void main() {
  group('CartBubble', () {
    testWidgets('exibe mensagem ao chamar show()', (tester) async {
      await tester.pumpWidget(_app(
        body: (ctx) => TextButton(
          onPressed: () => CartBubble.show(ctx),
          child: const Text('tap'),
        ),
      ));

      await tester.tap(find.text('tap'));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Product added to cart'), findsOneWidget);
      await _clearTimer(tester);
    });

    testWidgets('exibe ícone de check', (tester) async {
      await tester.pumpWidget(_app(
        body: (ctx) => TextButton(
          onPressed: () => CartBubble.show(ctx),
          child: const Text('tap'),
        ),
      ));

      await tester.tap(find.text('tap'));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
      await _clearTimer(tester);
    });

    testWidgets('balão some após ~2.5s', (tester) async {
      await tester.pumpWidget(_app(
        body: (ctx) => TextButton(
          onPressed: () => CartBubble.show(ctx),
          child: const Text('tap'),
        ),
      ));

      await tester.tap(find.text('tap'));
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('Product added to cart'), findsOneWidget);

      await _clearTimer(tester);

      expect(find.text('Product added to cart'), findsNothing);
    });

    testWidgets('show() consecutivo descarta balão anterior', (tester) async {
      await tester.pumpWidget(_app(
        body: (ctx) => TextButton(
          onPressed: () {
            CartBubble.show(ctx);
            CartBubble.show(ctx);
          },
          child: const Text('tap'),
        ),
      ));

      await tester.tap(find.text('tap'));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Product added to cart'), findsOneWidget);
      await _clearTimer(tester);
    });
  });

  // ─── FavoriteBubble — added: true ──────────────────────────────────────────

  group('FavoriteBubble — added: true', () {
    testWidgets('exibe mensagem de adicionado', (tester) async {
      await tester.pumpWidget(_app(
        body: (ctx) => TextButton(
          onPressed: () => FavoriteBubble.show(ctx, added: true),
          child: const Text('tap'),
        ),
      ));

      await tester.tap(find.text('tap'));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Added to favorites'), findsOneWidget);
      await _clearTimer(tester);
    });

    testWidgets('exibe ícone de coração', (tester) async {
      await tester.pumpWidget(_app(
        body: (ctx) => TextButton(
          onPressed: () => FavoriteBubble.show(ctx, added: true),
          child: const Text('tap'),
        ),
      ));

      await tester.tap(find.text('tap'));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      await _clearTimer(tester);
    });
  });

  // ─── FavoriteBubble — added: false ─────────────────────────────────────────

  group('FavoriteBubble — added: false', () {
    testWidgets('exibe mensagem de removido', (tester) async {
      await tester.pumpWidget(_app(
        body: (ctx) => TextButton(
          onPressed: () => FavoriteBubble.show(ctx, added: false),
          child: const Text('tap'),
        ),
      ));

      await tester.tap(find.text('tap'));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Removed from favorites'), findsOneWidget);
      await _clearTimer(tester);
    });

    testWidgets('exibe ícone de coração partido', (tester) async {
      await tester.pumpWidget(_app(
        body: (ctx) => TextButton(
          onPressed: () => FavoriteBubble.show(ctx, added: false),
          child: const Text('tap'),
        ),
      ));

      await tester.tap(find.text('tap'));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byIcon(Icons.heart_broken_outlined), findsOneWidget);
      await _clearTimer(tester);
    });
  });

  // ─── Dismiss ───────────────────────────────────────────────────────────────

  group('Dismiss automático', () {
    testWidgets('CartBubble some após ~2.5s', (tester) async {
      await tester.pumpWidget(_app(
        body: (ctx) => TextButton(
          onPressed: () => CartBubble.show(ctx),
          child: const Text('tap'),
        ),
      ));

      await tester.tap(find.text('tap'));
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('Product added to cart'), findsOneWidget);

      await _clearTimer(tester);
      expect(find.text('Product added to cart'), findsNothing);
    });

    testWidgets('FavoriteBubble some após ~2.5s', (tester) async {
      await tester.pumpWidget(_app(
        body: (ctx) => TextButton(
          onPressed: () => FavoriteBubble.show(ctx, added: true),
          child: const Text('tap'),
        ),
      ));

      await tester.tap(find.text('tap'));
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('Added to favorites'), findsOneWidget);

      await _clearTimer(tester);
      expect(find.text('Added to favorites'), findsNothing);
    });

    testWidgets('FavoriteBubble added=true substitui added=false', (tester) async {
      late BuildContext capturedCtx;
      await tester.pumpWidget(_app(body: (ctx) {
        capturedCtx = ctx;
        return const SizedBox();
      }));
      await tester.pump();

      FavoriteBubble.show(capturedCtx, added: false);
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('Removed from favorites'), findsOneWidget);

      FavoriteBubble.show(capturedCtx, added: true);
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('Added to favorites'), findsOneWidget);
      expect(find.text('Removed from favorites'), findsNothing);

      await _clearTimer(tester);
    });
  });

  // ─── Posicionamento — bolha abaixo do ícone ───────────────────────────────
  //
  // Garante que o topOffset é derivado da posição real do widget cujo contexto
  // foi passado para show(), e não de uma constante fixa como kToolbarHeight+8.
  // Regressão: usar padding.top (=0 dentro do Scaffold) resultava no balão
  // aparecendo dentro da AppBar verde, com o triângulo invisível.

  group('Posicionamento — bolha abaixo do ícone de origem', () {
    // Ícone posicionado em y=72, altura=48 → bottom=120.
    // Fallback fixo (kToolbarHeight+8=64) ficaria ACIMA do ícone: 64 < 120.
    // Abordagem correta (renderBox) coloca em 120+4=124 > 120 → ABAIXO. ✓
    const iconTop = 72.0;
    const iconHeight = 48.0;

    testWidgets('CartBubble aparece abaixo do ícone cujo contexto foi passado', (tester) async {
      await tester.pumpWidget(_app(
        body: (ctx) => Padding(
          padding: const EdgeInsets.only(top: iconTop),
          child: Builder(
            builder: (btnCtx) => GestureDetector(
              // opaque: SizedBox sem cor não receberia tap com deferToChild
              behavior: HitTestBehavior.opaque,
              onTap: () => CartBubble.show(btnCtx),
              child: const SizedBox(width: 48, height: iconHeight),
            ),
          ),
        ),
      ));

      await tester.tap(find.byType(GestureDetector));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Product added to cart'), findsOneWidget);

      final positioned = tester.widget<Positioned>(
        find.ancestor(
          of: find.text('Product added to cart'),
          matching: find.byType(Positioned),
        ).first,
      );
      expect(positioned.top, greaterThan(iconTop + iconHeight));
      await _clearTimer(tester);
    });

    testWidgets('FavoriteBubble aparece abaixo do ícone cujo contexto foi passado', (tester) async {
      await tester.pumpWidget(_app(
        body: (ctx) => Padding(
          padding: const EdgeInsets.only(top: iconTop),
          child: Builder(
            builder: (btnCtx) => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FavoriteBubble.show(btnCtx, added: true),
              child: const SizedBox(width: 48, height: iconHeight),
            ),
          ),
        ),
      ));

      await tester.tap(find.byType(GestureDetector));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Added to favorites'), findsOneWidget);

      final positioned = tester.widget<Positioned>(
        find.ancestor(
          of: find.text('Added to favorites'),
          matching: find.byType(Positioned),
        ).first,
      );
      expect(positioned.top, greaterThan(iconTop + iconHeight));
      await _clearTimer(tester);
    });
  });
}
