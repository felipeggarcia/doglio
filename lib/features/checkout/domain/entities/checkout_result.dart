library;

import 'payment.dart';

class CheckoutResult {
  const CheckoutResult({
    required this.orderId,
    required this.orderTotal,
    this.orderNumber,
    this.payment,
  });

  final String orderId;
  final String orderTotal;
  final String? orderNumber; // ex: "00001"
  final Payment? payment;

  String get displayId => orderNumber ?? orderId;
}
