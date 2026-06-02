/// Save address use case (create or update)
library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/address.dart';
import '../repositories/addresses_repository.dart';

class SaveAddressUseCase {
  const SaveAddressUseCase(this._repository);
  final AddressesRepository _repository;

  Future<Either<Failure, Address>> call(Address address) {
    final isNew = address.id.isEmpty;
    return isNew
        ? _repository.createAddress(address)
        : _repository.updateAddress(address);
  }
}
