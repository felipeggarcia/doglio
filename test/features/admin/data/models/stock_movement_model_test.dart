import 'package:flutter_test/flutter_test.dart';
import 'package:doglio/features/admin/data/models/stock_movement_model.dart';
import 'package:doglio/features/admin/domain/entities/stock_movement.dart';

void main() {
  group('StockMovementModel.fromJson', () {
    test('parseia todos os campos', () {
      final model = StockMovementModel.fromJson({
        'id': 'm1',
        'type': 'out',
        'quantity': 3,
        'stock_before': 10,
        'stock_after': 7,
        'reason': 'loss',
        'notes': 'avaria',
        'reference': 'ref-1',
        'performed_by': {'id': 'u1', 'name': 'Admin'},
        'created_at': '2026-06-01T10:00:00',
      });

      expect(model.id, 'm1');
      expect(model.type, StockMovementType.stockOut);
      expect(model.quantity, 3);
      expect(model.stockBefore, 10);
      expect(model.stockAfter, 7);
      expect(model.reason, StockMovementReason.loss);
      expect(model.notes, 'avaria');
      expect(model.reference, 'ref-1');
      expect(model.performedBy, 'Admin');
      expect(model.createdAt, '2026-06-01T10:00:00');
    });

    test('performed_by como string simples', () {
      final model = StockMovementModel.fromJson({
        'id': 'm1',
        'performed_by': 'Admin',
      });
      expect(model.performedBy, 'Admin');
    });

    test('enums desconhecidos caem no fallback', () {
      final model = StockMovementModel.fromJson({
        'id': 'm1',
        'type': 'whatever',
        'reason': 'whatever',
      });
      expect(model.type, StockMovementType.stockIn);
      expect(model.reason, StockMovementReason.manualAdjustment);
    });

    test('campos ausentes assumem defaults', () {
      final model = StockMovementModel.fromJson(const {});
      expect(model.id, '');
      expect(model.quantity, 0);
      expect(model.stockBefore, 0);
      expect(model.stockAfter, 0);
      expect(model.notes, isNull);
      expect(model.performedBy, isNull);
    });
  });

  group('enums toApi/fromApi', () {
    test('reason return mapeia para productReturn (palavra reservada)', () {
      expect(StockMovementReason.productReturn.toApi(), 'return');
      expect(StockMovementReason.fromApi('return'),
          StockMovementReason.productReturn);
    });

    test('type in/out', () {
      expect(StockMovementType.stockIn.toApi(), 'in');
      expect(StockMovementType.stockOut.toApi(), 'out');
      expect(StockMovementType.fromApi('out'), StockMovementType.stockOut);
      expect(StockMovementType.fromApi('in'), StockMovementType.stockIn);
    });
  });
}
