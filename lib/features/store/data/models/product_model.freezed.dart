// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductImageModel {

 String get id;@JsonKey(fromJson: _imagePathFromJson) String get imagePath;@JsonKey(defaultValue: 0) int get order;@JsonKey(name: 'is_primary', defaultValue: false) bool get isPrimary;
/// Create a copy of ProductImageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductImageModelCopyWith<ProductImageModel> get copyWith => _$ProductImageModelCopyWithImpl<ProductImageModel>(this as ProductImageModel, _$identity);

  /// Serializes this ProductImageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductImageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.order, order) || other.order == order)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,imagePath,order,isPrimary);

@override
String toString() {
  return 'ProductImageModel(id: $id, imagePath: $imagePath, order: $order, isPrimary: $isPrimary)';
}


}

/// @nodoc
abstract mixin class $ProductImageModelCopyWith<$Res>  {
  factory $ProductImageModelCopyWith(ProductImageModel value, $Res Function(ProductImageModel) _then) = _$ProductImageModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(fromJson: _imagePathFromJson) String imagePath,@JsonKey(defaultValue: 0) int order,@JsonKey(name: 'is_primary', defaultValue: false) bool isPrimary
});




}
/// @nodoc
class _$ProductImageModelCopyWithImpl<$Res>
    implements $ProductImageModelCopyWith<$Res> {
  _$ProductImageModelCopyWithImpl(this._self, this._then);

  final ProductImageModel _self;
  final $Res Function(ProductImageModel) _then;

/// Create a copy of ProductImageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? imagePath = null,Object? order = null,Object? isPrimary = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductImageModel].
extension ProductImageModelPatterns on ProductImageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductImageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductImageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductImageModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductImageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductImageModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductImageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(fromJson: _imagePathFromJson)  String imagePath, @JsonKey(defaultValue: 0)  int order, @JsonKey(name: 'is_primary', defaultValue: false)  bool isPrimary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductImageModel() when $default != null:
return $default(_that.id,_that.imagePath,_that.order,_that.isPrimary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(fromJson: _imagePathFromJson)  String imagePath, @JsonKey(defaultValue: 0)  int order, @JsonKey(name: 'is_primary', defaultValue: false)  bool isPrimary)  $default,) {final _that = this;
switch (_that) {
case _ProductImageModel():
return $default(_that.id,_that.imagePath,_that.order,_that.isPrimary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(fromJson: _imagePathFromJson)  String imagePath, @JsonKey(defaultValue: 0)  int order, @JsonKey(name: 'is_primary', defaultValue: false)  bool isPrimary)?  $default,) {final _that = this;
switch (_that) {
case _ProductImageModel() when $default != null:
return $default(_that.id,_that.imagePath,_that.order,_that.isPrimary);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductImageModel extends ProductImageModel {
  const _ProductImageModel({required this.id, @JsonKey(fromJson: _imagePathFromJson) required this.imagePath, @JsonKey(defaultValue: 0) required this.order, @JsonKey(name: 'is_primary', defaultValue: false) required this.isPrimary}): super._();
  factory _ProductImageModel.fromJson(Map<String, dynamic> json) => _$ProductImageModelFromJson(json);

@override final  String id;
@override@JsonKey(fromJson: _imagePathFromJson) final  String imagePath;
@override@JsonKey(defaultValue: 0) final  int order;
@override@JsonKey(name: 'is_primary', defaultValue: false) final  bool isPrimary;

/// Create a copy of ProductImageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductImageModelCopyWith<_ProductImageModel> get copyWith => __$ProductImageModelCopyWithImpl<_ProductImageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductImageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductImageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.order, order) || other.order == order)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,imagePath,order,isPrimary);

@override
String toString() {
  return 'ProductImageModel(id: $id, imagePath: $imagePath, order: $order, isPrimary: $isPrimary)';
}


}

/// @nodoc
abstract mixin class _$ProductImageModelCopyWith<$Res> implements $ProductImageModelCopyWith<$Res> {
  factory _$ProductImageModelCopyWith(_ProductImageModel value, $Res Function(_ProductImageModel) _then) = __$ProductImageModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(fromJson: _imagePathFromJson) String imagePath,@JsonKey(defaultValue: 0) int order,@JsonKey(name: 'is_primary', defaultValue: false) bool isPrimary
});




}
/// @nodoc
class __$ProductImageModelCopyWithImpl<$Res>
    implements _$ProductImageModelCopyWith<$Res> {
  __$ProductImageModelCopyWithImpl(this._self, this._then);

  final _ProductImageModel _self;
  final $Res Function(_ProductImageModel) _then;

/// Create a copy of ProductImageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? imagePath = null,Object? order = null,Object? isPrimary = null,}) {
  return _then(_ProductImageModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PromotionModel {

 String get id;@JsonKey(defaultValue: '') String get name;@JsonKey(defaultValue: '') String get type;@JsonKey(name: 'discount_value', defaultValue: 0.0) double get discountValue;
/// Create a copy of PromotionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromotionModelCopyWith<PromotionModel> get copyWith => _$PromotionModelCopyWithImpl<PromotionModel>(this as PromotionModel, _$identity);

  /// Serializes this PromotionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromotionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,discountValue);

@override
String toString() {
  return 'PromotionModel(id: $id, name: $name, type: $type, discountValue: $discountValue)';
}


}

/// @nodoc
abstract mixin class $PromotionModelCopyWith<$Res>  {
  factory $PromotionModelCopyWith(PromotionModel value, $Res Function(PromotionModel) _then) = _$PromotionModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(defaultValue: '') String name,@JsonKey(defaultValue: '') String type,@JsonKey(name: 'discount_value', defaultValue: 0.0) double discountValue
});




}
/// @nodoc
class _$PromotionModelCopyWithImpl<$Res>
    implements $PromotionModelCopyWith<$Res> {
  _$PromotionModelCopyWithImpl(this._self, this._then);

  final PromotionModel _self;
  final $Res Function(PromotionModel) _then;

/// Create a copy of PromotionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? discountValue = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [PromotionModel].
extension PromotionModelPatterns on PromotionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PromotionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PromotionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PromotionModel value)  $default,){
final _that = this;
switch (_that) {
case _PromotionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PromotionModel value)?  $default,){
final _that = this;
switch (_that) {
case _PromotionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(defaultValue: '')  String name, @JsonKey(defaultValue: '')  String type, @JsonKey(name: 'discount_value', defaultValue: 0.0)  double discountValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromotionModel() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.discountValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(defaultValue: '')  String name, @JsonKey(defaultValue: '')  String type, @JsonKey(name: 'discount_value', defaultValue: 0.0)  double discountValue)  $default,) {final _that = this;
switch (_that) {
case _PromotionModel():
return $default(_that.id,_that.name,_that.type,_that.discountValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(defaultValue: '')  String name, @JsonKey(defaultValue: '')  String type, @JsonKey(name: 'discount_value', defaultValue: 0.0)  double discountValue)?  $default,) {final _that = this;
switch (_that) {
case _PromotionModel() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.discountValue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PromotionModel extends PromotionModel {
  const _PromotionModel({required this.id, @JsonKey(defaultValue: '') required this.name, @JsonKey(defaultValue: '') required this.type, @JsonKey(name: 'discount_value', defaultValue: 0.0) required this.discountValue}): super._();
  factory _PromotionModel.fromJson(Map<String, dynamic> json) => _$PromotionModelFromJson(json);

@override final  String id;
@override@JsonKey(defaultValue: '') final  String name;
@override@JsonKey(defaultValue: '') final  String type;
@override@JsonKey(name: 'discount_value', defaultValue: 0.0) final  double discountValue;

/// Create a copy of PromotionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromotionModelCopyWith<_PromotionModel> get copyWith => __$PromotionModelCopyWithImpl<_PromotionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PromotionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromotionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,discountValue);

@override
String toString() {
  return 'PromotionModel(id: $id, name: $name, type: $type, discountValue: $discountValue)';
}


}

/// @nodoc
abstract mixin class _$PromotionModelCopyWith<$Res> implements $PromotionModelCopyWith<$Res> {
  factory _$PromotionModelCopyWith(_PromotionModel value, $Res Function(_PromotionModel) _then) = __$PromotionModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(defaultValue: '') String name,@JsonKey(defaultValue: '') String type,@JsonKey(name: 'discount_value', defaultValue: 0.0) double discountValue
});




}
/// @nodoc
class __$PromotionModelCopyWithImpl<$Res>
    implements _$PromotionModelCopyWith<$Res> {
  __$PromotionModelCopyWithImpl(this._self, this._then);

  final _PromotionModel _self;
  final $Res Function(_PromotionModel) _then;

/// Create a copy of PromotionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? discountValue = null,}) {
  return _then(_PromotionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$CategoryModel {

 String get id;@JsonKey(defaultValue: '') String get name;@JsonKey(defaultValue: '') String get slug;@JsonKey(name: 'is_highlighted', defaultValue: false) bool get isHighlighted;@JsonKey(name: 'is_active', defaultValue: true) bool get isActive;@JsonKey(name: 'products_count') int? get productsCount;
/// Create a copy of CategoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryModelCopyWith<CategoryModel> get copyWith => _$CategoryModelCopyWithImpl<CategoryModel>(this as CategoryModel, _$identity);

  /// Serializes this CategoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.isHighlighted, isHighlighted) || other.isHighlighted == isHighlighted)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.productsCount, productsCount) || other.productsCount == productsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug,isHighlighted,isActive,productsCount);

@override
String toString() {
  return 'CategoryModel(id: $id, name: $name, slug: $slug, isHighlighted: $isHighlighted, isActive: $isActive, productsCount: $productsCount)';
}


}

/// @nodoc
abstract mixin class $CategoryModelCopyWith<$Res>  {
  factory $CategoryModelCopyWith(CategoryModel value, $Res Function(CategoryModel) _then) = _$CategoryModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(defaultValue: '') String name,@JsonKey(defaultValue: '') String slug,@JsonKey(name: 'is_highlighted', defaultValue: false) bool isHighlighted,@JsonKey(name: 'is_active', defaultValue: true) bool isActive,@JsonKey(name: 'products_count') int? productsCount
});




}
/// @nodoc
class _$CategoryModelCopyWithImpl<$Res>
    implements $CategoryModelCopyWith<$Res> {
  _$CategoryModelCopyWithImpl(this._self, this._then);

  final CategoryModel _self;
  final $Res Function(CategoryModel) _then;

/// Create a copy of CategoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? isHighlighted = null,Object? isActive = null,Object? productsCount = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,isHighlighted: null == isHighlighted ? _self.isHighlighted : isHighlighted // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,productsCount: freezed == productsCount ? _self.productsCount : productsCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryModel].
extension CategoryModelPatterns on CategoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryModel value)  $default,){
final _that = this;
switch (_that) {
case _CategoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(defaultValue: '')  String name, @JsonKey(defaultValue: '')  String slug, @JsonKey(name: 'is_highlighted', defaultValue: false)  bool isHighlighted, @JsonKey(name: 'is_active', defaultValue: true)  bool isActive, @JsonKey(name: 'products_count')  int? productsCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryModel() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.isHighlighted,_that.isActive,_that.productsCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(defaultValue: '')  String name, @JsonKey(defaultValue: '')  String slug, @JsonKey(name: 'is_highlighted', defaultValue: false)  bool isHighlighted, @JsonKey(name: 'is_active', defaultValue: true)  bool isActive, @JsonKey(name: 'products_count')  int? productsCount)  $default,) {final _that = this;
switch (_that) {
case _CategoryModel():
return $default(_that.id,_that.name,_that.slug,_that.isHighlighted,_that.isActive,_that.productsCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(defaultValue: '')  String name, @JsonKey(defaultValue: '')  String slug, @JsonKey(name: 'is_highlighted', defaultValue: false)  bool isHighlighted, @JsonKey(name: 'is_active', defaultValue: true)  bool isActive, @JsonKey(name: 'products_count')  int? productsCount)?  $default,) {final _that = this;
switch (_that) {
case _CategoryModel() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.isHighlighted,_that.isActive,_that.productsCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryModel extends CategoryModel {
  const _CategoryModel({required this.id, @JsonKey(defaultValue: '') required this.name, @JsonKey(defaultValue: '') required this.slug, @JsonKey(name: 'is_highlighted', defaultValue: false) required this.isHighlighted, @JsonKey(name: 'is_active', defaultValue: true) required this.isActive, @JsonKey(name: 'products_count') this.productsCount}): super._();
  factory _CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);

@override final  String id;
@override@JsonKey(defaultValue: '') final  String name;
@override@JsonKey(defaultValue: '') final  String slug;
@override@JsonKey(name: 'is_highlighted', defaultValue: false) final  bool isHighlighted;
@override@JsonKey(name: 'is_active', defaultValue: true) final  bool isActive;
@override@JsonKey(name: 'products_count') final  int? productsCount;

/// Create a copy of CategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryModelCopyWith<_CategoryModel> get copyWith => __$CategoryModelCopyWithImpl<_CategoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.isHighlighted, isHighlighted) || other.isHighlighted == isHighlighted)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.productsCount, productsCount) || other.productsCount == productsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug,isHighlighted,isActive,productsCount);

@override
String toString() {
  return 'CategoryModel(id: $id, name: $name, slug: $slug, isHighlighted: $isHighlighted, isActive: $isActive, productsCount: $productsCount)';
}


}

/// @nodoc
abstract mixin class _$CategoryModelCopyWith<$Res> implements $CategoryModelCopyWith<$Res> {
  factory _$CategoryModelCopyWith(_CategoryModel value, $Res Function(_CategoryModel) _then) = __$CategoryModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(defaultValue: '') String name,@JsonKey(defaultValue: '') String slug,@JsonKey(name: 'is_highlighted', defaultValue: false) bool isHighlighted,@JsonKey(name: 'is_active', defaultValue: true) bool isActive,@JsonKey(name: 'products_count') int? productsCount
});




}
/// @nodoc
class __$CategoryModelCopyWithImpl<$Res>
    implements _$CategoryModelCopyWith<$Res> {
  __$CategoryModelCopyWithImpl(this._self, this._then);

  final _CategoryModel _self;
  final $Res Function(_CategoryModel) _then;

/// Create a copy of CategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? isHighlighted = null,Object? isActive = null,Object? productsCount = freezed,}) {
  return _then(_CategoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,isHighlighted: null == isHighlighted ? _self.isHighlighted : isHighlighted // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,productsCount: freezed == productsCount ? _self.productsCount : productsCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$ProductModel {

 String get id;@JsonKey(defaultValue: '') String get name;@JsonKey(defaultValue: '') String get description; String get price;@JsonKey(name: 'original_price') String? get originalPrice;@JsonKey(name: 'effective_price') String? get effectivePrice;@JsonKey(name: 'discount_amount') String? get discountAmount;@JsonKey(name: 'in_stock', defaultValue: false) bool get inStock;@JsonKey(name: 'is_highlighted', defaultValue: false) bool get isHighlighted;@JsonKey(name: 'is_active', defaultValue: true) bool get isActive; PromotionModel? get promotion;@JsonKey(name: 'primary_image') ProductImageModel? get primaryImage;@JsonKey(defaultValue: []) List<ProductImageModel> get images;@JsonKey(defaultValue: []) List<CategoryModel> get categories;@JsonKey(name: 'average_rating') double? get averageRating;@JsonKey(name: 'reviews_count', defaultValue: 0) int get reviewsCount;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductModelCopyWith<ProductModel> get copyWith => _$ProductModelCopyWithImpl<ProductModel>(this as ProductModel, _$identity);

  /// Serializes this ProductModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.effectivePrice, effectivePrice) || other.effectivePrice == effectivePrice)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.inStock, inStock) || other.inStock == inStock)&&(identical(other.isHighlighted, isHighlighted) || other.isHighlighted == isHighlighted)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.promotion, promotion) || other.promotion == promotion)&&(identical(other.primaryImage, primaryImage) || other.primaryImage == primaryImage)&&const DeepCollectionEquality().equals(other.images, images)&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.reviewsCount, reviewsCount) || other.reviewsCount == reviewsCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,price,originalPrice,effectivePrice,discountAmount,inStock,isHighlighted,isActive,promotion,primaryImage,const DeepCollectionEquality().hash(images),const DeepCollectionEquality().hash(categories),averageRating,reviewsCount,createdAt,updatedAt);

@override
String toString() {
  return 'ProductModel(id: $id, name: $name, description: $description, price: $price, originalPrice: $originalPrice, effectivePrice: $effectivePrice, discountAmount: $discountAmount, inStock: $inStock, isHighlighted: $isHighlighted, isActive: $isActive, promotion: $promotion, primaryImage: $primaryImage, images: $images, categories: $categories, averageRating: $averageRating, reviewsCount: $reviewsCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ProductModelCopyWith<$Res>  {
  factory $ProductModelCopyWith(ProductModel value, $Res Function(ProductModel) _then) = _$ProductModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(defaultValue: '') String name,@JsonKey(defaultValue: '') String description, String price,@JsonKey(name: 'original_price') String? originalPrice,@JsonKey(name: 'effective_price') String? effectivePrice,@JsonKey(name: 'discount_amount') String? discountAmount,@JsonKey(name: 'in_stock', defaultValue: false) bool inStock,@JsonKey(name: 'is_highlighted', defaultValue: false) bool isHighlighted,@JsonKey(name: 'is_active', defaultValue: true) bool isActive, PromotionModel? promotion,@JsonKey(name: 'primary_image') ProductImageModel? primaryImage,@JsonKey(defaultValue: []) List<ProductImageModel> images,@JsonKey(defaultValue: []) List<CategoryModel> categories,@JsonKey(name: 'average_rating') double? averageRating,@JsonKey(name: 'reviews_count', defaultValue: 0) int reviewsCount,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});


$PromotionModelCopyWith<$Res>? get promotion;$ProductImageModelCopyWith<$Res>? get primaryImage;

}
/// @nodoc
class _$ProductModelCopyWithImpl<$Res>
    implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._self, this._then);

  final ProductModel _self;
  final $Res Function(ProductModel) _then;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? price = null,Object? originalPrice = freezed,Object? effectivePrice = freezed,Object? discountAmount = freezed,Object? inStock = null,Object? isHighlighted = null,Object? isActive = null,Object? promotion = freezed,Object? primaryImage = freezed,Object? images = null,Object? categories = null,Object? averageRating = freezed,Object? reviewsCount = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String,originalPrice: freezed == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as String?,effectivePrice: freezed == effectivePrice ? _self.effectivePrice : effectivePrice // ignore: cast_nullable_to_non_nullable
as String?,discountAmount: freezed == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as String?,inStock: null == inStock ? _self.inStock : inStock // ignore: cast_nullable_to_non_nullable
as bool,isHighlighted: null == isHighlighted ? _self.isHighlighted : isHighlighted // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,promotion: freezed == promotion ? _self.promotion : promotion // ignore: cast_nullable_to_non_nullable
as PromotionModel?,primaryImage: freezed == primaryImage ? _self.primaryImage : primaryImage // ignore: cast_nullable_to_non_nullable
as ProductImageModel?,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<ProductImageModel>,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryModel>,averageRating: freezed == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double?,reviewsCount: null == reviewsCount ? _self.reviewsCount : reviewsCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PromotionModelCopyWith<$Res>? get promotion {
    if (_self.promotion == null) {
    return null;
  }

  return $PromotionModelCopyWith<$Res>(_self.promotion!, (value) {
    return _then(_self.copyWith(promotion: value));
  });
}/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductImageModelCopyWith<$Res>? get primaryImage {
    if (_self.primaryImage == null) {
    return null;
  }

  return $ProductImageModelCopyWith<$Res>(_self.primaryImage!, (value) {
    return _then(_self.copyWith(primaryImage: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductModel].
extension ProductModelPatterns on ProductModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(defaultValue: '')  String name, @JsonKey(defaultValue: '')  String description,  String price, @JsonKey(name: 'original_price')  String? originalPrice, @JsonKey(name: 'effective_price')  String? effectivePrice, @JsonKey(name: 'discount_amount')  String? discountAmount, @JsonKey(name: 'in_stock', defaultValue: false)  bool inStock, @JsonKey(name: 'is_highlighted', defaultValue: false)  bool isHighlighted, @JsonKey(name: 'is_active', defaultValue: true)  bool isActive,  PromotionModel? promotion, @JsonKey(name: 'primary_image')  ProductImageModel? primaryImage, @JsonKey(defaultValue: [])  List<ProductImageModel> images, @JsonKey(defaultValue: [])  List<CategoryModel> categories, @JsonKey(name: 'average_rating')  double? averageRating, @JsonKey(name: 'reviews_count', defaultValue: 0)  int reviewsCount, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.price,_that.originalPrice,_that.effectivePrice,_that.discountAmount,_that.inStock,_that.isHighlighted,_that.isActive,_that.promotion,_that.primaryImage,_that.images,_that.categories,_that.averageRating,_that.reviewsCount,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(defaultValue: '')  String name, @JsonKey(defaultValue: '')  String description,  String price, @JsonKey(name: 'original_price')  String? originalPrice, @JsonKey(name: 'effective_price')  String? effectivePrice, @JsonKey(name: 'discount_amount')  String? discountAmount, @JsonKey(name: 'in_stock', defaultValue: false)  bool inStock, @JsonKey(name: 'is_highlighted', defaultValue: false)  bool isHighlighted, @JsonKey(name: 'is_active', defaultValue: true)  bool isActive,  PromotionModel? promotion, @JsonKey(name: 'primary_image')  ProductImageModel? primaryImage, @JsonKey(defaultValue: [])  List<ProductImageModel> images, @JsonKey(defaultValue: [])  List<CategoryModel> categories, @JsonKey(name: 'average_rating')  double? averageRating, @JsonKey(name: 'reviews_count', defaultValue: 0)  int reviewsCount, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ProductModel():
return $default(_that.id,_that.name,_that.description,_that.price,_that.originalPrice,_that.effectivePrice,_that.discountAmount,_that.inStock,_that.isHighlighted,_that.isActive,_that.promotion,_that.primaryImage,_that.images,_that.categories,_that.averageRating,_that.reviewsCount,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(defaultValue: '')  String name, @JsonKey(defaultValue: '')  String description,  String price, @JsonKey(name: 'original_price')  String? originalPrice, @JsonKey(name: 'effective_price')  String? effectivePrice, @JsonKey(name: 'discount_amount')  String? discountAmount, @JsonKey(name: 'in_stock', defaultValue: false)  bool inStock, @JsonKey(name: 'is_highlighted', defaultValue: false)  bool isHighlighted, @JsonKey(name: 'is_active', defaultValue: true)  bool isActive,  PromotionModel? promotion, @JsonKey(name: 'primary_image')  ProductImageModel? primaryImage, @JsonKey(defaultValue: [])  List<ProductImageModel> images, @JsonKey(defaultValue: [])  List<CategoryModel> categories, @JsonKey(name: 'average_rating')  double? averageRating, @JsonKey(name: 'reviews_count', defaultValue: 0)  int reviewsCount, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.price,_that.originalPrice,_that.effectivePrice,_that.discountAmount,_that.inStock,_that.isHighlighted,_that.isActive,_that.promotion,_that.primaryImage,_that.images,_that.categories,_that.averageRating,_that.reviewsCount,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductModel extends ProductModel {
  const _ProductModel({required this.id, @JsonKey(defaultValue: '') required this.name, @JsonKey(defaultValue: '') required this.description, required this.price, @JsonKey(name: 'original_price') this.originalPrice, @JsonKey(name: 'effective_price') this.effectivePrice, @JsonKey(name: 'discount_amount') this.discountAmount, @JsonKey(name: 'in_stock', defaultValue: false) required this.inStock, @JsonKey(name: 'is_highlighted', defaultValue: false) required this.isHighlighted, @JsonKey(name: 'is_active', defaultValue: true) required this.isActive, this.promotion, @JsonKey(name: 'primary_image') this.primaryImage, @JsonKey(defaultValue: []) required final  List<ProductImageModel> images, @JsonKey(defaultValue: []) required final  List<CategoryModel> categories, @JsonKey(name: 'average_rating') this.averageRating, @JsonKey(name: 'reviews_count', defaultValue: 0) required this.reviewsCount, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt}): _images = images,_categories = categories,super._();
  factory _ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

@override final  String id;
@override@JsonKey(defaultValue: '') final  String name;
@override@JsonKey(defaultValue: '') final  String description;
@override final  String price;
@override@JsonKey(name: 'original_price') final  String? originalPrice;
@override@JsonKey(name: 'effective_price') final  String? effectivePrice;
@override@JsonKey(name: 'discount_amount') final  String? discountAmount;
@override@JsonKey(name: 'in_stock', defaultValue: false) final  bool inStock;
@override@JsonKey(name: 'is_highlighted', defaultValue: false) final  bool isHighlighted;
@override@JsonKey(name: 'is_active', defaultValue: true) final  bool isActive;
@override final  PromotionModel? promotion;
@override@JsonKey(name: 'primary_image') final  ProductImageModel? primaryImage;
 final  List<ProductImageModel> _images;
@override@JsonKey(defaultValue: []) List<ProductImageModel> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

 final  List<CategoryModel> _categories;
@override@JsonKey(defaultValue: []) List<CategoryModel> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

@override@JsonKey(name: 'average_rating') final  double? averageRating;
@override@JsonKey(name: 'reviews_count', defaultValue: 0) final  int reviewsCount;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductModelCopyWith<_ProductModel> get copyWith => __$ProductModelCopyWithImpl<_ProductModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.effectivePrice, effectivePrice) || other.effectivePrice == effectivePrice)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.inStock, inStock) || other.inStock == inStock)&&(identical(other.isHighlighted, isHighlighted) || other.isHighlighted == isHighlighted)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.promotion, promotion) || other.promotion == promotion)&&(identical(other.primaryImage, primaryImage) || other.primaryImage == primaryImage)&&const DeepCollectionEquality().equals(other._images, _images)&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.reviewsCount, reviewsCount) || other.reviewsCount == reviewsCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,price,originalPrice,effectivePrice,discountAmount,inStock,isHighlighted,isActive,promotion,primaryImage,const DeepCollectionEquality().hash(_images),const DeepCollectionEquality().hash(_categories),averageRating,reviewsCount,createdAt,updatedAt);

@override
String toString() {
  return 'ProductModel(id: $id, name: $name, description: $description, price: $price, originalPrice: $originalPrice, effectivePrice: $effectivePrice, discountAmount: $discountAmount, inStock: $inStock, isHighlighted: $isHighlighted, isActive: $isActive, promotion: $promotion, primaryImage: $primaryImage, images: $images, categories: $categories, averageRating: $averageRating, reviewsCount: $reviewsCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ProductModelCopyWith<$Res> implements $ProductModelCopyWith<$Res> {
  factory _$ProductModelCopyWith(_ProductModel value, $Res Function(_ProductModel) _then) = __$ProductModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(defaultValue: '') String name,@JsonKey(defaultValue: '') String description, String price,@JsonKey(name: 'original_price') String? originalPrice,@JsonKey(name: 'effective_price') String? effectivePrice,@JsonKey(name: 'discount_amount') String? discountAmount,@JsonKey(name: 'in_stock', defaultValue: false) bool inStock,@JsonKey(name: 'is_highlighted', defaultValue: false) bool isHighlighted,@JsonKey(name: 'is_active', defaultValue: true) bool isActive, PromotionModel? promotion,@JsonKey(name: 'primary_image') ProductImageModel? primaryImage,@JsonKey(defaultValue: []) List<ProductImageModel> images,@JsonKey(defaultValue: []) List<CategoryModel> categories,@JsonKey(name: 'average_rating') double? averageRating,@JsonKey(name: 'reviews_count', defaultValue: 0) int reviewsCount,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});


@override $PromotionModelCopyWith<$Res>? get promotion;@override $ProductImageModelCopyWith<$Res>? get primaryImage;

}
/// @nodoc
class __$ProductModelCopyWithImpl<$Res>
    implements _$ProductModelCopyWith<$Res> {
  __$ProductModelCopyWithImpl(this._self, this._then);

  final _ProductModel _self;
  final $Res Function(_ProductModel) _then;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? price = null,Object? originalPrice = freezed,Object? effectivePrice = freezed,Object? discountAmount = freezed,Object? inStock = null,Object? isHighlighted = null,Object? isActive = null,Object? promotion = freezed,Object? primaryImage = freezed,Object? images = null,Object? categories = null,Object? averageRating = freezed,Object? reviewsCount = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ProductModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String,originalPrice: freezed == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as String?,effectivePrice: freezed == effectivePrice ? _self.effectivePrice : effectivePrice // ignore: cast_nullable_to_non_nullable
as String?,discountAmount: freezed == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as String?,inStock: null == inStock ? _self.inStock : inStock // ignore: cast_nullable_to_non_nullable
as bool,isHighlighted: null == isHighlighted ? _self.isHighlighted : isHighlighted // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,promotion: freezed == promotion ? _self.promotion : promotion // ignore: cast_nullable_to_non_nullable
as PromotionModel?,primaryImage: freezed == primaryImage ? _self.primaryImage : primaryImage // ignore: cast_nullable_to_non_nullable
as ProductImageModel?,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<ProductImageModel>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryModel>,averageRating: freezed == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double?,reviewsCount: null == reviewsCount ? _self.reviewsCount : reviewsCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PromotionModelCopyWith<$Res>? get promotion {
    if (_self.promotion == null) {
    return null;
  }

  return $PromotionModelCopyWith<$Res>(_self.promotion!, (value) {
    return _then(_self.copyWith(promotion: value));
  });
}/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductImageModelCopyWith<$Res>? get primaryImage {
    if (_self.primaryImage == null) {
    return null;
  }

  return $ProductImageModelCopyWith<$Res>(_self.primaryImage!, (value) {
    return _then(_self.copyWith(primaryImage: value));
  });
}
}

// dart format on
