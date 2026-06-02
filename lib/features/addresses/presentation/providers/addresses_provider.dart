/// Addresses Riverpod provider
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/address.dart';
import '../../domain/repositories/addresses_repository.dart';
import '../../domain/usecases/get_addresses_use_case.dart';
import '../../domain/usecases/save_address_use_case.dart';
import '../../domain/usecases/delete_address_use_case.dart';
import '../../domain/usecases/set_primary_address_use_case.dart';
import '../../data/datasources/addresses_remote_datasource.dart';
import '../../data/repositories/addresses_repository_impl.dart';

final addressesProvider =
    AsyncNotifierProvider<AddressesNotifier, List<Address>>(
  AddressesNotifier.new,
);

class AddressesNotifier extends AsyncNotifier<List<Address>> {
  late final GetAddressesUseCase _getAddresses;
  late final SaveAddressUseCase _saveAddress;
  late final DeleteAddressUseCase _deleteAddress;
  late final SetPrimaryAddressUseCase _setPrimary;

  @override
  Future<List<Address>> build() async {
    final AddressesRepository repo =
        AddressesRepositoryImpl(AddressesRemoteDatasource());
    _getAddresses = GetAddressesUseCase(repo);
    _saveAddress = SaveAddressUseCase(repo);
    _deleteAddress = DeleteAddressUseCase(repo);
    _setPrimary = SetPrimaryAddressUseCase(repo);
    return _load();
  }

  Future<List<Address>> _load() async {
    final result = await _getAddresses();
    return result.fold(
      (failure) => throw Exception(failure.userMessage),
      (addresses) => addresses,
    );
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<void> save(Address address) async {
    final result = await _saveAddress(address);
    result.fold(
      (failure) => throw Exception(failure.userMessage),
      (_) => reload(),
    );
  }

  Future<void> delete(String addressId) async {
    final result = await _deleteAddress(addressId);
    result.fold(
      (failure) => throw Exception(failure.userMessage),
      (_) {
        final current = state.valueOrNull ?? [];
        state = AsyncData(
          current.where((a) => a.id != addressId).toList(),
        );
      },
    );
  }

  Future<void> setPrimary(String addressId) async {
    final result = await _setPrimary(addressId);
    result.fold(
      (failure) => throw Exception(failure.userMessage),
      (_) {
        final current = state.valueOrNull ?? [];
        state = AsyncData(
          current
              .map((a) => a.copyWith(isPrimary: a.id == addressId))
              .toList(),
        );
      },
    );
  }
}
