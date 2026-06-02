/// Addresses repository implementation
library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/address.dart';
import '../../domain/repositories/addresses_repository.dart';
import '../datasources/addresses_remote_datasource.dart';
import '../models/address_model.dart';

class AddressesRepositoryImpl implements AddressesRepository {
  const AddressesRepositoryImpl(this._datasource);
  final AddressesRemoteDatasource _datasource;

  @override
  Future<Either<Failure, List<Address>>> getAddresses() async {
    try {
      final result = await _datasource.getAddresses();
      return Right(result);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Address>> createAddress(Address address) async {
    try {
      final model = _toModel(address);
      final result = await _datasource.createAddress(model);
      return Right(result);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Address>> updateAddress(Address address) async {
    try {
      final model = _toModel(address);
      final result = await _datasource.updateAddress(model);
      return Right(result);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAddress(String addressId) async {
    try {
      await _datasource.deleteAddress(addressId);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setPrimaryAddress(String addressId) async {
    try {
      await _datasource.setPrimaryAddress(addressId);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  AddressModel _toModel(Address address) => AddressModel(
        id: address.id,
        street: address.street,
        number: address.number,
        complement: address.complement,
        district: address.district,
        city: address.city,
        state: address.state,
        zipCode: address.zipCode,
        country: address.country,
        isPrimary: address.isPrimary,
      );
}
