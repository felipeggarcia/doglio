library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/admin_users_repository.dart';

/// Remove um usuário pelo id.
class DeleteAdminUserUseCase {
  const DeleteAdminUserUseCase(this._repository);
  final AdminUsersRepository _repository;

  Future<Either<Failure, Unit>> call(String id) => _repository.deleteUser(id);
}
