/// Addresses page — list + add/edit/delete
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/address.dart';
import '../providers/addresses_provider.dart';
import '../../../../core/utils/l10n_helper.dart';

class AddressesPage extends ConsumerWidget {
  const AddressesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesAsync = ref.watch(addressesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.myAddresses),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddressForm(context, ref, null),
        child: const Icon(Icons.add),
      ),
      body: addressesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(e.toString(), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(addressesProvider.notifier).reload(),
                child: Text(context.l10n.tryAgain),
              ),
            ],
          ),
        ),
        data: (addresses) {
          if (addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off_outlined,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.noAddresses,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(addressesProvider.notifier).reload(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: addresses.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final address = addresses[index];
                return _AddressCard(
                  address: address,
                  onEdit: () => _showAddressForm(context, ref, address),
                  onDelete: () => _confirmDelete(context, ref, address),
                  onSetPrimary: () =>
                      ref.read(addressesProvider.notifier).setPrimary(address.id),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Address address) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.deleteAddress),
        content: Text(ctx.l10n.confirmDeleteAddressMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(ctx.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(ctx.l10n.delete,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        ref.read(addressesProvider.notifier).delete(address.id);
      }
    });
  }

  void _showAddressForm(BuildContext context, WidgetRef ref, Address? address) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _AddressForm(
        address: address,
        onSave: (a) {
          ref.read(addressesProvider.notifier).save(a);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onSetPrimary,
  });

  final Address address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetPrimary;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (address.isPrimary) ...[
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    context.l10n.primaryAddress,
                    style: const TextStyle(
                        color: Colors.amber, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                ] else
                  const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: onEdit,
                  tooltip: context.l10n.edit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      size: 20, color: Colors.red),
                  onPressed: onDelete,
                  tooltip: context.l10n.delete,
                ),
              ],
            ),
            Text(
              '${address.street}, ${address.number}'
              '${address.complement != null ? ', ${address.complement}' : ''}',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text('${address.district} — ${address.city}/${address.state}'),
            Text(context.l10n.zipCodeLabel(address.zipCode)),
            if (!address.isPrimary) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: onSetPrimary,
                icon: const Icon(Icons.star_border, size: 16),
                label: Text(context.l10n.setPrimaryAddress),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AddressForm extends StatefulWidget {
  const _AddressForm({this.address, required this.onSave});
  final Address? address;
  final void Function(Address) onSave;

  @override
  State<_AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<_AddressForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _street;
  late final TextEditingController _number;
  late final TextEditingController _complement;
  late final TextEditingController _district;
  late final TextEditingController _city;
  late final TextEditingController _state;
  late final TextEditingController _zipCode;

  @override
  void initState() {
    super.initState();
    final a = widget.address;
    _street = TextEditingController(text: a?.street ?? '');
    _number = TextEditingController(text: a?.number ?? '');
    _complement = TextEditingController(text: a?.complement ?? '');
    _district = TextEditingController(text: a?.district ?? '');
    _city = TextEditingController(text: a?.city ?? '');
    _state = TextEditingController(text: a?.state ?? '');
    _zipCode = TextEditingController(text: a?.zipCode ?? '');
  }

  @override
  void dispose() {
    for (final c in [
      _street, _number, _complement, _district, _city, _state, _zipCode
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final a = widget.address;
    widget.onSave(
      Address(
        id: a?.id ?? '',
        street: _street.text.trim(),
        number: _number.text.trim(),
        complement:
            _complement.text.trim().isEmpty ? null : _complement.text.trim(),
        district: _district.text.trim(),
        city: _city.text.trim(),
        state: _state.text.trim(),
        zipCode: _zipCode.text.trim(),
        isPrimary: a?.isPrimary ?? false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.address == null
                  ? l10n.newAddressTitle
                  : l10n.editAddressTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _street,
              decoration: InputDecoration(labelText: l10n.addressStreet),
              validator: (v) =>
                  v == null || v.isEmpty ? l10n.requiredField : null,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _number,
                    decoration: InputDecoration(labelText: l10n.addressNumber),
                    validator: (v) =>
                        v == null || v.isEmpty ? l10n.requiredField : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _complement,
                    decoration:
                        InputDecoration(labelText: l10n.addressComplement),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _district,
              decoration: InputDecoration(labelText: l10n.addressDistrict),
              validator: (v) =>
                  v == null || v.isEmpty ? l10n.requiredField : null,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _city,
                    decoration: InputDecoration(labelText: l10n.addressCity),
                    validator: (v) =>
                        v == null || v.isEmpty ? l10n.requiredField : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: _state,
                    decoration: InputDecoration(labelText: l10n.addressState),
                    maxLength: 2,
                    validator: (v) =>
                        v == null || v.isEmpty ? l10n.requiredField : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _zipCode,
              decoration: InputDecoration(labelText: l10n.addressZip),
              keyboardType: TextInputType.number,
              validator: (v) =>
                  v == null || v.isEmpty ? l10n.requiredField : null,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _submit,
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}
