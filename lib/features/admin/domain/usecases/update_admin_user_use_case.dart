library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_user.dart';
import '../repositories/admin_users_repository.dart';

/// Atualiza um usuário existente (sem alterar senha).
class UpdateAdminUserUseCase {
  const UpdateAdminUserUseCase(this._repository);
  final AdminUsersRepository _repository;

  Future<Either<Failure, AdminUser>> call(AdminUser user) =>
      _repository.updateUser(user);
}
