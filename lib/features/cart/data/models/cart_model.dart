library;

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../store/data/models/product_model.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';

part 'cart_model.freezed.dart';
part 'cart_model.g.dart';

String _priceFromJson(dynamic value) => value?.toString() ?? '0.00';
String? _nullablePriceFromJson(dynamic value) => value?.toString();

@freezed
abstract class CartItemModel with _$CartItemModel {
  const CartItemModel._();

  const factory CartItemModel({
    @JsonKey(name: 'product_id') required String productId,
    required ProductModel product,
    required int quantity,
    @JsonKey(name: 'unit_price', fromJson: _priceFromJson) required String unitPrice,
    @JsonKey(name: 'effective_unit_price', fromJson: _nullablePriceFromJson)
    String? effectiveUnitPrice,
    @JsonKey(name: 'subtotal', fromJson: _priceFromJson) required String subtotal,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  CartItem toEntity() => CartItem(
        productId: productId,
        product: product.toEntity(),
        quantity: quantity,
        unitPrice: unitPrice,
        effectiveUnitPrice: effectiveUnitPrice,
        subtotal: subtotal,
      );
}

@freezed
abstract class CartModel with _$CartModel {
  const CartModel._();

  const factory CartModel({
    @JsonKey(defaultValue: []) required List<CartItemModel> items,
    @JsonKey(fromJson: _priceFromJson) required String total,
    @JsonKey(name: 'has_stock_warning', defaultValue: false)
    required bool hasStockWarning,
    @JsonKey(name: 'has_price_change', defaultValue: false)
    required bool hasPriceChange,
  }) = _CartModel;

  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);

  Cart toEntity() => Cart(
        items: items.map((i) => i.toEntity()).toList(),
        total: total,
        hasStockWarning: hasStockWarning,
        hasPriceChange: hasPriceChange,
      );
}
