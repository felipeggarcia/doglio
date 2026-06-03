library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/cart.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_datasource.dart';

class CartRepositoryImpl implements CartRepository {
  const CartRepositoryImpl(this._datasource);
  final CartRemoteDatasource _datasource;

  @override
  Future<Either<Failure, Cart>> getCart() async {
    try {
      final result = await _datasource.getCart();
      return Right(result.toEntity());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> syncCart(
      List<Map<String, dynamic>> items) async {
    try {
      final result = await _datasource.syncCart(items);
      return Right(result.toEntity());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await _datasource.clearCart();
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
