library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/checkout_remote_datasource.dart';
import '../../data/repositories/checkout_repository_impl.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/usecases/get_payment_methods_use_case.dart';

/// Carrega os métodos de pagamento uma vez e cacheia o resultado.
/// Buscar na inicialização da CheckoutPage garante que o ID do PIX
/// esteja disponível sem latência no momento do checkout.
final paymentMethodsProvider = FutureProvider<List<PaymentMethod>>((ref) async {
  final repo = CheckoutRepositoryImpl(CheckoutRemoteDatasource());
  final useCase = GetPaymentMethodsUseCase(repo);
  final result = await useCase();
  return result.fold(
    (failure) => throw Exception(failure.userMessage),
    (methods) => methods,
  );
});
