library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/payment_method.dart';
import '../repositories/checkout_repository.dart';

class GetPaymentMethodsUseCase {
  const GetPaymentMethodsUseCase(this._repository);
  final CheckoutRepository _repository;

  Future<Either<Failure, List<PaymentMethod>>> call() =>
      _repository.getPaymentMethods();
}
