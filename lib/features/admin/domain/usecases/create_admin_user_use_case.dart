library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_user.dart';
import '../repositories/admin_users_repository.dart';

/// Cria um novo usuário. A senha é obrigatória (exigida pela API no POST).
class CreateAdminUserUseCase {
  const CreateAdminUserUseCase(this._repository);
  final AdminUsersRepository _repository;

  Future<Either<Failure, AdminUser>> call(
    AdminUser user, {
    required String password,
  }) =>
      _repository.createUser(user, password: password);
}
