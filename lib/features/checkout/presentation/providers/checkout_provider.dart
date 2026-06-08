library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/checkout_remote_datasource.dart';
import '../../data/repositories/checkout_repository_impl.dart';
import '../../domain/entities/checkout_result.dart';
import '../../domain/usecases/place_order_use_case.dart';
import '../../domain/usecases/validate_cart_use_case.dart';
import '../../../cart/presentation/providers/cart_provider.dart';

// ─── Estado ───────────────────────────────────────────────────────────────────

enum CheckoutStatus { idle, validating, placing, success, error }

class CheckoutState {
  const CheckoutState({
    this.status = CheckoutStatus.idle,
    this.errorMessage,
    this.result,
    this.cartHasChanges = false,
  });

  final CheckoutStatus status;
  final String? errorMessage;
  final CheckoutResult? result;
  final bool cartHasChanges;

  bool get isLoading =>
      status == CheckoutStatus.validating || status == CheckoutStatus.placing;

  bool get isSuccess => status == CheckoutStatus.success;

  CheckoutState copyWith({
    CheckoutStatus? status,
    Object? errorMessage = _sentinel,
    Object? result = _sentinel,
    bool? cartHasChanges,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      errorMessage:
          errorMessage == _sentinel ? this.errorMessage : errorMessage as String?,
      result: result == _sentinel ? this.result : result as CheckoutResult?,
      cartHasChanges: cartHasChanges ?? this.cartHasChanges,
    );
  }
}

const _sentinel = Object();

// ─── Notifier ─────────────────────────────────────────────────────────────────

class CheckoutNotifier extends Notifier<CheckoutState> {
  late final ValidateCartUseCase _validateCart;
  late final PlaceOrderUseCase _placeOrder;

  @override
  CheckoutState build() {
    final repo = CheckoutRepositoryImpl(CheckoutRemoteDatasource());
    _validateCart = ValidateCartUseCase(repo);
    _placeOrder = PlaceOrderUseCase(repo);
    return const CheckoutState();
  }

  Future<void> placeOrder({
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
    state = state.copyWith(
      status: CheckoutStatus.validating,
      errorMessage: null,
      cartHasChanges: false,
    );

    final validationResult = await _validateCart();
    final isValid = validationResult.fold(
      (_) => true,
      (valid) => valid,
    );

    if (!isValid) {
      state = state.copyWith(
        status: CheckoutStatus.idle,
        cartHasChanges: true,
      );
      return;
    }

    state = state.copyWith(status: CheckoutStatus.placing);

    final orderResult = await _placeOrder(
      PlaceOrderParams(
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
      ),
    );

    orderResult.fold(
      (failure) => state = state.copyWith(
        status: CheckoutStatus.error,
        errorMessage: failure.userMessage,
      ),
      (result) {
        ref.read(cartProvider.notifier).clear();
        state = state.copyWith(
          status: CheckoutStatus.success,
          result: result,
        );
      },
    );
  }

  void reset() => state = const CheckoutState();
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final checkoutProvider = NotifierProvider<CheckoutNotifier, CheckoutState>(
  CheckoutNotifier.new,
);
