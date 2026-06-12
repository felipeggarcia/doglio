library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doglio/features/admin/domain/entities/admin_order.dart';
import 'package:doglio/features/admin/domain/entities/page_meta.dart';
import 'package:doglio/features/admin/presentation/pages/admin_orders_page.dart';
import 'package:doglio/features/admin/presentation/providers/admin_orders_provider.dart';
import 'package:doglio/generated/l10n/app_localizations.dart';

// ─── Fake notifier ────────────────────────────────────────────────────────────

class _FakeOrdersNotifier extends AdminOrdersNotifier {
  final AdminOrdersState _initial;
  _FakeOrdersNotifier(this._initial);

  @override
  AdminOrdersState build() => _initial;

  @override
  Future<void> refresh() async {}
  @override
  Future<void> loadMore() async {}
  @override
  void setStatusFilter(AdminOrderStatus? status) {}
  @override
  void setDeliveryTypeFilter(String? type) {}
  @override
  void setDateRange(DateTimeRange? range) {}
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

AdminOrder _order({
  String id = 'o1',
  String? orderNumber = '00001',
  AdminOrderStatus status = AdminOrderStatus.confirmed,
  String deliveryType = 'delivery',
}) =>
    AdminOrder(
      id: id,
      orderNumber: orderNumber,
      status: status,
      totalAmount: '99.90',
      deliveryType: deliveryType,
      customer: const AdminOrderCustomer(
          id: 'c1', name: 'João Silva', email: 'joao@x.com'),
      items: const [],
      createdAt: DateTime(2026, 6, 10),
    );

Widget _app(AdminOrdersState state) => ProviderScope(
      overrides: [
        adminOrdersProvider.overrideWith(() => _FakeOrdersNotifier(state)),
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
        home: const AdminOrdersPage(),
      ),
    );

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  group('AdminOrdersPage', () {
    testWidgets('mostra spinner quando isLoading e lista vazia', (tester) async {
      await tester.pumpWidget(
          _app(const AdminOrdersState(isLoading: true)));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('mostra estado vazio quando sem pedidos', (tester) async {
      await tester.pumpWidget(_app(const AdminOrdersState()));
      await tester.pump();

      expect(find.text('Nenhum pedido encontrado'), findsOneWidget);
    });

    testWidgets('mostra erro com botão retry', (tester) async {
      await tester.pumpWidget(
        _app(const AdminOrdersState(errorMessage: 'Falha de rede')),
      );
      await tester.pump();

      expect(find.text('Falha de rede'), findsOneWidget);
      expect(find.text('Tentar Novamente'), findsOneWidget);
    });

    testWidgets('renderiza tile com dados do pedido', (tester) async {
      final order = _order();
      await tester.pumpWidget(
        _app(AdminOrdersState(
          orders: [order],
          meta: const PageMeta(currentPage: 1, lastPage: 1, total: 1),
        )),
      );
      await tester.pump();

      expect(find.text('#00001'), findsOneWidget);
      expect(find.text('João Silva'), findsOneWidget);
      expect(find.text('R\$ 99.90'), findsOneWidget);
    });

    testWidgets('renderiza chips de filtro de status', (tester) async {
      await tester.pumpWidget(_app(const AdminOrdersState()));
      await tester.pump();

      expect(find.text('Todos'), findsWidgets);
      expect(find.text('Pendente'), findsOneWidget);
      expect(find.text('Confirmado'), findsOneWidget);
      expect(find.text('Cancelado'), findsOneWidget);
    });

    testWidgets('renderiza chips de tipo de entrega', (tester) async {
      await tester.pumpWidget(_app(const AdminOrdersState()));
      await tester.pump();

      expect(find.text('Entrega'), findsOneWidget);
      expect(find.text('Retirada'), findsOneWidget);
    });

    testWidgets('mostra botão carregar mais quando hasMore', (tester) async {
      await tester.pumpWidget(
        _app(AdminOrdersState(
          orders: [_order()],
          meta: const PageMeta(currentPage: 1, lastPage: 2, total: 20),
        )),
      );
      await tester.pump();

      expect(find.text('Carregar mais'), findsOneWidget);
    });

    testWidgets('não mostra carregar mais quando na última página',
        (tester) async {
      await tester.pumpWidget(
        _app(AdminOrdersState(
          orders: [_order()],
          meta: const PageMeta(currentPage: 1, lastPage: 1, total: 1),
        )),
      );
      await tester.pump();

      expect(find.text('Carregar mais'), findsNothing);
    });

    testWidgets('badge de status é exibido no tile', (tester) async {
      final order = _order(status: AdminOrderStatus.preparing);
      await tester.pumpWidget(
        _app(AdminOrdersState(
          orders: [order],
          meta: const PageMeta(currentPage: 1, lastPage: 1, total: 1),
        )),
      );
      await tester.pump();

      expect(find.text('Preparando'), findsWidgets);
    });

    testWidgets('AppBar exibe título "Pedidos"', (tester) async {
      await tester.pumpWidget(_app(const AdminOrdersState()));
      await tester.pump();

      expect(find.text('Pedidos'), findsOneWidget);
    });
  });
}
