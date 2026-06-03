// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CartItemModel {

@JsonKey(name: 'product_id') String get productId; ProductModel get product; int get quantity;@JsonKey(name: 'unit_price', fromJson: _priceFromJson) String get unitPrice;@JsonKey(name: 'effective_unit_price', fromJson: _nullablePriceFromJson) String? get effectiveUnitPrice;@JsonKey(name: 'subtotal', fromJson: _priceFromJson) String get subtotal;
/// Create a copy of CartItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartItemModelCopyWith<CartItemModel> get copyWith => _$CartItemModelCopyWithImpl<CartItemModel>(this as CartItemModel, _$identity);

  /// Serializes this CartItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartItemModel&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.product, product) || other.product == product)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.effectiveUnitPrice, effectiveUnitPrice) || other.effectiveUnitPrice == effectiveUnitPrice)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,product,quantity,unitPrice,effectiveUnitPrice,subtotal);

@override
String toString() {
  return 'CartItemModel(productId: $productId, product: $product, quantity: $quantity, unitPrice: $unitPrice, effectiveUnitPrice: $effectiveUnitPrice, subtotal: $subtotal)';
}


}

/// @nodoc
abstract mixin class $CartItemModelCopyWith<$Res>  {
  factory $CartItemModelCopyWith(CartItemModel value, $Res Function(CartItemModel) _then) = _$CartItemModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'product_id') String productId, ProductModel product, int quantity,@JsonKey(name: 'unit_price', fromJson: _priceFromJson) String unitPrice,@JsonKey(name: 'effective_unit_price', fromJson: _nullablePriceFromJson) String? effectiveUnitPrice,@JsonKey(name: 'subtotal', fromJson: _priceFromJson) String subtotal
});


$ProductModelCopyWith<$Res> get product;

}
/// @nodoc
class _$CartItemModelCopyWithImpl<$Res>
    implements $CartItemModelCopyWith<$Res> {
  _$CartItemModelCopyWithImpl(this._self, this._then);

  final CartItemModel _self;
  final $Res Function(CartItemModel) _then;

/// Create a copy of CartItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? product = null,Object? quantity = null,Object? unitPrice = null,Object? effectiveUnitPrice = freezed,Object? subtotal = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductModel,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,effectiveUnitPrice: freezed == effectiveUnitPrice ? _self.effectiveUnitPrice : effectiveUnitPrice // ignore: cast_nullable_to_non_nullable
as String?,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of CartItemModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductModelCopyWith<$Res> get product {
  
  return $ProductModelCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}


/// Adds pattern-matching-related methods to [CartItemModel].
extension CartItemModelPatterns on CartItemModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartItemModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartItemModel value)  $default,){
final _that = this;
switch (_that) {
case _CartItemModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _CartItemModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  String productId,  ProductModel product,  int quantity, @JsonKey(name: 'unit_price', fromJson: _priceFromJson)  String unitPrice, @JsonKey(name: 'effective_unit_price', fromJson: _nullablePriceFromJson)  String? effectiveUnitPrice, @JsonKey(name: 'subtotal', fromJson: _priceFromJson)  String subtotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartItemModel() when $default != null:
return $default(_that.productId,_that.product,_that.quantity,_that.unitPrice,_that.effectiveUnitPrice,_that.subtotal);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  String productId,  ProductModel product,  int quantity, @JsonKey(name: 'unit_price', fromJson: _priceFromJson)  String unitPrice, @JsonKey(name: 'effective_unit_price', fromJson: _nullablePriceFromJson)  String? effectiveUnitPrice, @JsonKey(name: 'subtotal', fromJson: _priceFromJson)  String subtotal)  $default,) {final _that = this;
switch (_that) {
case _CartItemModel():
return $default(_that.productId,_that.product,_that.quantity,_that.unitPrice,_that.effectiveUnitPrice,_that.subtotal);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'product_id')  String productId,  ProductModel product,  int quantity, @JsonKey(name: 'unit_price', fromJson: _priceFromJson)  String unitPrice, @JsonKey(name: 'effective_unit_price', fromJson: _nullablePriceFromJson)  String? effectiveUnitPrice, @JsonKey(name: 'subtotal', fromJson: _priceFromJson)  String subtotal)?  $default,) {final _that = this;
switch (_that) {
case _CartItemModel() when $default != null:
return $default(_that.productId,_that.product,_that.quantity,_that.unitPrice,_that.effectiveUnitPrice,_that.subtotal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CartItemModel extends CartItemModel {
  const _CartItemModel({@JsonKey(name: 'product_id') required this.productId, required this.product, required this.quantity, @JsonKey(name: 'unit_price', fromJson: _priceFromJson) required this.unitPrice, @JsonKey(name: 'effective_unit_price', fromJson: _nullablePriceFromJson) this.effectiveUnitPrice, @JsonKey(name: 'subtotal', fromJson: _priceFromJson) required this.subtotal}): super._();
  factory _CartItemModel.fromJson(Map<String, dynamic> json) => _$CartItemModelFromJson(json);

@override@JsonKey(name: 'product_id') final  String productId;
@override final  ProductModel product;
@override final  int quantity;
@override@JsonKey(name: 'unit_price', fromJson: _priceFromJson) final  String unitPrice;
@override@JsonKey(name: 'effective_unit_price', fromJson: _nullablePriceFromJson) final  String? effectiveUnitPrice;
@override@JsonKey(name: 'subtotal', fromJson: _priceFromJson) final  String subtotal;

/// Create a copy of CartItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartItemModelCopyWith<_CartItemModel> get copyWith => __$CartItemModelCopyWithImpl<_CartItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CartItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartItemModel&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.product, product) || other.product == product)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.effectiveUnitPrice, effectiveUnitPrice) || other.effectiveUnitPrice == effectiveUnitPrice)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,product,quantity,unitPrice,effectiveUnitPrice,subtotal);

@override
String toString() {
  return 'CartItemModel(productId: $productId, product: $product, quantity: $quantity, unitPrice: $unitPrice, effectiveUnitPrice: $effectiveUnitPrice, subtotal: $subtotal)';
}


}

/// @nodoc
abstract mixin class _$CartItemModelCopyWith<$Res> implements $CartItemModelCopyWith<$Res> {
  factory _$CartItemModelCopyWith(_CartItemModel value, $Res Function(_CartItemModel) _then) = __$CartItemModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'product_id') String productId, ProductModel product, int quantity,@JsonKey(name: 'unit_price', fromJson: _priceFromJson) String unitPrice,@JsonKey(name: 'effective_unit_price', fromJson: _nullablePriceFromJson) String? effectiveUnitPrice,@JsonKey(name: 'subtotal', fromJson: _priceFromJson) String subtotal
});


@override $ProductModelCopyWith<$Res> get product;

}
/// @nodoc
class __$CartItemModelCopyWithImpl<$Res>
    implements _$CartItemModelCopyWith<$Res> {
  __$CartItemModelCopyWithImpl(this._self, this._then);

  final _CartItemModel _self;
  final $Res Function(_CartItemModel) _then;

/// Create a copy of CartItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? product = null,Object? quantity = null,Object? unitPrice = null,Object? effectiveUnitPrice = freezed,Object? subtotal = null,}) {
  return _then(_CartItemModel(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductModel,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,effectiveUnitPrice: freezed == effectiveUnitPrice ? _self.effectiveUnitPrice : effectiveUnitPrice // ignore: cast_nullable_to_non_nullable
as String?,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of CartItemModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductModelCopyWith<$Res> get product {
  
  return $ProductModelCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}


/// @nodoc
mixin _$CartModel {

@JsonKey(defaultValue: []) List<CartItemModel> get items;@JsonKey(fromJson: _priceFromJson) String get total;@JsonKey(name: 'has_stock_warning', defaultValue: false) bool get hasStockWarning;@JsonKey(name: 'has_price_change', defaultValue: false) bool get hasPriceChange;
/// Create a copy of CartModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartModelCopyWith<CartModel> get copyWith => _$CartModelCopyWithImpl<CartModel>(this as CartModel, _$identity);

  /// Serializes this CartModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartModel&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.total, total) || other.total == total)&&(identical(other.hasStockWarning, hasStockWarning) || other.hasStockWarning == hasStockWarning)&&(identical(other.hasPriceChange, hasPriceChange) || other.hasPriceChange == hasPriceChange));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),total,hasStockWarning,hasPriceChange);

@override
String toString() {
  return 'CartModel(items: $items, total: $total, hasStockWarning: $hasStockWarning, hasPriceChange: $hasPriceChange)';
}


}

/// @nodoc
abstract mixin class $CartModelCopyWith<$Res>  {
  factory $CartModelCopyWith(CartModel value, $Res Function(CartModel) _then) = _$CartModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: []) List<CartItemModel> items,@JsonKey(fromJson: _priceFromJson) String total,@JsonKey(name: 'has_stock_warning', defaultValue: false) bool hasStockWarning,@JsonKey(name: 'has_price_change', defaultValue: false) bool hasPriceChange
});




}
/// @nodoc
class _$CartModelCopyWithImpl<$Res>
    implements $CartModelCopyWith<$Res> {
  _$CartModelCopyWithImpl(this._self, this._then);

  final CartModel _self;
  final $Res Function(CartModel) _then;

/// Create a copy of CartModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? total = null,Object? hasStockWarning = null,Object? hasPriceChange = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CartItemModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as String,hasStockWarning: null == hasStockWarning ? _self.hasStockWarning : hasStockWarning // ignore: cast_nullable_to_non_nullable
as bool,hasPriceChange: null == hasPriceChange ? _self.hasPriceChange : hasPriceChange // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CartModel].
extension CartModelPatterns on CartModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartModel value)  $default,){
final _that = this;
switch (_that) {
case _CartModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartModel value)?  $default,){
final _that = this;
switch (_that) {
case _CartModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: [])  List<CartItemModel> items, @JsonKey(fromJson: _priceFromJson)  String total, @JsonKey(name: 'has_stock_warning', defaultValue: false)  bool hasStockWarning, @JsonKey(name: 'has_price_change', defaultValue: false)  bool hasPriceChange)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartModel() when $default != null:
return $default(_that.items,_that.total,_that.hasStockWarning,_that.hasPriceChange);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: [])  List<CartItemModel> items, @JsonKey(fromJson: _priceFromJson)  String total, @JsonKey(name: 'has_stock_warning', defaultValue: false)  bool hasStockWarning, @JsonKey(name: 'has_price_change', defaultValue: false)  bool hasPriceChange)  $default,) {final _that = this;
switch (_that) {
case _CartModel():
return $default(_that.items,_that.total,_that.hasStockWarning,_that.hasPriceChange);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: [])  List<CartItemModel> items, @JsonKey(fromJson: _priceFromJson)  String total, @JsonKey(name: 'has_stock_warning', defaultValue: false)  bool hasStockWarning, @JsonKey(name: 'has_price_change', defaultValue: false)  bool hasPriceChange)?  $default,) {final _that = this;
switch (_that) {
case _CartModel() when $default != null:
return $default(_that.items,_that.total,_that.hasStockWarning,_that.hasPriceChange);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CartModel extends CartModel {
  const _CartModel({@JsonKey(defaultValue: []) required final  List<CartItemModel> items, @JsonKey(fromJson: _priceFromJson) required this.total, @JsonKey(name: 'has_stock_warning', defaultValue: false) required this.hasStockWarning, @JsonKey(name: 'has_price_change', defaultValue: false) required this.hasPriceChange}): _items = items,super._();
  factory _CartModel.fromJson(Map<String, dynamic> json) => _$CartModelFromJson(json);

 final  List<CartItemModel> _items;
@override@JsonKey(defaultValue: []) List<CartItemModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(fromJson: _priceFromJson) final  String total;
@override@JsonKey(name: 'has_stock_warning', defaultValue: false) final  bool hasStockWarning;
@override@JsonKey(name: 'has_price_change', defaultValue: false) final  bool hasPriceChange;

/// Create a copy of CartModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartModelCopyWith<_CartModel> get copyWith => __$CartModelCopyWithImpl<_CartModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CartModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartModel&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.hasStockWarning, hasStockWarning) || other.hasStockWarning == hasStockWarning)&&(identical(other.hasPriceChange, hasPriceChange) || other.hasPriceChange == hasPriceChange));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total,hasStockWarning,hasPriceChange);

@override
String toString() {
  return 'CartModel(items: $items, total: $total, hasStockWarning: $hasStockWarning, hasPriceChange: $hasPriceChange)';
}


}

/// @nodoc
abstract mixin class _$CartModelCopyWith<$Res> implements $CartModelCopyWith<$Res> {
  factory _$CartModelCopyWith(_CartModel value, $Res Function(_CartModel) _then) = __$CartModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: []) List<CartItemModel> items,@JsonKey(fromJson: _priceFromJson) String total,@JsonKey(name: 'has_stock_warning', defaultValue: false) bool hasStockWarning,@JsonKey(name: 'has_price_change', defaultValue: false) bool hasPriceChange
});




}
/// @nodoc
class __$CartModelCopyWithImpl<$Res>
    implements _$CartModelCopyWith<$Res> {
  __$CartModelCopyWithImpl(this._self, this._then);

  final _CartModel _self;
  final $Res Function(_CartModel) _then;

/// Create a copy of CartModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,Object? hasStockWarning = null,Object? hasPriceChange = null,}) {
  return _then(_CartModel(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CartItemModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as String,hasStockWarning: null == hasStockWarning ? _self.hasStockWarning : hasStockWarning // ignore: cast_nullable_to_non_nullable
as bool,hasPriceChange: null == hasPriceChange ? _self.hasPriceChange : hasPriceChange // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
