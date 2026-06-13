library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doglio/features/admin/domain/entities/admin_order.dart';
import 'package:doglio/features/admin/domain/entities/admin_order_filters.dart';
import 'package:doglio/features/admin/domain/entities/page_meta.dart';
import 'package:doglio/features/admin/presentation/pages/admin_orders_page.dart';
import 'package:doglio/features/admin/presentation/providers/admin_orders_provider.dart';
import 'package:doglio/generated/l10n/app_localizations.dart';

// ─── Fake notifier ────────────────────────────────────────────────────────────

class _FakeOrdersNotifier extends AdminOrdersNotifier {
  final AdminOrdersState _initial;
  _FakeOrdersNotifier(this._initial);

  int refreshCount = 0;

  @override
  AdminOrdersState build() => _initial;

  @override
  Future<void> refresh() async => refreshCount++;
  @override
  Future<void> loadMore() async {}
  @override
  void setSearch(String search) {}
  @override
  void applyFilters(AdminOrderFilters filters) {}

  // Exposição de state para testes de reatividade.
  void setState(AdminOrdersState s) => state = s;
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

Widget _app(AdminOrdersState state, {_FakeOrdersNotifier? notifier}) {
  final n = notifier ?? _FakeOrdersNotifier(state);
  return ProviderScope(
    overrides: [
      adminOrdersProvider.overrideWith(() => n),
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
}

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

    // Regressão: campo de busca e chip de filtros substituem as linhas de chips.
    testWidgets('exibe campo de busca e chip de filtros', (tester) async {
      await tester.pumpWidget(_app(const AdminOrdersState()));
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Filtros'), findsOneWidget);
    });

    // Regressão: badge no chip de filtros mostra contagem de filtros ativos.
    testWidgets('chip de filtros mostra contagem quando há filtro ativo',
        (tester) async {
      await tester.pumpWidget(
        _app(const AdminOrdersState(
          filters: AdminOrderFilters(status: AdminOrderStatus.pending),
        )),
      );
      await tester.pump();

      expect(find.text('Filtros (1)'), findsOneWidget);
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

    // Regressão: a lista não atualizava após retornar de uma sub-página.
    // O fix usa "await pushNamed → notifier.refresh()"; este teste verifica
    // que a lista reage corretamente a uma mudança de estado emitida pelo
    // notifier (mecanismo que o refresh post-navegação aciona).
    testWidgets('lista reage a novo estado emitido pelo notifier',
        (tester) async {
      final notifier = _FakeOrdersNotifier(const AdminOrdersState());
      await tester.pumpWidget(_app(const AdminOrdersState(), notifier: notifier));
      await tester.pump();

      expect(find.text('Nenhum pedido encontrado'), findsOneWidget);

      // Simula o estado que chegaria após notifier.refresh() retornar dados.
      notifier.setState(AdminOrdersState(
        orders: [_order()],
        meta: const PageMeta(currentPage: 1, lastPage: 1, total: 1),
      ));
      await tester.pump();

      expect(find.text('#00001'), findsOneWidget);
      expect(find.text('Nenhum pedido encontrado'), findsNothing);
    });

    testWidgets('pull-to-refresh chama notifier.refresh', (tester) async {
      final notifier = _FakeOrdersNotifier(AdminOrdersState(
        orders: [_order()],
        meta: const PageMeta(currentPage: 1, lastPage: 1, total: 1),
      ));
      await tester.pumpWidget(_app(
        AdminOrdersState(
          orders: [_order()],
          meta: const PageMeta(currentPage: 1, lastPage: 1, total: 1),
        ),
        notifier: notifier,
      ));
      await tester.pump();

      await tester.drag(find.byType(ListView), const Offset(0, 400));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(notifier.refreshCount, greaterThan(0));
    });
  });
}
