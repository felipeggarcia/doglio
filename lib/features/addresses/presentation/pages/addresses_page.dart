library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../domain/entities/address.dart';
import '../providers/addresses_provider.dart';

class AddressesPage extends ConsumerWidget {
  const AddressesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final addressesAsync = ref.watch(addressesProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          context.l10n.myAddresses,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddressForm(context, ref, null),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_location_alt_outlined),
        label: Text(context.l10n.addAddress),
      ),
      body: addressesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorState(
          message: e.toString(),
          onRetry: () => ref.read(addressesProvider.notifier).reload(),
        ),
        data: (addresses) => addresses.isEmpty
            ? _EmptyState(
                onAdd: () => _showAddressForm(context, ref, null),
              )
            : RefreshIndicator(
                onRefresh: () => ref.read(addressesProvider.notifier).reload(),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  itemCount: addresses.length,
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _AddressCard(
                        address: address,
                        onEdit: () => _showAddressForm(context, ref, address),
                        onDelete: () => _confirmDelete(context, ref, address),
                        onSetPrimary: () => ref
                            .read(addressesProvider.notifier)
                            .setPrimary(address.id),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, WidgetRef ref, Address address) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.deleteAddress),
        content: Text(context.l10n.confirmDeleteAddressMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              context.l10n.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        ref.read(addressesProvider.notifier).delete(address.id);
      }
    });
  }

  void _showAddressForm(
      BuildContext context, WidgetRef ref, Address? address) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddressFormSheet(
        address: address,
        onSave: (a) {
          ref.read(addressesProvider.notifier).save(a);
          Navigator.pop(context);
        },
      ),
    );
  }
}

// ─── Estado vazio ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on_outlined,
                size: 48,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.noAddresses,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.addAddress,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_location_alt_outlined),
              label: Text(context.l10n.addAddress),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Estado de erro ───────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(context.l10n.tryAgain),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Card de endereço ─────────────────────────────────────────────────────────

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
    final theme = Theme.of(context);
    final isPrimary = address.isPrimary;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPrimary
              ? theme.colorScheme.primary.withValues(alpha: 0.4)
              : Colors.grey[200]!,
          width: isPrimary ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Cabeçalho
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 8),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isPrimary
                        ? theme.colorScheme.primary.withValues(alpha: 0.1)
                        : Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPrimary
                        ? Icons.home_outlined
                        : Icons.location_on_outlined,
                    color: isPrimary
                        ? theme.colorScheme.primary
                        : Colors.grey[500],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${address.street}, ${address.number}'
                        '${address.complement != null ? ' - ${address.complement}' : ''}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${address.district} · ${address.city}/${address.state}',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey[600]),
                      ),
                      Text(
                        context.l10n.zipCodeLabel(
                          _formatCep(address.zipCode),
                        ),
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Badge principal
          if (isPrimary)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded,
                            size: 14,
                            color: theme.colorScheme.primary),
                        const SizedBox(width: 4),
                        Text(
                          context.l10n.primaryAddress,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Divisor + ações
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                if (!isPrimary)
                  TextButton.icon(
                    onPressed: onSetPrimary,
                    icon: Icon(Icons.star_border_rounded,
                        size: 16, color: theme.colorScheme.primary),
                    label: Text(
                      context.l10n.setPrimaryAddress,
                      style: TextStyle(
                          color: theme.colorScheme.primary, fontSize: 13),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                const Spacer(),
                IconButton(
                  onPressed: onEdit,
                  icon: Icon(Icons.edit_outlined,
                      size: 20, color: theme.colorScheme.primary),
                  tooltip: context.l10n.edit,
                  style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline,
                      size: 20, color: Colors.red),
                  tooltip: context.l10n.delete,
                  style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCep(String cep) {
    final digits = cep.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length == 8) {
      return '${digits.substring(0, 5)}-${digits.substring(5)}';
    }
    return cep;
  }
}

// ─── Bottom sheet de formulário ───────────────────────────────────────────────

class _AddressFormSheet extends StatefulWidget {
  const _AddressFormSheet({this.address, required this.onSave});
  final Address? address;
  final void Function(Address) onSave;

  @override
  State<_AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<_AddressFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _zipCode;
  late final TextEditingController _street;
  late final TextEditingController _number;
  late final TextEditingController _complement;
  late final TextEditingController _district;
  late final TextEditingController _city;
  late final TextEditingController _state;

  @override
  void initState() {
    super.initState();
    final a = widget.address;
    // CEP: exibir formatado se já salvo
    final zip = a?.zipCode ?? '';
    final zipDigits = zip.replaceAll(RegExp(r'[^\d]'), '');
    final zipFormatted = zipDigits.length == 8
        ? '${zipDigits.substring(0, 5)}-${zipDigits.substring(5)}'
        : zip;

    _zipCode = TextEditingController(text: zipFormatted);
    _street = TextEditingController(text: a?.street ?? '');
    _number = TextEditingController(text: a?.number ?? '');
    _complement = TextEditingController(text: a?.complement ?? '');
    _district = TextEditingController(text: a?.district ?? '');
    _city = TextEditingController(text: a?.city ?? '');
    _state = TextEditingController(text: a?.state ?? '');
  }

  @override
  void dispose() {
    for (final c in [
      _zipCode, _street, _number, _complement, _district, _city, _state,
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
        complement: _complement.text.trim().isEmpty
            ? null
            : _complement.text.trim(),
        district: _district.text.trim(),
        city: _city.text.trim(),
        state: _state.text.trim(),
        zipCode: _zipCode.text.replaceAll(RegExp(r'[^\d]'), ''),
        isPrimary: a?.isPrimary ?? false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isEdit = widget.address != null;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          // Cabeçalho
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isEdit
                        ? Icons.edit_location_alt_outlined
                        : Icons.add_location_alt_outlined,
                    color: theme.colorScheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  isEdit ? l10n.editAddressTitle : l10n.newAddressTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          const Divider(height: 20),

          // Formulário com scroll
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── CEP (primeiro) ─────────────────────────────────────
                    _field(
                      controller: _zipCode,
                      label: l10n.addressZip,
                      hint: '00000-000',
                      icon: Icons.location_on_outlined,
                      keyboardType: TextInputType.number,
                      formatters: [CepInputFormatter()],
                      validator: (v) {
                        final digits = (v ?? '')
                            .replaceAll(RegExp(r'[^\d]'), '');
                        if (digits.length != 8) return l10n.requiredField;
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // ── Rua ────────────────────────────────────────────────
                    _field(
                      controller: _street,
                      label: l10n.addressStreet,
                      icon: Icons.signpost_outlined,
                      validator: _required,
                    ),
                    const SizedBox(height: 12),

                    // ── Número + Complemento ───────────────────────────────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _field(
                            controller: _number,
                            label: l10n.addressNumber,
                            keyboardType: TextInputType.number,
                            validator: _required,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 3,
                          child: _field(
                            controller: _complement,
                            label: l10n.addressComplement,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // ── Bairro ────────────────────────────────────────────
                    _field(
                      controller: _district,
                      label: l10n.addressDistrict,
                      icon: Icons.map_outlined,
                      validator: _required,
                    ),
                    const SizedBox(height: 12),

                    // ── Cidade + Estado ────────────────────────────────────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _field(
                            controller: _city,
                            label: l10n.addressCity,
                            icon: Icons.location_city_outlined,
                            validator: _required,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: _field(
                            controller: _state,
                            label: l10n.addressState,
                            hint: 'SP',
                            formatters: [
                              LengthLimitingTextInputFormatter(2),
                              UpperCaseTextFormatter(),
                            ],
                            validator: _required,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── Salvar ─────────────────────────────────────────────
                    ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.check_rounded),
                      label: Text(
                        l10n.save,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _required(String? v) =>
      v == null || v.trim().isEmpty ? context.l10n.requiredField : null;

  Widget _field({
    required TextEditingController controller,
    required String label,
    String? hint,
    IconData? icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? formatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: formatters,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon, size: 20) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 14),
      ),
    );
  }
}
