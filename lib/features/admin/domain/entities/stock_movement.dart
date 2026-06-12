/// Movimentação de estoque de um produto (histórico e ajustes).
library;

enum StockMovementType {
  stockIn,
  stockOut;

  String toApi() => this == StockMovementType.stockIn ? 'in' : 'out';

  static StockMovementType fromApi(String? value) =>
      value == 'out' ? StockMovementType.stockOut : StockMovementType.stockIn;
}

// `return` é palavra reservada em Dart, daí `productReturn`.
enum StockMovementReason {
  purchase,
  productReturn,
  manualAdjustment,
  loss;

  String toApi() => switch (this) {
        StockMovementReason.purchase => 'purchase',
        StockMovementReason.productReturn => 'return',
        StockMovementReason.manualAdjustment => 'manual_adjustment',
        StockMovementReason.loss => 'loss',
      };

  static StockMovementReason fromApi(String? value) => switch (value) {
        'purchase' => StockMovementReason.purchase,
        'return' => StockMovementReason.productReturn,
        'loss' => StockMovementReason.loss,
        _ => StockMovementReason.manualAdjustment,
      };
}

class StockMovement {
  const StockMovement({
    required this.id,
    required this.type,
    required this.quantity,
    required this.stockBefore,
    required this.stockAfter,
    required this.reason,
    this.notes,
    this.reference,
    this.performedBy,
    this.createdAt,
  });

  final String id;
  final StockMovementType type;
  final int quantity;
  final int stockBefore;
  final int stockAfter;
  final StockMovementReason reason;
  final String? notes;
  final String? reference;
  final String? performedBy;
  final String? createdAt;
}
