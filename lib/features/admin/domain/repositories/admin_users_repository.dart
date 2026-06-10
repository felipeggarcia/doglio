/// Contrato (interface) do repositório de usuários admin.
///
/// O domínio declara as operações; a implementação concreta (camada de dados)
/// decide como cumpri-las. Tudo retorna `Either<Failure, T>` para tratamento de
/// erro explícito, sem exceções vazando para a UI.
library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_user.dart';
import '../entities/page_meta.dart';

abstract class AdminUsersRepository {
  /// Lista paginada de usuários, com filtros opcionais.
  /// Retorna a página de usuários + os metadados de paginação.
  Future<Either<Failure, (List<AdminUser>, PageMeta)>> getUsers({
    String? search,
    AdminUserRole? role,
    bool? isActive,
    int page,
  });

  /// Cria um usuário. `password` é obrigatório pela API no POST.
  Future<Either<Failure, AdminUser>> createUser(
    AdminUser user, {
    required String password,
  });

  /// Atualiza um usuário existente (PUT). Sem senha nesta tela.
  Future<Either<Failure, AdminUser>> updateUser(AdminUser user);

  /// Remove um usuário.
  Future<Either<Failure, Unit>> deleteUser(String id);
}
