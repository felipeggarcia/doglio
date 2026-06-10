/// Implementação concreta do repositório de usuários admin.
///
/// Traduz as exceções do datasource em `Either<Failure, T>`, isolando a UI de
/// detalhes de rede.
library;

import 'dart:async';
import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/admin_user.dart';
import '../../domain/entities/page_meta.dart';
import '../../domain/repositories/admin_users_repository.dart';
import '../datasources/admin_users_remote_datasource.dart';
import '../models/admin_user_model.dart';

class AdminUsersRepositoryImpl implements AdminUsersRepository {
  const AdminUsersRepositoryImpl(this._datasource);
  final AdminUsersRemoteDatasource _datasource;

  @override
  Future<Either<Failure, (List<AdminUser>, PageMeta)>> getUsers({
    String? search,
    AdminUserRole? role,
    bool? isActive,
    int page = 1,
  }) async {
    return _guard(() async {
      final (models, meta) = await _datasource.getUsers(
        search: search,
        role: role?.toApi(),
        isActive: isActive,
        page: page,
      );
      final users = models.map((m) => m.toEntity()).toList();
      return (users, meta);
    });
  }

  @override
  Future<Either<Failure, AdminUser>> createUser(
    AdminUser user, {
    required String password,
  }) async {
    return _guard(() async {
      final result = await _datasource.createUser(
        AdminUserModel.fromEntity(user),
        password: password,
      );
      return result.toEntity();
    });
  }

  @override
  Future<Either<Failure, AdminUser>> updateUser(AdminUser user) async {
    return _guard(() async {
      final result =
          await _datasource.updateUser(AdminUserModel.fromEntity(user));
      return result.toEntity();
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteUser(String id) async {
    return _guard(() async {
      await _datasource.deleteUser(id);
      return unit;
    });
  }

  /// Executa [action] convertendo qualquer exceção numa Failure tipada.
  /// Centraliza o tratamento de erro para não repetir try/catch em cada método.
  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on TimeoutException {
      return const Left(TimeoutFailure());
    } on SocketException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      // A mensagem do servidor já vem embutida na Exception lançada pelo datasource.
      return Left(UnknownFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
