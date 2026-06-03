library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cart.dart';

abstract interface class CartRepository {
  Future<Either<Failure, Cart>> getCart();
  Future<Either<Failure, Cart>> syncCart(List<Map<String, dynamic>> items);
  Future<Either<Failure, void>> clearCart();
}
