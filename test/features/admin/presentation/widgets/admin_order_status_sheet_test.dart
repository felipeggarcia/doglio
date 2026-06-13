library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doglio/features/admin/domain/entities/admin_order.dart';
import 'package:doglio/features/admin/presentation/widgets/admin_order_status_sheet.dart';
import 'package:doglio/generated/l10n/app_localizations.dart';

// ─── Helpers ──────────────────────────────────────────────────────────────────

Widget _wrap(Widget child) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('pt'),
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );

// Abre o sheet via showModalBottomSheet e retorna o resultado ao fechar.
Widget _appWithSheet(AdminOrderStatus status, {ValueSetter<Object?>? onResult}) =>
    MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('pt'),
      home: Scaffold(
        body: Builder(
          builder: (ctx) => ElevatedButton(
            key: const Key('open'),
            onPressed: () async {
              final result = await showModalBottomSheet<
                  ({AdminOrderStatus status, String? notes})>(
                context: ctx,
                isScrollControlled: true,
                builder: (_) => AdminOrderStatusSheet(currentStatus: status),
              );
              onResult?.call(result);
            },
            child: const Text('open'),
          ),
        ),
      ),
    );

// ─── Testes ───────────────────────────────────────────────────────────────────

void main() {
  group('AdminOrderStatusSheet — regressões', () {
    // Regressão: RadioGroup do Flutter 3.32 crashava com RangeError quando
    // groupValue era null na abertura. Agora usa RadioListTile explícito.
    testWidgets(
        'não crasha ao abrir para nenhum status com transições válidas',
        (tester) async {
      for (final status in AdminOrderStatus.values.where((s) => !s.isFinal)) {
        await tester.pumpWidget(
          _wrap(AdminOrderStatusSheet(currentStatus: status)),
        );
        await tester.pump();

        expect(tester.takeException(), isNull,
            reason: 'Status $status não deveria lançar exceção');
        expect(find.byType(RadioListTile<AdminOrderStatus>), findsWidgets);
      }
    });

    testWidgets('renderiza exatamente 2 opções para confirmed', (tester) async {
      // confirmed → [preparing, cancelled]
      await tester.pumpWidget(
        _wrap(AdminOrderStatusSheet(currentStatus: AdminOrderStatus.confirmed)),
      );
      await tester.pump();

      expect(find.byType(RadioListTile<AdminOrderStatus>), findsNWidgets(2));
      expect(find.text('Iniciar preparo'), findsOneWidget);
      expect(find.text('Cancelar pedido'), findsOneWidget);
    });

    testWidgets('renderiza exatamente 2 opções para pending', (tester) async {
      // pending → [confirmed, cancelled]
      await tester.pumpWidget(
        _wrap(AdminOrderStatusSheet(currentStatus: AdminOrderStatus.pending)),
      );
      await tester.pump();

      expect(find.byType(RadioListTile<AdminOrderStatus>), findsNWidgets(2));
      expect(find.text('Confirmar pedido'), findsOneWidget);
      expect(find.text('Cancelar pedido'), findsOneWidget);
    });
  });

  group('AdminOrderStatusSheet — comportamento', () {
    testWidgets('botão confirmar começa desabilitado (sem seleção)',
        (tester) async {
      await tester.pumpWidget(
        _wrap(AdminOrderStatusSheet(currentStatus: AdminOrderStatus.confirmed)),
      );
      await tester.pump();

      final btn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(btn.onPressed, isNull);
    });

    testWidgets('botão confirmar habilita após selecionar um status',
        (tester) async {
      await tester.pumpWidget(
        _wrap(AdminOrderStatusSheet(currentStatus: AdminOrderStatus.confirmed)),
      );
      await tester.pump();

      await tester.tap(find.byType(RadioListTile<AdminOrderStatus>).first);
      await tester.pump();

      final btn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(btn.onPressed, isNotNull);
    });

    testWidgets('confirmar fecha o sheet e retorna status selecionado',
        (tester) async {
      Object? result;

      await tester.pumpWidget(
        _appWithSheet(
          AdminOrderStatus.confirmed,
          onResult: (r) => result = r,
        ),
      );
      await tester.pump();

      // Abre o sheet
      await tester.tap(find.byKey(const Key('open')));
      await tester.pumpAndSettle();

      // Seleciona o primeiro status (Iniciar preparo)
      await tester.tap(find.byType(RadioListTile<AdminOrderStatus>).first);
      await tester.pump();

      // Toca no botão Confirmar (último ElevatedButton na árvore — o do sheet)
      await tester.tap(find.byType(ElevatedButton).last);
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      final typed = result! as ({AdminOrderStatus status, String? notes});
      expect(typed.status, AdminOrderStatus.preparing);
      expect(typed.notes, isNull);
    });

    testWidgets('retorna notas preenchidas junto ao status', (tester) async {
      Object? result;

      await tester.pumpWidget(
        _appWithSheet(
          AdminOrderStatus.confirmed,
          onResult: (r) => result = r,
        ),
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key('open')));
      await tester.pumpAndSettle();

      // Seleciona o segundo status (Cancelar pedido)
      await tester.tap(find.byType(RadioListTile<AdminOrderStatus>).last);
      await tester.pump();

      // Digita observação
      await tester.enterText(find.byType(TextField), 'Motivo do cancelamento');
      await tester.pump();

      await tester.tap(find.byType(ElevatedButton).last);
      await tester.pumpAndSettle();

      final typed = result! as ({AdminOrderStatus status, String? notes});
      expect(typed.status, AdminOrderStatus.cancelled);
      expect(typed.notes, 'Motivo do cancelamento');
    });
  });
}
