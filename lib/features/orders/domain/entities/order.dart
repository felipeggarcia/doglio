/// Order domain entity
library;

enum OrderStatus { pending, processing, shipped, delivered, cancelled }

class StatusHistoryEntry {
  const StatusHistoryEntry({
    required this.status,
    required this.occurredAt,
  });

  final OrderStatus status;
  final DateTime occurredAt;
}

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

class OrderPayment {
  const OrderPayment({
    required this.type,
    required this.status,
    this.amount,
    this.pixCode,
    this.pixQrCode,
    this.pixExpiresAt,
    this.boletoCode,
    this.boletoExpiresAt,
    this.cardLastFour,
    this.cardBrand,
    this.installments,
  });

  final String type;   // 'pix' | 'boleto' | 'credit_card'
  final String status; // 'pending' | 'paid' | 'approved'
  final String? amount;
  final String? pixCode;
  final String? pixQrCode; // base64 PNG
  final DateTime? pixExpiresAt;
  final String? boletoCode;
  final DateTime? boletoExpiresAt;
  final String? cardLastFour;
  final String? cardBrand;
  final int? installments;

  bool get isPix => type == 'pix';
  bool get isBoleto => type == 'boleto';
  bool get isCreditCard => type == 'credit_card';
}

class Order {
  const Order({
    required this.id,
    required this.status,
    required this.items,
    required this.total,
    required this.createdAt,
    this.orderNumber,
    this.updatedAt,
    this.shippingAddress,
    this.trackingCode,
    this.statusHistory = const [],
    this.payment,
  });

  final String id;
  final String? orderNumber; // ex: "00001" — usar para exibição
  final OrderStatus status;
  final List<OrderItem> items;
  final String total;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? shippingAddress;
  final String? trackingCode;
  final List<StatusHistoryEntry> statusHistory;
  final OrderPayment? payment;

  @override
  bool operator ==(Object other) => other is Order && other.id == id;
  @override
  int get hashCode => id.hashCode;
}
