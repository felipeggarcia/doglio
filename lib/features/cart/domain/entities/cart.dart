library;

import 'cart_item.dart';

class Cart {
  const Cart({
    this.items = const [],
    this.total = '0.00',
    this.hasStockWarning = false,
    this.hasPriceChange = false,
  });

  final List<CartItem> items;
  final String total;
  final bool hasStockWarning;
  final bool hasPriceChange;

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => items.isEmpty;

  static const empty = Cart();
}
