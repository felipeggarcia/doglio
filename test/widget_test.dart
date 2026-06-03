import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doglio/app.dart';

void main() {
  testWidgets('App inicializa sem erro', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: DoglioApp()));
    // flush microtask do StoreNotifier.build (Future(() => _loadInitialData))
    await tester.pump(Duration.zero);

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
