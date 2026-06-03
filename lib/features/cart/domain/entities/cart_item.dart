library;

import '../../../store/domain/entities/product.dart';

class CartItem {
  const CartItem({
    required this.productId,
    required this.product,
    required this.quantity,
    required this.unitPrice,
    this.effectiveUnitPrice,
    required this.subtotal,
  });

  final String productId;
  final Product product;
  final int quantity;
  final String unitPrice;
  final String? effectiveUnitPrice;
  final String subtotal;

  String get displayUnitPrice => effectiveUnitPrice ?? unitPrice;
  bool get hasPromotion => effectiveUnitPrice != null;
}
