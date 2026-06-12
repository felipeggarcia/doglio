import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:doglio/core/errors/failures.dart';
import 'package:doglio/features/admin/domain/entities/admin_product.dart';
import 'package:doglio/features/admin/domain/entities/stock_movement.dart';
import 'package:doglio/features/admin/presentation/pages/admin_product_stock_page.dart';
import 'package:doglio/features/admin/presentation/providers/admin_product_stock_provider.dart';
import 'package:doglio/generated/l10n/app_localizations.dart';

class _FakeStockNotifier extends AdminProductStockNotifier {
  _FakeStockNotifier(this._initial);
  final AdminProductStockState _initial;

  StockMovementType? adjustedType;
  int? adjustedQuantity;
  int? adjustedAbsolute;
  StockMovementReason? adjustedReason;
  String? adjustedNotes;

  @override
  AdminProductStockState build(String arg) => _initial;

  @override
  Future<void> refresh() async {}

  @override
  Future<void> loadMore() async {}

  @override
  Future<Either<Failure, StockMovement>> adjust({
    StockMovementType? type,
    int? quantity,
    int? absolute,
    StockMovementReason reason = StockMovementReason.manualAdjustment,
    String? notes,
  }) async {
    adjustedType = type;
    adjustedQuantity = quantity;
    adjustedAbsolute = absolute;
    adjustedReason = reason;
    adjustedNotes = notes;
    return const Right(StockMovement(
      id: 'm1',
      type: StockMovementType.stockIn,
      quantity: 1,
      stockBefore: 0,
      stockAfter: 1,
      reason: StockMovementReason.manualAdjustment,
    ));
  }
}

const _product = AdminProduct(
  id: 'p1',
  name: 'Ração Premium',
  description: 'desc',
  price: '89.90',
  isHighlighted: false,
  isActive: true,
  inStock: true,
  stockQuantity: 7,
);

StockMovement _movement(
  String id, {
  StockMovementType type = StockMovementType.stockIn,
  int quantity = 10,
}) =>
    StockMovement(
      id: id,
      type: type,
      quantity: quantity,
      stockBefore: 0,
      stockAfter: 10,
      reason: StockMovementReason.purchase,
      performedBy: 'Admin',
      createdAt: '2026-06-01',
    );

Widget _app(AdminProductStockState state, {_FakeStockNotifier? notifier}) {
  return ProviderScope(
    overrides: [
      adminProductStockProvider
          .overrideWith(() => notifier ?? _FakeStockNotifier(state)),
    ],
    child: const MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('pt'),
      home: AdminProductStockPage(productId: 'p1', product: _product),
    ),
  );
}

void main() {
  group('AdminProductStockPage', () {
    testWidgets('header mostra nome do produto e estoque atual',
        (tester) async {
      await tester.pumpWidget(_app(const AdminProductStockState()));
      await tester.pump();

      expect(find.text('Ração Premium'), findsOneWidget);
      // currentStock null no estado → usa o stockQuantity do produto (7).
      expect(find.textContaining('7 em estoque'), findsOneWidget);
    });

    testWidgets('renderiza movimentações com quantidade e motivo',
        (tester) async {
      await tester.pumpWidget(_app(AdminProductStockState(
        movements: [
          _movement('m1'),
          _movement('m2', type: StockMovementType.stockOut, quantity: 3),
        ],
      )));
      await tester.pump();

      expect(find.text('+10 · Compra'), findsOneWidget);
      expect(find.text('-3 · Compra'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
    });

    testWidgets('histórico vazio mostra mensagem', (tester) async {
      await tester.pumpWidget(_app(const AdminProductStockState()));
      await tester.pump();

      expect(
          find.text('Nenhuma movimentação de estoque'), findsOneWidget);
    });

    testWidgets('FAB abre o sheet de movimentação', (tester) async {
      await tester.pumpWidget(_app(const AdminProductStockState()));
      await tester.pump();

      await tester.tap(find.text('Movimentar estoque'));
      await tester.pumpAndSettle();

      expect(find.text('Entrada/Saída'), findsOneWidget);
      expect(find.text('Definir total'), findsOneWidget);
      expect(find.text('Quantidade'), findsOneWidget);
      expect(find.text('Motivo'), findsOneWidget);
    });

    testWidgets('modo delta: confirmar chama adjust com type e quantity',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final notifier = _FakeStockNotifier(const AdminProductStockState());
      await tester
          .pumpWidget(_app(const AdminProductStockState(), notifier: notifier));
      await tester.pump();

      await tester.tap(find.text('Movimentar estoque'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Saída'));
      await tester.pump();
      await tester.enterText(find.byType(TextFormField).first, '2');
      await tester.tap(find.text('Confirmar'));
      await tester.pumpAndSettle();

      expect(notifier.adjustedType, StockMovementType.stockOut);
      expect(notifier.adjustedQuantity, 2);
      expect(notifier.adjustedAbsolute, isNull);
      expect(notifier.adjustedReason, StockMovementReason.manualAdjustment);
      // Snackbar de sucesso.
      expect(find.text('Estoque atualizado.'), findsOneWidget);
    });

    testWidgets('modo absoluto: esconde entrada/saída e envia absolute',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final notifier = _FakeStockNotifier(const AdminProductStockState());
      await tester
          .pumpWidget(_app(const AdminProductStockState(), notifier: notifier));
      await tester.pump();

      await tester.tap(find.text('Movimentar estoque'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Definir total'));
      await tester.pumpAndSettle();

      expect(find.text('Entrada'), findsNothing);
      expect(find.text('Saída'), findsNothing);

      await tester.enterText(find.byType(TextFormField).first, '0');
      await tester.tap(find.text('Confirmar'));
      await tester.pumpAndSettle();

      expect(notifier.adjustedAbsolute, 0);
      expect(notifier.adjustedType, isNull);
      expect(notifier.adjustedQuantity, isNull);
    });

    testWidgets('quantidade inválida no modo delta bloqueia o confirmar',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final notifier = _FakeStockNotifier(const AdminProductStockState());
      await tester
          .pumpWidget(_app(const AdminProductStockState(), notifier: notifier));
      await tester.pump();

      await tester.tap(find.text('Movimentar estoque'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, '0');
      await tester.tap(find.text('Confirmar'));
      await tester.pumpAndSettle();

      expect(find.text('Informe uma quantidade válida'), findsOneWidget);
      expect(notifier.adjustedQuantity, isNull);
    });
  });
}
