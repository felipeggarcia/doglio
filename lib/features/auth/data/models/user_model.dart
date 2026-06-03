library;

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

UserRole _userRoleFromJson(String role) =>
    role == 'admin' ? UserRole.admin : UserRole.user;

String _userRoleToJson(UserRole role) =>
    role == UserRole.admin ? 'admin' : 'customer';

@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String email,
    required String name,
    @JsonKey(fromJson: _userRoleFromJson, toJson: _userRoleToJson)
    required UserRole role,
    String? city,
    String? state,
    @JsonKey(name: 'cpf_cnpj') String? cpfCnpj,
    @JsonKey(name: 'birth_date') String? birthDate,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  User toEntity() => User(
        id: id,
        email: email,
        name: name,
        role: role,
        city: city,
        state: state,
        cpfCnpj: cpfCnpj,
        birthDate: birthDate,
      );
}
