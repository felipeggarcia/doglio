// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AddressModel _$AddressModelFromJson(Map<String, dynamic> json) =>
    _AddressModel(
      id: json['id'] as String,
      street: json['street'] as String,
      number: json['number'] as String,
      district: json['district'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zip_code'] as String,
      complement: json['complement'] as String?,
      country: json['country'] as String? ?? 'Brasil',
      isPrimary: json['is_primary'] as bool? ?? false,
    );

Map<String, dynamic> _$AddressModelToJson(_AddressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'street': instance.street,
      'number': instance.number,
      'district': instance.district,
      'city': instance.city,
      'state': instance.state,
      'zip_code': instance.zipCode,
      'complement': instance.complement,
      'country': instance.country,
      'is_primary': instance.isPrimary,
    };
