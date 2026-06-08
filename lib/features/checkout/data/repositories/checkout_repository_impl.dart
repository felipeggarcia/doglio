library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/checkout_result.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../datasources/checkout_remote_datasource.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  const CheckoutRepositoryImpl(this._datasource);
  final CheckoutRemoteDatasource _datasource;

  @override
  Future<Either<Failure, List<PaymentMethod>>> getPaymentMethods() async {
    try {
      final methods = await _datasource.getPaymentMethods();
      return Right(methods);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> validateCart() async {
    try {
      final isValid = await _datasource.validateCart();
      return Right(isValid);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final result = await _datasource.placeOrder(
        paymentMethodId: paymentMethodId,
        deliveryType: deliveryType,
        addressId: addressId,
        shippingStreet: shippingStreet,
        shippingNumber: shippingNumber,
        shippingComplement: shippingComplement,
        shippingDistrict: shippingDistrict,
        shippingCity: shippingCity,
        shippingState: shippingState,
        shippingZipCode: shippingZipCode,
        cardLastFour: cardLastFour,
        cardBrand: cardBrand,
        installments: installments,
      );
      return Right(result);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
