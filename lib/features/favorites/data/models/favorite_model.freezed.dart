// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FavoriteModel {

 String get id; ProductModel get product;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'notify_on_restock', defaultValue: false) bool get notifyOnRestock;
/// Create a copy of FavoriteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteModelCopyWith<FavoriteModel> get copyWith => _$FavoriteModelCopyWithImpl<FavoriteModel>(this as FavoriteModel, _$identity);

  /// Serializes this FavoriteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteModel&&(identical(other.id, id) || other.id == id)&&(identical(other.product, product) || other.product == product)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.notifyOnRestock, notifyOnRestock) || other.notifyOnRestock == notifyOnRestock));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,product,createdAt,notifyOnRestock);

@override
String toString() {
  return 'FavoriteModel(id: $id, product: $product, createdAt: $createdAt, notifyOnRestock: $notifyOnRestock)';
}


}

/// @nodoc
abstract mixin class $FavoriteModelCopyWith<$Res>  {
  factory $FavoriteModelCopyWith(FavoriteModel value, $Res Function(FavoriteModel) _then) = _$FavoriteModelCopyWithImpl;
@useResult
$Res call({
 String id, ProductModel product,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'notify_on_restock', defaultValue: false) bool notifyOnRestock
});


$ProductModelCopyWith<$Res> get product;

}
/// @nodoc
class _$FavoriteModelCopyWithImpl<$Res>
    implements $FavoriteModelCopyWith<$Res> {
  _$FavoriteModelCopyWithImpl(this._self, this._then);

  final FavoriteModel _self;
  final $Res Function(FavoriteModel) _then;

/// Create a copy of FavoriteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? product = null,Object? createdAt = null,Object? notifyOnRestock = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductModel,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,notifyOnRestock: null == notifyOnRestock ? _self.notifyOnRestock : notifyOnRestock // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of FavoriteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductModelCopyWith<$Res> get product {
  
  return $ProductModelCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}


/// Adds pattern-matching-related methods to [FavoriteModel].
extension FavoriteModelPatterns on FavoriteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FavoriteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FavoriteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FavoriteModel value)  $default,){
final _that = this;
switch (_that) {
case _FavoriteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FavoriteModel value)?  $default,){
final _that = this;
switch (_that) {
case _FavoriteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ProductModel product, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'notify_on_restock', defaultValue: false)  bool notifyOnRestock)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FavoriteModel() when $default != null:
return $default(_that.id,_that.product,_that.createdAt,_that.notifyOnRestock);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ProductModel product, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'notify_on_restock', defaultValue: false)  bool notifyOnRestock)  $default,) {final _that = this;
switch (_that) {
case _FavoriteModel():
return $default(_that.id,_that.product,_that.createdAt,_that.notifyOnRestock);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ProductModel product, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'notify_on_restock', defaultValue: false)  bool notifyOnRestock)?  $default,) {final _that = this;
switch (_that) {
case _FavoriteModel() when $default != null:
return $default(_that.id,_that.product,_that.createdAt,_that.notifyOnRestock);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FavoriteModel extends FavoriteModel {
  const _FavoriteModel({required this.id, required this.product, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'notify_on_restock', defaultValue: false) required this.notifyOnRestock}): super._();
  factory _FavoriteModel.fromJson(Map<String, dynamic> json) => _$FavoriteModelFromJson(json);

@override final  String id;
@override final  ProductModel product;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'notify_on_restock', defaultValue: false) final  bool notifyOnRestock;

/// Create a copy of FavoriteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavoriteModelCopyWith<_FavoriteModel> get copyWith => __$FavoriteModelCopyWithImpl<_FavoriteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FavoriteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FavoriteModel&&(identical(other.id, id) || other.id == id)&&(identical(other.product, product) || other.product == product)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.notifyOnRestock, notifyOnRestock) || other.notifyOnRestock == notifyOnRestock));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,product,createdAt,notifyOnRestock);

@override
String toString() {
  return 'FavoriteModel(id: $id, product: $product, createdAt: $createdAt, notifyOnRestock: $notifyOnRestock)';
}


}

/// @nodoc
abstract mixin class _$FavoriteModelCopyWith<$Res> implements $FavoriteModelCopyWith<$Res> {
  factory _$FavoriteModelCopyWith(_FavoriteModel value, $Res Function(_FavoriteModel) _then) = __$FavoriteModelCopyWithImpl;
@override @useResult
$Res call({
 String id, ProductModel product,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'notify_on_restock', defaultValue: false) bool notifyOnRestock
});


@override $ProductModelCopyWith<$Res> get product;

}
/// @nodoc
class __$FavoriteModelCopyWithImpl<$Res>
    implements _$FavoriteModelCopyWith<$Res> {
  __$FavoriteModelCopyWithImpl(this._self, this._then);

  final _FavoriteModel _self;
  final $Res Function(_FavoriteModel) _then;

/// Create a copy of FavoriteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? product = null,Object? createdAt = null,Object? notifyOnRestock = null,}) {
  return _then(_FavoriteModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductModel,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,notifyOnRestock: null == notifyOnRestock ? _self.notifyOnRestock : notifyOnRestock // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of FavoriteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductModelCopyWith<$Res> get product {
  
  return $ProductModelCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}

// dart format on
