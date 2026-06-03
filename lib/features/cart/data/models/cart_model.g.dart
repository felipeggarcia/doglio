// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    _CartItemModel(
      productId: json['product_id'] as String,
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: _priceFromJson(json['unit_price']),
      effectiveUnitPrice: _nullablePriceFromJson(json['effective_unit_price']),
      subtotal: _priceFromJson(json['subtotal']),
    );

Map<String, dynamic> _$CartItemModelToJson(_CartItemModel instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'product': instance.product,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
      'effective_unit_price': instance.effectiveUnitPrice,
      'subtotal': instance.subtotal,
    };

_CartModel _$CartModelFromJson(Map<String, dynamic> json) => _CartModel(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  total: _priceFromJson(json['total']),
  hasStockWarning: json['has_stock_warning'] as bool? ?? false,
  hasPriceChange: json['has_price_change'] as bool? ?? false,
);

Map<String, dynamic> _$CartModelToJson(_CartModel instance) =>
    <String, dynamic>{
      'items': instance.items,
      'total': instance.total,
      'has_stock_warning': instance.hasStockWarning,
      'has_price_change': instance.hasPriceChange,
    };
