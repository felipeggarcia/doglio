/// Get addresses use case
library;

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/address.dart';
import '../repositories/addresses_repository.dart';

class GetAddressesUseCase {
  const GetAddressesUseCase(this._repository);
  final AddressesRepository _repository;

  Future<Either<Failure, List<Address>>> call() => _repository.getAddresses();
}
