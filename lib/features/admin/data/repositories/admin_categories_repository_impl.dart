library;

import 'dart:async';
import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/admin_category.dart';
import '../../domain/repositories/admin_categories_repository.dart';
import '../datasources/admin_categories_remote_datasource.dart';
import '../models/admin_category_model.dart';

class AdminCategoriesRepositoryImpl implements AdminCategoriesRepository {
  const AdminCategoriesRepositoryImpl(this._datasource);
  final AdminCategoriesRemoteDatasource _datasource;

  @override
  Future<Either<Failure, List<AdminCategory>>> getCategories({
    String? search,
    bool? isActive,
  }) async {
    return _guard(() async {
      final models = await _datasource.getCategories(
        search: search,
        isActive: isActive,
      );
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, AdminCategory>> createCategory(
      AdminCategory category) async {
    return _guard(() async {
      final result = await _datasource
          .createCategory(AdminCategoryModel.fromEntity(category));
      return result.toEntity();
    });
  }

  @override
  Future<Either<Failure, AdminCategory>> updateCategory(
      AdminCategory category) async {
    return _guard(() async {
      final result = await _datasource
          .updateCategory(AdminCategoryModel.fromEntity(category));
      return result.toEntity();
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteCategory(String id) async {
    return _guard(() async {
      await _datasource.deleteCategory(id);
      return unit;
    });
  }

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on TimeoutException {
      return const Left(TimeoutFailure());
    } on SocketException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
