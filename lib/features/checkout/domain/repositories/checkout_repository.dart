library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/checkout_result.dart';
import '../entities/payment_method.dart';

abstract interface class CheckoutRepository {
  Future<Either<Failure, List<PaymentMethod>>> getPaymentMethods();

  /// Retorna `true` se o carrinho está válido, `false` se há mudanças.
  Future<Either<Failure, bool>> validateCart();

  Future<Either<Failure, CheckoutResult>> placeOrder({
    required String paymentMethodId,
    required String deliveryType,
    String? addressId,
    String? shippingStreet,
    String? shippingNumber,
    String? shippingComplement,
    String? shippingDistrict,
    String? shippingCity,
    String? shippingState,
    String? shippingZipCode,
    String? cardLastFour,
    String? cardBrand,
    int? installments,
  });
}
