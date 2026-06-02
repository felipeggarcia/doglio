/// Orders Riverpod providers
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/order.dart';
import '../../data/datasources/orders_remote_datasource.dart';
import '../../data/repositories/orders_repository_impl.dart';
import '../../domain/usecases/get_orders_use_case.dart';

final ordersProvider =
    AsyncNotifierProvider<OrdersNotifier, List<Order>>(
  OrdersNotifier.new,
);

class OrdersNotifier extends AsyncNotifier<List<Order>> {
  late final GetOrdersUseCase _getOrders;

  @override
  Future<List<Order>> build() async {
    final repo = OrdersRepositoryImpl(OrdersRemoteDatasource());
    _getOrders = GetOrdersUseCase(repo);
    return _load();
  }

  Future<List<Order>> _load() async {
    final result = await _getOrders();
    return result.fold(
      (failure) => throw Exception(failure.userMessage),
      (orders) => orders,
    );
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }
}

final orderDetailProvider =
    FutureProvider.family<Order, String>((ref, orderId) async {
  final repo = OrdersRepositoryImpl(OrdersRemoteDatasource());
  final useCase = GetOrderDetailUseCase(repo);
  final result = await useCase(orderId);
  return result.fold(
    (failure) => throw Exception(failure.userMessage),
    (order) => order,
  );
});
