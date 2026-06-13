/// Store repository implementation (Data layer)
library;

import 'dart:async';
import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/store_repository.dart';
import '../datasources/store_local_datasource.dart';
import '../datasources/store_remote_datasource.dart';

class StoreRepositoryImpl implements StoreRepository {
  StoreRepositoryImpl({
    required this.remoteDatasource,
    StoreLocalDatasource? localDatasource,
  }) : _local = localDatasource;

  final StoreRemoteDatasource remoteDatasource;
  final StoreLocalDatasource? _local;

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    String? categoryId,
    bool? isHighlighted,
    String? search,
    int? perPage,
  }) async {
    final key = _productsCacheKey(
      categoryId: categoryId,
      isHighlighted: isHighlighted,
      search: search,
      perPage: perPage,
    );

    try {
      final models = await remoteDatasource.getProducts(
        categoryId: categoryId,
        isHighlighted: isHighlighted,
        search: search,
        perPage: perPage,
      );
      unawaited(_local?.saveProducts(key, models));
      return right(models.map((m) => m.toEntity()).toList());
    } on SocketException catch (e) {
      final cached = await _local?.loadProducts(key);
      if (cached != null) return right(cached.map((m) => m.toEntity()).toList());
      return left(NetworkFailure(e.message));
    } on TimeoutException {
      final cached = await _local?.loadProducts(key);
      if (cached != null) return right(cached.map((m) => m.toEntity()).toList());
      return left(const TimeoutFailure());
    } on NetworkException catch (e) {
      final cached = await _local?.loadProducts(key);
      if (cached != null) return right(cached.map((m) => m.toEntity()).toList());
      return left(NetworkFailure(e.message));
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories({
    bool? isHighlighted,
    bool withCount = false,
  }) async {
    try {
      final models = await remoteDatasource.getCategories(
        isHighlighted: isHighlighted,
        withCount: withCount,
      );
      unawaited(_local?.saveCategories(models));
      return right(models.map((m) => m.toEntity()).toList());
    } on SocketException catch (e) {
      final cached = await _local?.loadCategories();
      if (cached != null) return right(cached.map((m) => m.toEntity()).toList());
      return left(NetworkFailure(e.message));
    } on TimeoutException {
      final cached = await _local?.loadCategories();
      if (cached != null) return right(cached.map((m) => m.toEntity()).toList());
      return left(const TimeoutFailure());
    } on NetworkException catch (e) {
      final cached = await _local?.loadCategories();
      if (cached != null) return right(cached.map((m) => m.toEntity()).toList());
      return left(NetworkFailure(e.message));
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  static String _productsCacheKey({
    String? categoryId,
    bool? isHighlighted,
    String? search,
    int? perPage,
  }) =>
      '${categoryId ?? ""}_${isHighlighted ?? ""}_${search ?? ""}_${perPage ?? ""}';
}
