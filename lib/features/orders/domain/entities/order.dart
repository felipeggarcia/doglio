/// Order domain entity
library;

enum OrderStatus { pending, processing, shipped, delivered, cancelled }

class OrderItem {
  const OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.productImage,
  });

  final String id;
  final String productId;
  final String productName;
  final String price;
  final int quantity;
  final String? productImage;
}

class Order {
  const Order({
    required this.id,
    required this.status,
    required this.items,
    required this.total,
    required this.createdAt,
    this.updatedAt,
    this.shippingAddress,
    this.trackingCode,
  });

  final String id;
  final OrderStatus status;
  final List<OrderItem> items;
  final String total;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? shippingAddress;
  final String? trackingCode;

  @override
  bool operator ==(Object other) => other is Order && other.id == id;
  @override
  int get hashCode => id.hashCode;
}
