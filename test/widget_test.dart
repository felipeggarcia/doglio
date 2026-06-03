import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doglio/app.dart';

void main() {
  testWidgets('App inicializa sem erro', (WidgetTester tester) async {
    await tester.pumpWidget(const DoglioApp());
    await tester.pump();

    // Verifica que o app renderiza algum widget Material sem lançar exceção
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
