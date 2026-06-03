library;

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/order.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

OrderStatus _orderStatusFromJson(String value) =>
    switch (value.toLowerCase()) {
      'processing' => OrderStatus.processing,
      'shipped' => OrderStatus.shipped,
      'delivered' => OrderStatus.delivered,
      'cancelled' => OrderStatus.cancelled,
      _ => OrderStatus.pending,
    };

String _orderStatusToJson(OrderStatus status) =>
    switch (status) {
      OrderStatus.pending => 'pending',
      OrderStatus.processing => 'processing',
      OrderStatus.shipped => 'shipped',
      OrderStatus.delivered => 'delivered',
      OrderStatus.cancelled => 'cancelled',
    };

@freezed
abstract class OrderItemModel with _$OrderItemModel {
  const OrderItemModel._();

  const factory OrderItemModel({
    required String id,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'product_name') required String productName,
    required String price,
    required int quantity,
    @JsonKey(name: 'product_image') String? productImage,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  OrderItem toEntity() => OrderItem(
        id: id,
        productId: productId,
        productName: productName,
        price: price,
        quantity: quantity,
        productImage: productImage,
      );
}

@freezed
abstract class OrderModel with _$OrderModel {
  const OrderModel._();

  const factory OrderModel({
    required String id,
    @JsonKey(fromJson: _orderStatusFromJson, toJson: _orderStatusToJson)
    required OrderStatus status,
    @JsonKey(defaultValue: []) required List<OrderItemModel> items,
    required String total,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'shipping_address') String? shippingAddress,
    @JsonKey(name: 'tracking_code') String? trackingCode,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Order toEntity() => Order(
        id: id,
        status: status,
        items: items.map((i) => i.toEntity()).toList(),
        total: total,
        createdAt: createdAt,
        updatedAt: updatedAt,
        shippingAddress: shippingAddress,
        trackingCode: trackingCode,
      );
}
