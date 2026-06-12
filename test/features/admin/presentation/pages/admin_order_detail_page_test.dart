library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:doglio/core/errors/failures.dart';
import 'package:doglio/features/admin/domain/entities/admin_order.dart';
import 'package:doglio/features/admin/presentation/pages/admin_order_detail_page.dart';
import 'package:doglio/features/admin/presentation/providers/admin_orders_provider.dart';
import 'package:doglio/generated/l10n/app_localizations.dart';

// ─── Fake notifier ────────────────────────────────────────────────────────────

class _FakeDetailNotifier extends AdminOrderDetailNotifier {
  final AdminOrderDetailState _initial;
  _FakeDetailNotifier(this._initial);

  @override
  AdminOrderDetailState build(String arg) => _initial;

  @override
  Future<void> refresh() async {}

  @override
  Future<Either<Failure, Unit>> updateStatus(
    AdminOrderStatus status, {
    String? notes,
  }) async =>
      const Right(unit);

  @override
  Future<Either<Failure, Unit>> addItem({
    required String productId,
    required int quantity,
  }) async =>
      const Right(unit);

  @override
  Future<Either<Failure, Unit>> updateItem(
    String itemId, {
    required int quantity,
  }) async =>
      const Right(unit);

  @override
  Future<Either<Failure, Unit>> removeItem(String itemId) async =>
      const Right(unit);
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

AdminOrder _order({
  AdminOrderStatus status = AdminOrderStatus.confirmed,
  bool withAddress = true,
  bool withPayment = false,
  bool withHistory = false,
  bool withItem = false,
}) {
  final address = withAddress
      ? const AdminOrderShippingAddress(
          street: 'Rua das Flores',
          number: '123',
          district: 'Centro',
          city: 'São Paulo',
          state: 'SP',
          zipCode: '01001-000',
        )
      : null;

  final payment = withPayment
      ? const AdminOrderPaymentInfo(
          status: 'paid',
          paymentMethodName: 'PIX',
          paymentMethodType: 'pix',
        )
      : null;

  final history = withHistory
      ? [
          AdminOrderStatusEntry(
            status: AdminOrderStatus.pending,
            createdAt: DateTime(2026, 6, 10, 10),
          ),
          AdminOrderStatusEntry(
            status: AdminOrderStatus.confirmed,
            notes: 'Confirmado pela equipe',
            createdAt: DateTime(2026, 6, 10, 11),
          ),
        ]
      : <AdminOrderStatusEntry>[];

  final items = withItem
      ? [
          const AdminOrderItem(
            id: 'item1',
            productId: 'p1',
            productName: 'Produto Alpha',
            unitPrice: '29.90',
            quantity: 2,
            subtotal: '59.80',
          ),
        ]
      : <AdminOrderItem>[];

  return AdminOrder(
    id: 'ord1',
    orderNumber: '00042',
    status: status,
    totalAmount: '59.80',
    deliveryType: withAddress ? 'delivery' : 'pickup',
    customer: const AdminOrderCustomer(
        id: 'c1', name: 'Maria Souza', email: 'maria@x.com'),
    items: items,
    shippingAddress: address,
    payment: payment,
    statusHistory: history,
    createdAt: DateTime(2026, 6, 10),
  );
}

Widget _app(AdminOrderDetailState state, {AdminOrder? preload}) =>
    ProviderScope(
      overrides: [
        adminOrderDetailProvider.overrideWith(() => _FakeDetailNotifier(state)),
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
        home: AdminOrderDetailPage(
          orderId: 'ord1',
          order: preload,
        ),
      ),
    );

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  group('AdminOrderDetailPage', () {
    testWidgets('mostra spinner quando carregando sem pedido pré-carregado',
        (tester) async {
      await tester.pumpWidget(
          _app(const AdminOrderDetailState(isLoading: true)));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('usa pedido pré-carregado (extra) enquanto carrega',
        (tester) async {
      final order = _order();
      await tester.pumpWidget(
        _app(const AdminOrderDetailState(isLoading: true), preload: order),
      );
      await tester.pump();

      expect(find.text('Pedido #00042'), findsOneWidget);
      expect(find.text('Maria Souza'), findsOneWidget);
    });

    testWidgets('mostra erro com retry quando sem pedido', (tester) async {
      await tester.pumpWidget(
        _app(const AdminOrderDetailState(errorMessage: 'Erro de rede')),
      );
      await tester.pump();

      expect(find.text('Erro de rede'), findsOneWidget);
      expect(find.text('Tentar Novamente'), findsOneWidget);
    });

    testWidgets('renderiza seção de cliente', (tester) async {
      final order = _order();
      await tester.pumpWidget(
          _app(AdminOrderDetailState(order: order)));
      await tester.pump();

      expect(find.text('Cliente'), findsOneWidget);
      expect(find.text('Maria Souza'), findsOneWidget);
      expect(find.text('maria@x.com'), findsOneWidget);
    });

    testWidgets('renderiza seção de entrega com endereço', (tester) async {
      final order = _order(withAddress: true);
      await tester.pumpWidget(
          _app(AdminOrderDetailState(order: order)));
      await tester.pump();

      expect(find.text('Entrega'), findsWidgets);
      expect(find.textContaining('Rua das Flores'), findsOneWidget);
    });

    testWidgets('renderiza seção de entrega sem endereço (retirada)',
        (tester) async {
      final order = _order(withAddress: false);
      await tester.pumpWidget(
          _app(AdminOrderDetailState(order: order)));
      await tester.pump();

      expect(find.text('Retirada no local'), findsOneWidget);
    });

    testWidgets('renderiza item do pedido', (tester) async {
      final order = _order(withItem: true);
      await tester.pumpWidget(
          _app(AdminOrderDetailState(order: order)));
      await tester.pump();

      expect(find.text('Produto Alpha'), findsOneWidget);
      expect(find.textContaining('2 × R\$'), findsOneWidget);
    });

    testWidgets('item tem botão editar quando status não é final',
        (tester) async {
      final order = _order(
        status: AdminOrderStatus.confirmed,
        withItem: true,
      );
      await tester.pumpWidget(
          _app(AdminOrderDetailState(order: order)));
      await tester.pump();

      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    });

    testWidgets('item NÃO tem botão editar quando status é final',
        (tester) async {
      final order = _order(
        status: AdminOrderStatus.delivered,
        withItem: true,
      );
      await tester.pumpWidget(
          _app(AdminOrderDetailState(order: order)));
      await tester.pump();

      expect(find.byIcon(Icons.edit_outlined), findsNothing);
    });

    testWidgets('FAB presente quando status não é final', (tester) async {
      final order = _order(status: AdminOrderStatus.confirmed);
      await tester.pumpWidget(
          _app(AdminOrderDetailState(order: order)));
      await tester.pump();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('Atualizar status'), findsWidgets);
    });

    testWidgets('FAB ausente quando status é final (entregue)', (tester) async {
      final order = _order(status: AdminOrderStatus.delivered);
      await tester.pumpWidget(
          _app(AdminOrderDetailState(order: order)));
      await tester.pump();

      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets('FAB ausente quando status é final (cancelado)', (tester) async {
      final order = _order(status: AdminOrderStatus.cancelled);
      await tester.pumpWidget(
          _app(AdminOrderDetailState(order: order)));
      await tester.pump();

      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets('renderiza seção de histórico com notas', (tester) async {
      final order = _order(withHistory: true);
      await tester.pumpWidget(
          _app(AdminOrderDetailState(order: order)));
      await tester.pump();

      expect(find.text('Histórico de status'), findsOneWidget);
      expect(find.text('Confirmado pela equipe'), findsOneWidget);
    });

    testWidgets('renderiza seção de pagamento', (tester) async {
      final order = _order(withPayment: true);
      await tester.pumpWidget(
          _app(AdminOrderDetailState(order: order)));
      await tester.pump();

      expect(find.text('Pagamento'), findsOneWidget);
      expect(find.text('PIX'), findsOneWidget);
    });

    testWidgets('botão "Adicionar produto" presente quando não é final',
        (tester) async {
      final order = _order(status: AdminOrderStatus.confirmed);
      await tester.pumpWidget(
          _app(AdminOrderDetailState(order: order)));
      await tester.pump();

      expect(find.text('Adicionar produto'), findsWidgets);
    });

    testWidgets('botão "Adicionar produto" ausente quando é final',
        (tester) async {
      final order = _order(status: AdminOrderStatus.delivered);
      await tester.pumpWidget(
          _app(AdminOrderDetailState(order: order)));
      await tester.pump();

      expect(find.text('Adicionar produto'), findsNothing);
    });
  });
}
