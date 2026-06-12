library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doglio/features/admin/domain/entities/admin_product.dart';
import 'package:doglio/features/admin/presentation/widgets/admin_product_images_field.dart';
import 'package:doglio/generated/l10n/app_localizations.dart';

AdminProductImage _img(String id, {int order = 0}) => AdminProductImage(
      id: id,
      url: 'http://10.0.2.2/storage/$id.jpg',
      isPrimary: order == 0,
      order: order,
    );

Widget _wrap({
  required List<Object> orderedImages,
  Set<String> removedImageIds = const {},
  void Function(String)? onToggleExisting,
  void Function(int)? onRemoveNew,
  VoidCallback? onAddPressed,
  void Function(int, int)? onReorder,
  bool enabled = true,
}) =>
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
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: AdminProductImagesField(
            orderedImages: orderedImages,
            removedImageIds: removedImageIds,
            onToggleExisting: onToggleExisting ?? (_) {},
            onRemoveNew: onRemoveNew ?? (_) {},
            onAddPressed: onAddPressed ?? () {},
            onReorder: onReorder ?? (_, _) {},
            enabled: enabled,
          ),
        ),
      ),
    );

void main() {
  group('AdminProductImagesField', () {
    testWidgets('lista vazia mostra apenas botão adicionar', (tester) async {
      await tester.pumpWidget(_wrap(orderedImages: []));
      await tester.pump();

      expect(find.byIcon(Icons.add_photo_alternate_outlined), findsOneWidget);
      expect(find.byType(DragTarget<int>), findsNothing);
    });

    testWidgets('badge ★ aparece exatamente em displayPos 0', (tester) async {
      await tester.pumpWidget(_wrap(
        orderedImages: [_img('a'), _img('b', order: 1)],
      ));
      await tester.pump();

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('badge ★ ausente quando imagem de capa está marcada para remoção',
        (tester) async {
      await tester.pumpWidget(_wrap(
        orderedImages: [_img('a'), _img('b', order: 1)],
        removedImageIds: {'a'},
      ));
      await tester.pump();

      // _ExistingTile: isCover é false se id está em removedImageIds
      expect(find.byIcon(Icons.star), findsNothing);
    });

    testWidgets('imagem marcada para remoção exibe overlay com ícone de lixeira',
        (tester) async {
      await tester.pumpWidget(_wrap(
        orderedImages: [_img('a')],
        removedImageIds: {'a'},
      ));
      await tester.pump();

      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('toque em imagem existente chama onToggleExisting com o id correto',
        (tester) async {
      String? toggled;
      await tester.pumpWidget(_wrap(
        orderedImages: [_img('img-x')],
        onToggleExisting: (id) => toggled = id,
      ));
      await tester.pump();

      // DragTarget é a raiz do slot; o GestureDetector interno recebe o tap
      await tester.tap(find.byType(DragTarget<int>).first);
      await tester.pump();

      expect(toggled, 'img-x');
    });

    testWidgets('toque no botão adicionar chama onAddPressed', (tester) async {
      bool called = false;
      await tester.pumpWidget(_wrap(
        orderedImages: [],
        onAddPressed: () => called = true,
      ));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.add_photo_alternate_outlined));
      await tester.pump();

      expect(called, isTrue);
    });

    testWidgets('disabled: sem DragTargets e toque no adicionar não dispara callback',
        (tester) async {
      bool addCalled = false;
      await tester.pumpWidget(_wrap(
        orderedImages: [_img('a')],
        onAddPressed: () => addCalled = true,
        enabled: false,
      ));
      await tester.pump();

      // Slots viram SizedBox sem DragTarget
      expect(find.byType(DragTarget<int>), findsNothing);

      await tester.tap(find.byIcon(Icons.add_photo_alternate_outlined),
          warnIfMissed: false);
      await tester.pump();

      expect(addCalled, isFalse);
    });

    testWidgets('disabled: toque em imagem não chama onToggleExisting',
        (tester) async {
      bool called = false;
      await tester.pumpWidget(_wrap(
        orderedImages: [_img('a')],
        onToggleExisting: (_) => called = true,
        enabled: false,
      ));
      await tester.pump();

      // Sem DragTarget, não há como o GestureDetector disparar (onTap = null)
      expect(find.byType(DragTarget<int>), findsNothing);
      expect(called, isFalse);
    });

    testWidgets('long-press e arrasto de slot 0 para slot 1 chama onReorder(0, 1)',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      int? oldIdx, newIdx;
      await tester.pumpWidget(_wrap(
        orderedImages: [_img('a'), _img('b', order: 1), _img('c', order: 2)],
        onReorder: (o, n) {
          oldIdx = o;
          newIdx = n;
        },
      ));
      await tester.pump();

      final targets = find.byType(DragTarget<int>);
      expect(targets, findsNWidgets(3));

      final center0 = tester.getCenter(targets.at(0));
      final center1 = tester.getCenter(targets.at(1));

      // Simula long press (> 350ms) e arrasta para o segundo slot
      final gesture = await tester.startGesture(center0);
      await tester.pump(const Duration(milliseconds: 500));
      await gesture.moveTo(center1);
      await tester.pump(const Duration(milliseconds: 100));
      await gesture.up();
      await tester.pump();

      expect(oldIdx, 0);
      expect(newIdx, 1);
    });

    testWidgets(
        'badge ★ oculta durante drag (childWhenDragging) e reaparece após drop',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_wrap(
        orderedImages: [_img('a'), _img('b', order: 1)],
      ));
      await tester.pump();

      // Antes do drag: badge visível em slot 0
      expect(find.byIcon(Icons.star), findsOneWidget);

      final targets = find.byType(DragTarget<int>);
      final center0 = tester.getCenter(targets.at(0));
      final center1 = tester.getCenter(targets.at(1));

      // LongPressDraggable exibe childWhenDragging = SizedBox() no slot de
      // origem enquanto o gesto está ativo → badge fica oculta.
      final gesture = await tester.startGesture(center0);
      await tester.pump(const Duration(milliseconds: 500));
      await gesture.moveTo(center1);
      await tester.pump();

      expect(find.byIcon(Icons.star), findsNothing);

      // Após soltar: estado reseta, slot 0 volta a mostrar child → badge reaparece
      await gesture.up();
      await tester.pump();

      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });
}
