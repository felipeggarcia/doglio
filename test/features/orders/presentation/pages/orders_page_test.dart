import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:doglio/features/orders/domain/entities/order.dart';
import 'package:doglio/features/orders/presentation/pages/orders_page.dart';
import 'package:doglio/features/orders/presentation/providers/orders_provider.dart';
import 'package:doglio/generated/l10n/app_localizations.dart';

// Notifier falso para injetar pedidos nos testes
class _FakeOrdersNotifier extends OrdersNotifier {
  _FakeOrdersNotifier(this._orders);
  final List<Order> _orders;

  @override
  Future<List<Order>> build() async => _orders;
}

Widget _app(List<Order> orders) {
  final router = GoRouter(
    initialLocation: '/orders',
    routes: [
      GoRoute(path: '/orders', builder: (_, _) => const OrdersPage()),
      GoRoute(path: '/orders/:id', builder: (_, _) => const SizedBox()),
    ],
  );
  return ProviderScope(
    overrides: [
      ordersProvider.overrideWith(() => _FakeOrdersNotifier(orders)),
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

Order _order({
  String id = '1',
  String? orderNumber = '00001',
  OrderStatus status = OrderStatus.pending,
  List<OrderItem>? items,
}) =>
    Order(
      id: id,
      orderNumber: orderNumber,
      status: status,
      items: items ??
          [
            const OrderItem(
              id: 'i1',
              productId: 'p1',
              productName: 'Ração Premium',
              price: '50.00',
              quantity: 2,
            ),
          ],
      total: '100.00',
      createdAt: DateTime(2026, 6, 8),
    );

void main() {
  group('OrdersPage', () {
    testWidgets('exibe card do pedido com número do pedido', (tester) async {
      await tester.pumpWidget(_app([_order()]));
      await tester.pump();

      expect(find.textContaining('00001'), findsOneWidget);
    });

    testWidgets('itens ficam ocultos antes de expandir', (tester) async {
      await tester.pumpWidget(_app([_order()]));
      await tester.pump();

      expect(find.text('Ração Premium'), findsNothing);
    });

    testWidgets('itens ficam visíveis após tap no card', (tester) async {
      await tester.pumpWidget(_app([_order()]));
      await tester.pump();

      // Toca no card para expandir
      await tester.tap(find.textContaining('00001'));
      await tester.pump();

      expect(find.text('Ração Premium'), findsOneWidget);
    });

    testWidgets('quantidade é exibida como "2×" e não "×2"', (tester) async {
      await tester.pumpWidget(_app([_order()]));
      await tester.pump();

      await tester.tap(find.textContaining('00001'));
      await tester.pump();

      expect(find.text('2×'), findsOneWidget);
      expect(find.text('×2'), findsNothing);
    });

    testWidgets('lista vazia exibe mensagem de estado vazio', (tester) async {
      await tester.pumpWidget(_app([]));
      await tester.pump();

      // Sem cards de pedidos — a lista não exibe nenhum número de pedido
      expect(find.textContaining('00001'), findsNothing);
    });

    testWidgets('múltiplos pedidos exibem múltiplos cards', (tester) async {
      final orders = [
        _order(id: '1', orderNumber: '00001'),
        _order(id: '2', orderNumber: '00002'),
      ];
      await tester.pumpWidget(_app(orders));
      await tester.pump();

      expect(find.textContaining('00001'), findsOneWidget);
      expect(find.textContaining('00002'), findsOneWidget);
    });
  });
}
