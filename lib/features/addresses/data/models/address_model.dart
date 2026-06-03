library;

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/address.dart';

part 'address_model.freezed.dart';
part 'address_model.g.dart';

@freezed
abstract class AddressModel with _$AddressModel {
  const AddressModel._();

  const factory AddressModel({
    required String id,
    required String street,
    required String number,
    required String district,
    required String city,
    required String state,
    @JsonKey(name: 'zip_code') required String zipCode,
    String? complement,
    @JsonKey(defaultValue: 'Brasil') String? country,
    @JsonKey(name: 'is_primary', defaultValue: false) required bool isPrimary,
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Address toEntity() => Address(
        id: id,
        street: street,
        number: number,
        complement: complement,
        district: district,
        city: city,
        state: state,
        zipCode: zipCode,
        country: country ?? 'Brasil',
        isPrimary: isPrimary,
      );
}
