/// Order data model
library;

import '../../domain/entities/order.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.id,
    required super.productId,
    required super.productName,
    required super.price,
    required super.quantity,
    super.productImage,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      price: json['price'] as String,
      quantity: json['quantity'] as int,
      productImage: json['product_image'] as String?,
    );
  }
}

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.status,
    required super.items,
    required super.total,
    required super.createdAt,
    super.updatedAt,
    super.shippingAddress,
    super.trackingCode,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final itemsList = (json['items'] as List<dynamic>?)
            ?.cast<Map<String, dynamic>>()
            .map(OrderItemModel.fromJson)
            .toList() ??
        [];

    return OrderModel(
      id: json['id'] as String,
      status: _parseStatus(json['status'] as String? ?? 'pending'),
      items: itemsList,
      total: json['total'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      shippingAddress: json['shipping_address'] as String?,
      trackingCode: json['tracking_code'] as String?,
    );
  }

  static OrderStatus _parseStatus(String value) =>
      switch (value.toLowerCase()) {
        'processing' => OrderStatus.processing,
        'shipped' => OrderStatus.shipped,
        'delivered' => OrderStatus.delivered,
        'cancelled' => OrderStatus.cancelled,
        _ => OrderStatus.pending,
      };
}
