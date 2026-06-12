library;

import '../../domain/entities/admin_order.dart';

class AdminOrderModel {
  const AdminOrderModel({
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
    required this.statusHistory,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String? orderNumber;
  final AdminOrderStatus status;
  final String totalAmount;
  final String? discountAmount;
  final String deliveryType;
  final AdminOrderCustomer customer;
  final List<AdminOrderItem> items;
  final AdminOrderShippingAddress? shippingAddress;
  final AdminOrderPaymentInfo? payment;
  final List<AdminOrderStatusEntry> statusHistory;
  final DateTime createdAt;
  final DateTime? updatedAt;

  factory AdminOrderModel.fromJson(Map<String, dynamic> json) {
    final customerMap = (json['customer'] as Map<String, dynamic>?) ?? {};
    final addressMap = json['shipping_address'] as Map<String, dynamic>?;
    final paymentMap = json['payment'] as Map<String, dynamic>?;
    final itemsList = json['items'] as List<dynamic>? ?? const [];
    final historyList = json['status_history'] as List<dynamic>? ?? const [];

    return AdminOrderModel(
      id: (json['id'] ?? '').toString(),
      orderNumber: json['order_number']?.toString(),
      status: AdminOrderStatus.fromApi((json['status'] ?? '').toString()),
      totalAmount: (json['total_amount'] ?? '0.00').toString(),
      discountAmount: json['discount_amount']?.toString(),
      deliveryType: (json['delivery_type'] ?? 'delivery').toString(),
      customer: AdminOrderCustomer(
        id: (customerMap['id'] ?? '').toString(),
        name: (customerMap['name'] ?? '').toString(),
        email: (customerMap['email'] ?? '').toString(),
      ),
      items: itemsList
          .cast<Map<String, dynamic>>()
          .map(_parseItem)
          .toList(),
      shippingAddress:
          addressMap != null ? _parseAddress(addressMap) : null,
      payment: paymentMap != null ? _parsePayment(paymentMap) : null,
      statusHistory: historyList
          .cast<Map<String, dynamic>>()
          .map(_parseStatusEntry)
          .toList(),
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
              DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  AdminOrder toEntity() => AdminOrder(
        id: id,
        orderNumber: orderNumber,
        status: status,
        totalAmount: totalAmount,
        discountAmount: discountAmount,
        deliveryType: deliveryType,
        customer: customer,
        items: items,
        shippingAddress: shippingAddress,
        payment: payment,
        statusHistory: statusHistory,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  // ─── Parsing helpers ────────────────────────────────────────────────────────

  static AdminOrderItem _parseItem(Map<String, dynamic> json) {
    final product = json['product'] as Map<String, dynamic>? ?? {};
    final primaryImage =
        product['primary_image'] as Map<String, dynamic>?;
    return AdminOrderItem(
      id: (json['id'] ?? '').toString(),
      productId: (product['id'] ?? '').toString(),
      productName: (product['name'] ?? '').toString(),
      unitPrice: (json['unit_price'] ?? '0.00').toString(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      subtotal: (json['subtotal'] ?? '0.00').toString(),
      productImageUrl: primaryImage?['url']?.toString(),
    );
  }

  static AdminOrderShippingAddress _parseAddress(
      Map<String, dynamic> json) =>
      AdminOrderShippingAddress(
        street: (json['street'] ?? '').toString(),
        number: (json['number'] ?? '').toString(),
        complement: json['complement']?.toString(),
        district: (json['district'] ?? '').toString(),
        city: (json['city'] ?? '').toString(),
        state: (json['state'] ?? '').toString(),
        zipCode: (json['zip_code'] ?? '').toString(),
      );

  static AdminOrderPaymentInfo _parsePayment(Map<String, dynamic> json) {
    final method = json['payment_method'] as Map<String, dynamic>?;
    return AdminOrderPaymentInfo(
      status: (json['status'] ?? 'pending').toString(),
      amount: json['amount']?.toString(),
      paymentMethodName: method?['name']?.toString(),
      paymentMethodType: method?['type']?.toString(),
      pixCode: json['pix_code']?.toString(),
      pixExpiresAt: json['pix_expires_at'] != null
          ? DateTime.tryParse(json['pix_expires_at'].toString())
          : null,
    );
  }

  static AdminOrderStatusEntry _parseStatusEntry(
          Map<String, dynamic> json) =>
      AdminOrderStatusEntry(
        status:
            AdminOrderStatus.fromApi((json['status'] ?? '').toString()),
        notes: json['notes']?.toString(),
        createdAt:
            DateTime.tryParse(json['created_at']?.toString() ?? '') ??
                DateTime.now(),
      );
}
