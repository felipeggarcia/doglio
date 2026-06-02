/// Addresses page — list + add/edit/delete
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/address.dart';
import '../providers/addresses_provider.dart';

class AddressesPage extends ConsumerWidget {
  const AddressesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesAsync = ref.watch(addressesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Endereços'),
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
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
        data: (addresses) {
          if (addresses.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off_outlined,
                      size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Nenhum endereço cadastrado',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
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
              separatorBuilder: (_, __) => const SizedBox(height: 8),
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
        title: const Text('Excluir endereço'),
        content: const Text('Tem certeza que deseja excluir este endereço?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
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
                  const Text(
                    'Principal',
                    style: TextStyle(
                        color: Colors.amber, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                ] else
                  const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: onEdit,
                  tooltip: 'Editar',
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20,
                      color: Colors.red),
                  onPressed: onDelete,
                  tooltip: 'Excluir',
                ),
              ],
            ),
            Text(
              '${address.street}, ${address.number}'
              '${address.complement != null ? ', ${address.complement}' : ''}',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              '${address.district} — ${address.city}/${address.state}',
            ),
            Text('CEP: ${address.zipCode}'),
            if (!address.isPrimary) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: onSetPrimary,
                icon: const Icon(Icons.star_border, size: 16),
                label: const Text('Definir como principal'),
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
              widget.address == null ? 'Novo Endereço' : 'Editar Endereço',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _street,
              decoration: const InputDecoration(labelText: 'Rua / Avenida'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Obrigatório' : null,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _number,
                    decoration: const InputDecoration(labelText: 'Número'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Obrigatório' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _complement,
                    decoration:
                        const InputDecoration(labelText: 'Complemento'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _district,
              decoration: const InputDecoration(labelText: 'Bairro'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Obrigatório' : null,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _city,
                    decoration: const InputDecoration(labelText: 'Cidade'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Obrigatório' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: _state,
                    decoration: const InputDecoration(labelText: 'UF'),
                    maxLength: 2,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Obrigatório' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _zipCode,
              decoration: const InputDecoration(labelText: 'CEP'),
              keyboardType: TextInputType.number,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Obrigatório' : null,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _submit,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
