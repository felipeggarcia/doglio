/// Store repository implementation (Data layer)
library;

import 'dart:async';
import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/store_repository.dart';
import '../datasources/store_remote_datasource.dart';

class StoreRepositoryImpl implements StoreRepository {
  final StoreRemoteDatasource remoteDatasource;

  StoreRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    String? categoryId,
    bool? isHighlighted,
    String? search,
    int? perPage,
  }) async {
    try {
      final models = await remoteDatasource.getProducts(
        categoryId: categoryId,
        isHighlighted: isHighlighted,
        search: search,
        perPage: perPage,
      );
      return right(models.map((m) => m.toEntity()).toList());
    } on TimeoutException {
      return left(const TimeoutFailure());
    } on SocketException catch (e) {
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
      return right(models.map((m) => m.toEntity()).toList());
    } on TimeoutException {
      return left(const TimeoutFailure());
    } on SocketException catch (e) {
      return left(NetworkFailure(e.message));
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }
}
