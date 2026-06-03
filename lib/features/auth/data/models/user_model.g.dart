// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  role: _userRoleFromJson(json['role'] as String),
  city: json['city'] as String?,
  state: json['state'] as String?,
  cpfCnpj: json['cpf_cnpj'] as String?,
  birthDate: json['birth_date'] as String?,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'role': _userRoleToJson(instance.role),
      'city': instance.city,
      'state': instance.state,
      'cpf_cnpj': instance.cpfCnpj,
      'birth_date': instance.birthDate,
    };
