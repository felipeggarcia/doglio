library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_user.dart';
import '../entities/page_meta.dart';
import '../repositories/admin_users_repository.dart';

/// Busca a lista paginada de usuários com filtros opcionais.
class GetAdminUsersUseCase {
  const GetAdminUsersUseCase(this._repository);
  final AdminUsersRepository _repository;

  Future<Either<Failure, (List<AdminUser>, PageMeta)>> call({
    String? search,
    AdminUserRole? role,
    bool? isActive,
    int page = 1,
  }) =>
      _repository.getUsers(
        search: search,
        role: role,
        isActive: isActive,
        page: page,
      );
}
