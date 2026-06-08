library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/checkout_result.dart';
import '../repositories/checkout_repository.dart';

class PlaceOrderParams {
  const PlaceOrderParams({
    required this.paymentMethodId,
    required this.deliveryType,
    this.addressId,
    this.shippingStreet,
    this.shippingNumber,
    this.shippingComplement,
    this.shippingDistrict,
    this.shippingCity,
    this.shippingState,
    this.shippingZipCode,
    // Cartão de crédito (todos opcionais — backend gera valores se omitidos)
    this.cardLastFour,
    this.cardBrand,
    this.installments,
  });

  final String paymentMethodId;
  final String deliveryType;
  // Endereço salvo (sem alteração)
  final String? addressId;
  // Endereço manual (novo ou com alterações)
  final String? shippingStreet;
  final String? shippingNumber;
  final String? shippingComplement;
  final String? shippingDistrict;
  final String? shippingCity;
  final String? shippingState;
  final String? shippingZipCode; // 8 dígitos sem hífen
  // Cartão de crédito
  final String? cardLastFour; // 4 dígitos
  final String? cardBrand;    // 'Visa', 'Mastercard', etc.
  final int? installments;    // 1–12
}

class PlaceOrderUseCase {
  const PlaceOrderUseCase(this._repository);
  final CheckoutRepository _repository;

  Future<Either<Failure, CheckoutResult>> call(PlaceOrderParams params) =>
      _repository.placeOrder(
        paymentMethodId: params.paymentMethodId,
        deliveryType: params.deliveryType,
        addressId: params.addressId,
        shippingStreet: params.shippingStreet,
        shippingNumber: params.shippingNumber,
        shippingComplement: params.shippingComplement,
        shippingDistrict: params.shippingDistrict,
        shippingCity: params.shippingCity,
        shippingState: params.shippingState,
        shippingZipCode: params.shippingZipCode,
        cardLastFour: params.cardLastFour,
        cardBrand: params.cardBrand,
        installments: params.installments,
      );
}
