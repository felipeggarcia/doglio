import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:doglio/features/orders/domain/entities/order.dart';
import 'package:doglio/features/orders/presentation/pages/order_detail_page.dart';
import 'package:doglio/features/orders/presentation/providers/orders_provider.dart';
import 'package:doglio/generated/l10n/app_localizations.dart';

Widget _app(Order order) {
  final router = GoRouter(
    initialLocation: '/orders/${order.id}',
    routes: [
      GoRoute(
        path: '/orders/:id',
        builder: (_, state) =>
            OrderDetailPage(orderId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/product/:id',
        name: 'product-detail',
        builder: (_, _) => const SizedBox(),
      ),
    ],
  );
  return ProviderScope(
    overrides: [
      orderDetailProvider(order.id).overrideWith((ref) async => order),
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

Order _pendingOrderWithPix() => Order(
      id: '42',
      orderNumber: '00020',
      status: OrderStatus.pending,
      items: const [
        OrderItem(
          id: 'i1',
          productId: 'p1',
          productName: 'Coleira Anti-pulgas',
          price: '45.90',
          quantity: 1,
        ),
      ],
      total: '45.90',
      createdAt: DateTime(2026, 6, 8, 14, 9),
      payment: const OrderPayment(
        type: 'pix',
        status: 'pending',
        pixCode: '00020101021226720014BR.GOV.BCB.PIX01365f84a4b2',
        pixQrCode: null,
      ),
    );

Order _deliveredOrder() => Order(
      id: '43',
      orderNumber: '00019',
      status: OrderStatus.delivered,
      items: const [
        OrderItem(
          id: 'i2',
          productId: 'p2',
          productName: 'Ração Premium',
          price: '80.00',
          quantity: 1,
        ),
      ],
      total: '80.00',
      createdAt: DateTime(2026, 6, 7),
    );

void main() {
  group('OrderDetailPage', () {
    group('card de pagamento', () {
      testWidgets('visível para pedido pendente com payment', (tester) async {
        await tester.pumpWidget(_app(_pendingOrderWithPix()));
        await tester.pump();

        expect(find.text('Informações de Pagamento'), findsOneWidget);
      });

      testWidgets('não visível para pedido entregue', (tester) async {
        await tester.pumpWidget(_app(_deliveredOrder()));
        await tester.pump();

        expect(find.text('Informações de Pagamento'), findsNothing);
      });

      testWidgets('não visível para pedido pendente sem payment', (tester) async {
        final orderSemPayment = Order(
          id: '44',
          status: OrderStatus.pending,
          items: const [],
          total: '0.00',
          createdAt: DateTime(2026, 6, 8),
        );
        await tester.pumpWidget(_app(orderSemPayment));
        await tester.pump();

        expect(find.text('Informações de Pagamento'), findsNothing);
      });

      testWidgets('exibe código PIX quando payment é PIX', (tester) async {
        await tester.pumpWidget(_app(_pendingOrderWithPix()));
        await tester.pump();

        expect(find.textContaining('00020101021226720014BR'), findsOneWidget);
      });
    });

    group('itens do pedido', () {
      testWidgets('exibe nome do produto', (tester) async {
        await tester.pumpWidget(_app(_pendingOrderWithPix()));
        await tester.pump();

        expect(find.text('Coleira Anti-pulgas'), findsOneWidget);
      });

      testWidgets('exibe quantidade no formato "1 × R\$"', (tester) async {
        await tester.pumpWidget(_app(_pendingOrderWithPix()));
        await tester.pump();

        expect(find.textContaining('1 ×'), findsOneWidget);
      });

      testWidgets('não exibe CachedNetworkImage nos itens', (tester) async {
        await tester.pumpWidget(_app(_pendingOrderWithPix()));
        await tester.pump();

        // Imagem removida dos itens — nenhum widget de imagem deve aparecer
        // (o nome do produto é renderizado diretamente como Text)
        final itemNameFinder = find.text('Coleira Anti-pulgas');
        expect(itemNameFinder, findsOneWidget);

        // Verifica que o pai direto é GestureDetector (com underline), não um container de imagem
        final gestureDetectorFinder = find.ancestor(
          of: itemNameFinder,
          matching: find.byType(GestureDetector),
        );
        expect(gestureDetectorFinder, findsWidgets);
      });
    });

    group('número do pedido', () {
      testWidgets('exibe order_number quando disponível', (tester) async {
        await tester.pumpWidget(_app(_pendingOrderWithPix()));
        await tester.pump();

        expect(find.textContaining('00020'), findsWidgets);
      });
    });
  });
}
