library;

/// Status do pedido no painel admin.
/// Difere do [OrderStatus] da loja (processing/shipped → confirmed/out_for_delivery).
enum AdminOrderStatus {
  pending,
  confirmed,
  preparing,
  outForDelivery,
  delivered,
  cancelled;

  String toApi() => switch (this) {
        AdminOrderStatus.pending => 'pending',
        AdminOrderStatus.confirmed => 'confirmed',
        AdminOrderStatus.preparing => 'preparing',
        AdminOrderStatus.outForDelivery => 'out_for_delivery',
        AdminOrderStatus.delivered => 'delivered',
        AdminOrderStatus.cancelled => 'cancelled',
      };

  static AdminOrderStatus fromApi(String value) => switch (value) {
        'confirmed' => AdminOrderStatus.confirmed,
        'preparing' => AdminOrderStatus.preparing,
        'out_for_delivery' => AdminOrderStatus.outForDelivery,
        'delivered' => AdminOrderStatus.delivered,
        'cancelled' => AdminOrderStatus.cancelled,
        _ => AdminOrderStatus.pending,
      };

  /// Pedidos entregues ou cancelados não permitem mais mutações.
  bool get isFinal => this == delivered || this == cancelled;

  /// Próximos status válidos para transição a partir deste.
  List<AdminOrderStatus> get nextAllowed => switch (this) {
        AdminOrderStatus.pending => [confirmed, cancelled],
        AdminOrderStatus.confirmed => [preparing, cancelled],
        AdminOrderStatus.preparing => [outForDelivery, cancelled],
        AdminOrderStatus.outForDelivery => [delivered, cancelled],
        _ => [],
      };
}

class AdminOrderCustomer {
  const AdminOrderCustomer({
    required this.id,
    required this.name,
    required this.email,
  });

  final String id;
  final String name;
  final String email;
}

class AdminOrderItem {
  const AdminOrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    required this.subtotal,
    this.productImageUrl,
  });

  final String id;
  final String productId;
  final String productName;
  final String unitPrice;
  final int quantity;
  final String subtotal;
  final String? productImageUrl;
}

class AdminOrderShippingAddress {
  const AdminOrderShippingAddress({
    required this.street,
    required this.number,
    this.complement,
    required this.district,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  final String street;
  final String number;
  final String? complement;
  final String district;
  final String city;
  final String state;
  final String zipCode;

  String get formatted {
    final parts = [
      '$street, $number',
      if (complement != null && complement!.isNotEmpty) complement!,
      district,
      '$city - $state',
      zipCode,
    ];
    return parts.join(', ');
  }
}

class AdminOrderPaymentInfo {
  const AdminOrderPaymentInfo({
    required this.status,
    this.amount,
    this.paymentMethodName,
    this.paymentMethodType,
    this.pixCode,
    this.pixExpiresAt,
  });

  final String status; // 'pending' | 'paid' | 'approved'
  final String? amount;
  final String? paymentMethodName;
  final String? paymentMethodType; // 'pix' | 'boleto' | 'credit_card'
  final String? pixCode;
  final DateTime? pixExpiresAt;

  bool get isPix => paymentMethodType == 'pix';
}

class AdminOrderStatusEntry {
  const AdminOrderStatusEntry({
    required this.status,
    required this.createdAt,
    this.notes,
  });

  final AdminOrderStatus status;
  final String? notes;
  final DateTime createdAt;
}

class AdminOrder {
  const AdminOrder({
    required this.id,
    this.orderNumber,
    required this.status,
    required this.totalAmount,
    this.discountAmount,
    required this.deliveryType,
    required this.customer,
    required this.items,
    this.shippingAddress,
    this.payment,
    this.statusHistory = const [],
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String? orderNumber;
  final AdminOrderStatus status;
  final String totalAmount;
  final String? discountAmount;
  final String deliveryType; // 'delivery' | 'pickup'
  final AdminOrderCustomer customer;
  final List<AdminOrderItem> items;
  final AdminOrderShippingAddress? shippingAddress;
  final AdminOrderPaymentInfo? payment;
  final List<AdminOrderStatusEntry> statusHistory;
  final DateTime createdAt;
  final DateTime? updatedAt;

  bool get isDelivery => deliveryType == 'delivery';

  bool get hasDiscount {
    if (discountAmount == null) return false;
    final v = double.tryParse(discountAmount!) ?? 0;
    return v > 0;
  }

  AdminOrder copyWith({
    String? id,
    String? orderNumber,
    AdminOrderStatus? status,
    String? totalAmount,
    String? discountAmount,
    String? deliveryType,
    AdminOrderCustomer? customer,
    List<AdminOrderItem>? items,
    AdminOrderShippingAddress? shippingAddress,
    AdminOrderPaymentInfo? payment,
    List<AdminOrderStatusEntry>? statusHistory,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      AdminOrder(
        id: id ?? this.id,
        orderNumber: orderNumber ?? this.orderNumber,
        status: status ?? this.status,
        totalAmount: totalAmount ?? this.totalAmount,
        discountAmount: discountAmount ?? this.discountAmount,
        deliveryType: deliveryType ?? this.deliveryType,
        customer: customer ?? this.customer,
        items: items ?? this.items,
        shippingAddress: shippingAddress ?? this.shippingAddress,
        payment: payment ?? this.payment,
        statusHistory: statusHistory ?? this.statusHistory,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  bool operator ==(Object other) => other is AdminOrder && other.id == id;
  @override
  int get hashCode => id.hashCode;
}
