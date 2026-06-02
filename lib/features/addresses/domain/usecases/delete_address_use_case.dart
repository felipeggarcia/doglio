/// Delete address use case
library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/addresses_repository.dart';

class DeleteAddressUseCase {
  const DeleteAddressUseCase(this._repository);
  final AddressesRepository _repository;

  Future<Either<Failure, void>> call(String addressId) =>
      _repository.deleteAddress(addressId);
}
