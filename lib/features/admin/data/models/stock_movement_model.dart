library;

import '../../domain/entities/stock_movement.dart';

class StockMovementModel {
  const StockMovementModel({
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

  factory StockMovementModel.fromJson(Map<String, dynamic> json) {
    return StockMovementModel(
      id: (json['id'] ?? '').toString(),
      type: StockMovementType.fromApi(json['type']?.toString()),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      stockBefore: (json['stock_before'] as num?)?.toInt() ?? 0,
      stockAfter: (json['stock_after'] as num?)?.toInt() ?? 0,
      reason: StockMovementReason.fromApi(json['reason']?.toString()),
      notes: json['notes']?.toString(),
      reference: json['reference']?.toString(),
      // `performed_by` pode vir como objeto de usuário ou string.
      performedBy: switch (json['performed_by']) {
        final Map<String, dynamic> user => user['name']?.toString(),
        final Object value => value.toString(),
        null => null,
      },
      createdAt: json['created_at']?.toString(),
    );
  }

  StockMovement toEntity() => StockMovement(
        id: id,
        type: type,
        quantity: quantity,
        stockBefore: stockBefore,
        stockAfter: stockAfter,
        reason: reason,
        notes: notes,
        reference: reference,
        performedBy: performedBy,
        createdAt: createdAt,
      );
}
