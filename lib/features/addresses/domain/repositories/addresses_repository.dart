/// Addresses repository interface
library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/address.dart';

abstract interface class AddressesRepository {
  Future<Either<Failure, List<Address>>> getAddresses();
  Future<Either<Failure, Address>> createAddress(Address address);
  Future<Either<Failure, Address>> updateAddress(Address address);
  Future<Either<Failure, void>> deleteAddress(String addressId);
  Future<Either<Failure, void>> setPrimaryAddress(String addressId);
}
