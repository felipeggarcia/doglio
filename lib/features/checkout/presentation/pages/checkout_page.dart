library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../../addresses/domain/entities/address.dart';
import '../../../addresses/presentation/providers/addresses_provider.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../domain/entities/payment_method.dart';
import '../providers/checkout_provider.dart';
import '../providers/payment_methods_provider.dart';

const _kShippingFee = 5.90;

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  // ─── Pagamento ──────────────────────────────────────────────────────────────
  String? _selectedPaymentMethodId;
  String? _selectedPaymentMethodName;
  String? _selectedPaymentMethodType; // 'pix' | 'boleto' | 'credit_card'

  // ─── Cartão de crédito ───────────────────────────────────────────────────────
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _cardCpfController = TextEditingController();
  final _cardExpiryController = TextEditingController();
  final _cardCvvController = TextEditingController();
  int _cardInstallments = 1;
  String? _detectedCardBrand;

  // ─── Tipo de entrega ─────────────────────────────────────────────────────────
  bool _isDelivery = true;

  // ─── Seletor de endereço salvo ───────────────────────────────────────────────
  Address? _selectedSavedAddress;
  bool _useNewAddress = false; // true = mostrar form CEP mesmo com endereços salvos

  // ─── Formulário de endereço (novo) ───────────────────────────────────────────
  final _cepController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _complementController = TextEditingController();
  final _districtController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();

  bool _cepChecked = false;
  Address? _matchedAddress;
  bool _navigating = false;

  // ─── Getters derivados ───────────────────────────────────────────────────────

  bool get _formModified {
    if (_matchedAddress == null) return false;
    return _streetController.text != _matchedAddress!.street ||
        _numberController.text != _matchedAddress!.number ||
        _complementController.text != (_matchedAddress!.complement ?? '') ||
        _districtController.text != _matchedAddress!.district ||
        _cityController.text != _matchedAddress!.city ||
        _stateController.text != _matchedAddress!.state;
  }

  bool get _canSubmit {
    if (_selectedPaymentMethodId == null) return false;
    // Validação de cartão (obrigatória quando credit_card)
    if (_selectedPaymentMethodType == 'credit_card') {
      final digits =
          _cardNumberController.text.replaceAll(RegExp(r'[^\d]'), '');
      if (digits.length != 16) return false;
      if (_cardHolderController.text.trim().isEmpty) return false;
      final cpfDigits =
          _cardCpfController.text.replaceAll(RegExp(r'[^\d]'), '');
      if (cpfDigits.length != 11) return false;
      final expiryDigits =
          _cardExpiryController.text.replaceAll(RegExp(r'[^\d]'), '');
      if (expiryDigits.length != 4) return false;
      if (_cardCvvController.text.trim().length < 3) return false;
    }
    if (!_isDelivery) return true;
    // Endereço salvo selecionado diretamente
    if (_selectedSavedAddress != null && !_useNewAddress) return true;
    // Formulário CEP (endereço novo)
    final cep = _cepDigits;
    if (cep.length != 8 || !_cepChecked) return false;
    return _streetController.text.trim().isNotEmpty &&
        _numberController.text.trim().isNotEmpty &&
        _districtController.text.trim().isNotEmpty &&
        _cityController.text.trim().isNotEmpty &&
        _stateController.text.trim().isNotEmpty;
  }

  String get _cepDigits => _cepController.text.replaceAll(RegExp(r'[^\d]'), '');

  String get _displayTotal {
    final cart = ref.read(cartProvider);
    final base = double.tryParse(cart.computedTotal) ?? 0.0;
    final total = _isDelivery ? base + _kShippingFee : base;
    return total.toStringAsFixed(2);
  }

  void _resetDeliveryState() {
    _selectedSavedAddress = null;
    _useNewAddress = false;
    _cepChecked = false;
    _matchedAddress = null;
    _cepController.clear();
    _streetController.clear();
    _numberController.clear();
    _complementController.clear();
    _districtController.clear();
    _cityController.clear();
    _stateController.clear();
  }

  @override
  void dispose() {
    _cepController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _complementController.dispose();
    _districtController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _cardCpfController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    if (!_navigating) ref.read(checkoutProvider.notifier).reset();
    super.dispose();
  }

  // ─── Lookup de CEP ───────────────────────────────────────────────────────────

  void _onCepChanged(String value) {
    final digits = value.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length == 8) {
      _lookupCep(digits);
    } else if (_cepChecked) {
      setState(() {
        _cepChecked = false;
        _matchedAddress = null;
      });
    }
  }

  void _lookupCep(String digits) {
    final addresses = ref.read(addressesProvider).valueOrNull ?? [];
    final matches = addresses.where(
      (a) => a.zipCode.replaceAll(RegExp(r'[^\d]'), '') == digits,
    );
    final match = matches.isEmpty ? null : matches.first;
    setState(() {
      _matchedAddress = match;
      _cepChecked = true;
      if (match != null) {
        _streetController.text = match.street;
        _numberController.text = match.number;
        _complementController.text = match.complement ?? '';
        _districtController.text = match.district;
        _cityController.text = match.city;
        _stateController.text = match.state;
      } else {
        _streetController.clear();
        _numberController.clear();
        _complementController.clear();
        _districtController.clear();
        _cityController.clear();
        _stateController.clear();
      }
    });
  }

  // ─── Build do endereço ────────────────────────────────────────────────────────

  Address _buildAddress(String id) => Address(
    id: id,
    street: _streetController.text.trim(),
    number: _numberController.text.trim(),
    complement: _complementController.text.trim().isEmpty
        ? null
        : _complementController.text.trim(),
    district: _districtController.text.trim(),
    city: _cityController.text.trim(),
    state: _stateController.text.trim(),
    zipCode: _cepDigits,
  );

  // ─── Orquestração do checkout ─────────────────────────────────────────────────

  Future<void> _handlePlaceOrder() async {
    if (!_canSubmit) return;

    String? finalAddressId;
    String? street, number, complement, district, city, state, zipCode;

    if (_isDelivery) {
      // Caminho rápido: endereço salvo selecionado diretamente
      if (_selectedSavedAddress != null && !_useNewAddress) {
        finalAddressId = _selectedSavedAddress!.id;
      } else if (_matchedAddress != null && !_formModified) {
        // CEP bateu com endereço salvo, sem alterações
        finalAddressId = _matchedAddress!.id;
        zipCode = _cepDigits;
      } else if (_matchedAddress != null && _formModified) {
        final shouldUpdate = await _showConfirmDialog(
          title: context.l10n.checkoutUpdateAddress,
          message: context.l10n.checkoutUpdateAddressMessage,
        );
        if (!mounted) return;
        if (shouldUpdate == true) {
          ref
              .read(addressesProvider.notifier)
              .save(_buildAddress(_matchedAddress!.id))
              .ignore();
        }
        street = _streetController.text.trim();
        number = _numberController.text.trim();
        complement = _complementController.text.trim().isEmpty
            ? null
            : _complementController.text.trim();
        district = _districtController.text.trim();
        city = _cityController.text.trim();
        state = _stateController.text.trim();
      } else {
        final shouldSave = await _showConfirmDialog(
          title: context.l10n.checkoutSaveAddress,
          message: context.l10n.checkoutSaveAddressMessage,
        );
        if (!mounted) return;
        if (shouldSave == true) {
          ref
              .read(addressesProvider.notifier)
              .save(_buildAddress('').copyWith(isPrimary: true))
              .ignore();
        }
        street = _streetController.text.trim();
        number = _numberController.text.trim();
        complement = _complementController.text.trim().isEmpty
            ? null
            : _complementController.text.trim();
        district = _districtController.text.trim();
        city = _cityController.text.trim();
        state = _stateController.text.trim();
      }
    }

    final isCard = _selectedPaymentMethodType == 'credit_card';
    String? cardLastFour;
    if (isCard) {
      final digits = _cardNumberController.text.replaceAll(RegExp(r'[^\d]'), '');
      cardLastFour = digits.length >= 4 ? digits.substring(digits.length - 4) : null;
    }

    await ref
        .read(checkoutProvider.notifier)
        .placeOrder(
          paymentMethodId: _selectedPaymentMethodId!,
          deliveryType: _isDelivery ? 'delivery' : 'pickup',
          addressId: finalAddressId,
          shippingStreet: street,
          shippingNumber: number,
          shippingComplement: complement,
          shippingDistrict: district,
          shippingCity: city,
          shippingState: state,
          shippingZipCode: zipCode,
          cardLastFour: cardLastFour,
          cardBrand: isCard ? _detectedCardBrand : null,
          installments: isCard ? _cardInstallments : null,
        );
  }

  Future<bool?> _showConfirmDialog({
    required String title,
    required String message,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(context.l10n.confirm),
          ),
        ],
      ),
    );
  }

  // ─── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = ref.watch(cartProvider);
    final checkoutState = ref.watch(checkoutProvider);
    final paymentMethodsAsync = ref.watch(paymentMethodsProvider);
    // Pre-fetch de endereços para lookup de CEP ser instantâneo
    ref.watch(addressesProvider);

    ref.listen<CheckoutState>(checkoutProvider, (_, next) {
      if (next.isSuccess && next.result != null && !_navigating) {
        _navigating = true;
        ref.read(checkoutProvider.notifier).reset();
        context.push('/pix', extra: next.result);
      }
      if (next.cartHasChanges) {
        _showCartChangedDialog();
      }
    });

    // Re-dispara o lookup quando os endereços terminam de carregar:
    // cobre o caso em que o usuário digita o CEP antes dos endereços estarem prontos.
    ref.listen<AsyncValue<List<Address>>>(addressesProvider, (_, next) {
      if (next.hasValue && _isDelivery && _cepDigits.length == 8) {
        _lookupCep(_cepDigits);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          context.l10n.checkoutTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: checkoutState.isLoading
          ? _LoadingOverlay(
              message: checkoutState.status == CheckoutStatus.validating
                  ? context.l10n.checkoutValidating
                  : context.l10n.checkoutPlacing,
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Tipo de entrega
                  _DeliverySection(
                    isDelivery: _isDelivery,
                    onChanged: (val) => setState(() {
                      _isDelivery = val;
                      _resetDeliveryState();
                    }),
                  ),

                  // 2. Endereço de entrega
                  if (_isDelivery) ...[
                    // Se tem endereços salvos e não optou por novo → picker
                    if (ref.watch(addressesProvider).valueOrNull?.isNotEmpty ==
                            true &&
                        !_useNewAddress)
                      _SavedAddressPickerSection(
                        addresses:
                            ref.watch(addressesProvider).valueOrNull ?? [],
                        selected: _selectedSavedAddress,
                        onSelect: (addr) =>
                            setState(() => _selectedSavedAddress = addr),
                        onUseNew: () => setState(() {
                          _useNewAddress = true;
                          _selectedSavedAddress = null;
                        }),
                      )
                    else
                      // Sem endereços ou escolheu novo → formulário CEP
                      _CepAddressSection(
                        cepController: _cepController,
                        streetController: _streetController,
                        numberController: _numberController,
                        complementController: _complementController,
                        districtController: _districtController,
                        cityController: _cityController,
                        stateController: _stateController,
                        cepChecked: _cepChecked,
                        matchedAddress: _matchedAddress,
                        onCepChanged: _onCepChanged,
                        onFormChanged: () => setState(() {}),
                        showBackToSaved: _useNewAddress,
                        onBackToSaved: () => setState(() {
                          _useNewAddress = false;
                          _resetDeliveryState();
                        }),
                      ),

                    // Frete quando endereço salvo selecionado
                    if (_selectedSavedAddress != null && !_useNewAddress)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                        child: _ShippingFeeCard(),
                      ),
                  ],

                  // 3. Método de pagamento
                  _PaymentMethodSection(
                    asyncMethods: paymentMethodsAsync,
                    selectedId: _selectedPaymentMethodId,
                    onSelect: (method) => setState(() {
                      _selectedPaymentMethodId = method.id;
                      _selectedPaymentMethodName = method.name;
                      _selectedPaymentMethodType = method.type;
                      // Reset card fields ao trocar método
                      _cardNumberController.clear();
                      _cardHolderController.clear();
                      _cardCpfController.clear();
                      _cardExpiryController.clear();
                      _cardCvvController.clear();
                      _cardInstallments = 1;
                      _detectedCardBrand = null;
                    }),
                    onRetry: () => ref.invalidate(paymentMethodsProvider),
                  ),

                  // 4. Dados do cartão (só quando credit_card selecionado)
                  if (_selectedPaymentMethodType == 'credit_card')
                    _CreditCardSection(
                      numberController: _cardNumberController,
                      holderController: _cardHolderController,
                      cpfController: _cardCpfController,
                      expiryController: _cardExpiryController,
                      cvvController: _cardCvvController,
                      installments: _cardInstallments,
                      detectedBrand: _detectedCardBrand,
                      orderTotal: double.tryParse(_displayTotal) ?? 0,
                      onCardNumberChanged: (digits, brand) => setState(() {
                        _detectedCardBrand = brand;
                      }),
                      onInstallmentsChanged: (v) =>
                          setState(() => _cardInstallments = v),
                      onFormChanged: () => setState(() {}),
                    ),

                  // 5. Resumo do pedido
                  _OrderSummarySection(cart: cart, isDelivery: _isDelivery),

                  // 5. Banner de erro
                  if (checkoutState.errorMessage != null)
                    _ErrorBanner(message: checkoutState.errorMessage!),

                  const SizedBox(height: 100),
                ],
              ),
            ),
      bottomNavigationBar: _PlaceOrderBar(
        displayTotal: _displayTotal,
        isLoading: checkoutState.isLoading,
        canSubmit: _canSubmit,
        buttonLabel: _selectedPaymentMethodName != null
            ? context.l10n.checkoutPayWithMethod(_selectedPaymentMethodName!)
            : context.l10n.checkoutSelectPaymentMethod,
        onTap: checkoutState.isLoading ? null : _handlePlaceOrder,
      ),
    );
  }

  void _showCartChangedDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.checkoutCartChanged),
        content: Text(context.l10n.stockWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(context.l10n.confirm),
          ),
        ],
      ),
    );
  }
}

// ─── Seção de métodos de pagamento ────────────────────────────────────────────

class _PaymentMethodSection extends StatelessWidget {
  const _PaymentMethodSection({
    required this.asyncMethods,
    required this.selectedId,
    required this.onSelect,
    required this.onRetry,
  });

  final AsyncValue<List<PaymentMethod>> asyncMethods;
  final String? selectedId;
  final ValueChanged<PaymentMethod> onSelect;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          Text(
            context.l10n.checkoutPaymentMethod,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black54,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          asyncMethods.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: LinearProgressIndicator(),
            ),
            error: (_, _) => Center(
              child: TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(context.l10n.retry),
              ),
            ),
            data: (methods) {
              final active = methods.where((m) => m.isActive).toList();
              if (active.isEmpty) {
                return Text(
                  context.l10n.checkoutNoPaymentMethods,
                  style: TextStyle(color: Colors.grey[600]),
                );
              }
              return Column(
                children: active
                    .map(
                      (method) => _PaymentMethodCard(
                        method: method,
                        isSelected: method.id == selectedId,
                        onTap: () => onSelect(method),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  final PaymentMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  IconData _iconFor(String type) => switch (type.toLowerCase()) {
    'pix' => Icons.pix,
    'boleto' => Icons.receipt_long_outlined,
    'credit_card' || 'credit' => Icons.credit_card_outlined,
    'debit_card' || 'debit' => Icons.payment_outlined,
    _ => Icons.attach_money,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.06)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : Colors.grey[200]!,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? theme.colorScheme.primary : Colors.grey[400],
              size: 20,
            ),
            const SizedBox(width: 12),
            Icon(
              _iconFor(method.type),
              color: isSelected ? theme.colorScheme.primary : Colors.grey[600],
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              method.name,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.black87 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Seção de tipo de entrega ─────────────────────────────────────────────────

class _DeliverySection extends StatelessWidget {
  const _DeliverySection({required this.isDelivery, required this.onChanged});

  final bool isDelivery;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.checkoutDeliverySection,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black54,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: SegmentedButton<bool>(
              segments: [
                ButtonSegment(
                  value: true,
                  label: Text(context.l10n.deliveryHome),
                  icon: const Icon(Icons.home_outlined),
                ),
                ButtonSegment(
                  value: false,
                  label: Text(context.l10n.deliveryPickup),
                  icon: const Icon(Icons.store_outlined),
                ),
              ],
              selected: {isDelivery},
              onSelectionChanged: (s) => onChanged(s.first),
              style: ButtonStyle(iconSize: WidgetStateProperty.all(16)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Seletor de endereço salvo ────────────────────────────────────────────────

class _SavedAddressPickerSection extends StatelessWidget {
  const _SavedAddressPickerSection({
    required this.addresses,
    required this.selected,
    required this.onSelect,
    required this.onUseNew,
  });

  final List<Address> addresses;
  final Address? selected;
  final ValueChanged<Address> onSelect;
  final VoidCallback onUseNew;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          Text(
            context.l10n.checkoutSavedAddresses,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black54,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          ...addresses.map((addr) {
            final isSelected = selected?.id == addr.id;
            return GestureDetector(
              onTap: () => onSelect(addr),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withValues(alpha: 0.06)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : Colors.grey[200]!,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : Colors.grey[400],
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${addr.street}, ${addr.number}'
                            '${addr.complement != null ? ' — ${addr.complement}' : ''}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: isSelected
                                  ? Colors.black87
                                  : Colors.black54,
                            ),
                          ),
                          Text(
                            '${addr.district} · ${addr.city}/${addr.state}',
                            style:
                                TextStyle(fontSize: 12, color: Colors.grey[500]),
                          ),
                          Text(
                            'CEP ${_fmt(addr.zipCode)}',
                            style:
                                TextStyle(fontSize: 11, color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    ),
                    if (addr.isPrimary)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          context.l10n.primaryAddress,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 4),
          TextButton.icon(
            onPressed: onUseNew,
            icon: const Icon(Icons.add_location_alt_outlined, size: 16),
            label: Text(context.l10n.checkoutUseNewAddress),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              foregroundColor: theme.colorScheme.primary,
              textStyle:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(String zip) {
    final d = zip.replaceAll(RegExp(r'[^\d]'), '');
    return d.length == 8 ? '${d.substring(0, 5)}-${d.substring(5)}' : zip;
  }
}

// ─── Seção de CEP + formulário de endereço ────────────────────────────────────

class _CepAddressSection extends StatelessWidget {
  const _CepAddressSection({
    required this.cepController,
    required this.streetController,
    required this.numberController,
    required this.complementController,
    required this.districtController,
    required this.cityController,
    required this.stateController,
    required this.cepChecked,
    required this.matchedAddress,
    required this.onCepChanged,
    required this.onFormChanged,
    this.showBackToSaved = false,
    this.onBackToSaved,
  });

  final TextEditingController cepController;
  final TextEditingController streetController;
  final TextEditingController numberController;
  final TextEditingController complementController;
  final TextEditingController districtController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final bool cepChecked;
  final Address? matchedAddress;
  final ValueChanged<String> onCepChanged;
  final VoidCallback onFormChanged;
  final bool showBackToSaved;
  final VoidCallback? onBackToSaved;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          if (showBackToSaved && onBackToSaved != null)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onBackToSaved,
                icon: const Icon(Icons.arrow_back_ios_rounded, size: 14),
                label: Text(context.l10n.checkoutSavedAddresses),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  foregroundColor: theme.colorScheme.primary,
                  textStyle: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          Text(
            context.l10n.checkoutCepLabel,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black54,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),

          // Campo CEP
          TextFormField(
            controller: cepController,
            keyboardType: TextInputType.number,
            inputFormatters: [CepInputFormatter()],
            onChanged: onCepChanged,
            decoration: InputDecoration(
              labelText: context.l10n.addressZip,
              hintText: '00000-000',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.location_on_outlined),
            ),
          ),

          // Chip de status após digitar 8 dígitos
          if (cepChecked) ...[
            const SizedBox(height: 8),
            _CepStatusChip(found: matchedAddress != null),
          ],

          // Formulário de endereço (aparece após CEP válido)
          if (cepChecked) ...[
            const SizedBox(height: 12),
            _AddressFormFields(
              streetController: streetController,
              numberController: numberController,
              complementController: complementController,
              districtController: districtController,
              cityController: cityController,
              stateController: stateController,
              onChanged: onFormChanged,
            ),
            const SizedBox(height: 12),
            _ShippingFeeCard(),
          ],
        ],
      ),
    );
  }
}

class _CepStatusChip extends StatelessWidget {
  const _CepStatusChip({required this.found});
  final bool found;

  @override
  Widget build(BuildContext context) {
    final color = found ? Colors.green : Colors.orange;
    final label = found
        ? context.l10n.checkoutCepFound
        : context.l10n.checkoutCepNotFound;
    final icon = found ? Icons.check_circle_outline : Icons.info_outline;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressFormFields extends StatelessWidget {
  const _AddressFormFields({
    required this.streetController,
    required this.numberController,
    required this.complementController,
    required this.districtController,
    required this.cityController,
    required this.stateController,
    required this.onChanged,
  });

  final TextEditingController streetController;
  final TextEditingController numberController;
  final TextEditingController complementController;
  final TextEditingController districtController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Rua
        TextFormField(
          controller: streetController,
          onChanged: (_) => onChanged(),
          decoration: InputDecoration(
            labelText: context.l10n.addressStreet,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),

        // Número e Complemento
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: numberController,
                keyboardType: TextInputType.number,
                onChanged: (_) => onChanged(),
                decoration: InputDecoration(
                  labelText: context.l10n.addressNumber,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: complementController,
                onChanged: (_) => onChanged(),
                decoration: InputDecoration(
                  labelText: context.l10n.addressComplement,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Bairro
        TextFormField(
          controller: districtController,
          onChanged: (_) => onChanged(),
          decoration: InputDecoration(
            labelText: context.l10n.addressDistrict,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),

        // Cidade e Estado
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: cityController,
                onChanged: (_) => onChanged(),
                decoration: InputDecoration(
                  labelText: context.l10n.addressCity,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: stateController,
                onChanged: (_) => onChanged(),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(2),
                  UpperCaseTextFormatter(),
                ],
                decoration: InputDecoration(
                  labelText: context.l10n.addressState,
                  border: const OutlineInputBorder(),
                  hintText: 'SP',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Seção de cartão de crédito ──────────────────────────────────────────────

class _CreditCardSection extends StatelessWidget {
  const _CreditCardSection({
    required this.numberController,
    required this.holderController,
    required this.cpfController,
    required this.expiryController,
    required this.cvvController,
    required this.installments,
    required this.detectedBrand,
    required this.orderTotal,
    required this.onCardNumberChanged,
    required this.onInstallmentsChanged,
    required this.onFormChanged,
  });

  final TextEditingController numberController;
  final TextEditingController holderController;
  final TextEditingController cpfController;
  final TextEditingController expiryController;
  final TextEditingController cvvController;
  final int installments;
  final String? detectedBrand;
  final double orderTotal;
  final void Function(String digits, String? brand) onCardNumberChanged;
  final ValueChanged<int> onInstallmentsChanged;
  final VoidCallback onFormChanged;

  static String? _detectBrand(String digits) {
    if (digits.isEmpty) return null;
    if (digits.startsWith('4')) return 'Visa';
    if (digits.length >= 2) {
      final two = int.tryParse(digits.substring(0, 2)) ?? 0;
      if (two >= 51 && two <= 55) return 'Mastercard';
    }
    if (digits.length >= 4) {
      final four = int.tryParse(digits.substring(0, 4)) ?? 0;
      if (four >= 2221 && four <= 2720) return 'Mastercard';
    }
    if (digits.startsWith('34') || digits.startsWith('37')) {
      return 'American Express';
    }
    if (digits.startsWith('6062') || digits.startsWith('384') ||
        digits.startsWith('385') || digits.startsWith('386')) {
      return 'Hipercard';
    }
    if (digits.startsWith('636368') || digits.startsWith('4576') ||
        digits.startsWith('4011') || digits.startsWith('6363')) {
      return 'Elo';
    }
    return null;
  }

  // Arredonda para cima em 2 casas decimais
  static double _ceilCents(double value) =>
      (value * 100).ceilToDouble() / 100;

  String _installmentLabel(int n) {
    if (orderTotal <= 0) return n == 1 ? 'À vista' : '$n× sem juros';
    final per = _ceilCents(orderTotal / n);
    final perFmt = per.toStringAsFixed(2).replaceAll('.', ',');
    final totalFmt = orderTotal.toStringAsFixed(2).replaceAll('.', ',');
    if (n == 1) return '1× R\$ $totalFmt (à vista)';
    return '$n× R\$ $perFmt sem juros (total R\$ $totalFmt)';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = OutlineInputBorder(borderRadius: BorderRadius.circular(12));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          Text(
            'Dados do cartão',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black54,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),

          // Número do cartão
          TextFormField(
            controller: numberController,
            keyboardType: TextInputType.number,
            inputFormatters: [_CardNumberFormatter()],
            onChanged: (v) {
              final digits = v.replaceAll(' ', '');
              onCardNumberChanged(digits, _detectBrand(digits));
              onFormChanged();
            },
            decoration: InputDecoration(
              labelText: 'Número do cartão',
              hintText: '0000 0000 0000 0000',
              prefixIcon: const Icon(Icons.credit_card_outlined),
              suffixText: detectedBrand,
              suffixStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
                fontSize: 12,
              ),
              border: border,
              counterText: '',
            ),
          ),
          const SizedBox(height: 10),

          // Nome do titular
          TextFormField(
            controller: holderController,
            onChanged: (_) => onFormChanged(),
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText: 'Nome do titular (como no cartão)',
              prefixIcon: const Icon(Icons.person_outline),
              border: border,
            ),
          ),
          const SizedBox(height: 10),

          // CPF do titular
          TextFormField(
            controller: cpfController,
            onChanged: (v) {
              final formatted = _formatCpf(v);
              if (formatted != v) {
                cpfController.value = TextEditingValue(
                  text: formatted,
                  selection:
                      TextSelection.collapsed(offset: formatted.length),
                );
              }
              onFormChanged();
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'CPF do titular',
              hintText: '000.000.000-00',
              prefixIcon: const Icon(Icons.badge_outlined),
              border: border,
              counterText: '',
            ),
            maxLength: 14,
          ),
          const SizedBox(height: 10),

          // Validade + CVV (linha)
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: expiryController,
                  onChanged: (v) {
                    final formatted = _formatExpiry(v);
                    if (formatted != v) {
                      expiryController.value = TextEditingValue(
                        text: formatted,
                        selection: TextSelection.collapsed(
                            offset: formatted.length),
                      );
                    }
                    onFormChanged();
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Validade',
                    hintText: 'MM/AA',
                    prefixIcon: const Icon(Icons.date_range_outlined),
                    border: border,
                    counterText: '',
                  ),
                  maxLength: 5,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: cvvController,
                  onChanged: (_) => onFormChanged(),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    hintText: '•••',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: border,
                    counterText: '',
                  ),
                  maxLength: 4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Parcelas (dropdown) — key força rebuild ao resetar installments externamente
          DropdownButtonFormField<int>(
            key: ValueKey(installments),
            initialValue: installments,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'Parcelas',
              prefixIcon: const Icon(Icons.calendar_month_outlined),
              border: border,
            ),
            items: List.generate(
              12,
              (i) => DropdownMenuItem(
                value: i + 1,
                child: Text(
                  _installmentLabel(i + 1),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            onChanged: (v) {
              if (v != null) onInstallmentsChanged(v);
            },
          ),
        ],
      ),
    );
  }

  String _formatCpf(String raw) {
    final d = raw.replaceAll(RegExp(r'[^\d]'), '');
    if (d.length <= 3) return d;
    if (d.length <= 6) return '${d.substring(0, 3)}.${d.substring(3)}';
    if (d.length <= 9) {
      return '${d.substring(0, 3)}.${d.substring(3, 6)}.${d.substring(6)}';
    }
    final end = d.length > 11 ? 11 : d.length;
    return '${d.substring(0, 3)}.${d.substring(3, 6)}.${d.substring(6, 9)}-${d.substring(9, end)}';
  }

  String _formatExpiry(String raw) {
    final d = raw.replaceAll(RegExp(r'[^\d]'), '');
    if (d.length <= 2) return d;
    final end = d.length > 4 ? 4 : d.length;
    return '${d.substring(0, 2)}/${d.substring(2, end)}';
  }
}

// ─── Formatter do número do cartão ───────────────────────────────────────────

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue old,
    TextEditingValue value,
  ) {
    final digits = value.text
        .replaceAll(RegExp(r'[^\d]'), '')
        .substring(0, value.text.replaceAll(RegExp(r'[^\d]'), '').length > 16
            ? 16
            : value.text.replaceAll(RegExp(r'[^\d]'), '').length);
    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buf.write(' ');
      buf.write(digits[i]);
    }
    final formatted = buf.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _ShippingFeeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_shipping_outlined,
            color: Colors.green[700],
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            context.l10n.checkoutShippingFee,
            style: TextStyle(
              color: Colors.green[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            'R\$ ${_kShippingFee.toStringAsFixed(2)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Resumo do pedido ─────────────────────────────────────────────────────────

class _OrderSummarySection extends StatelessWidget {
  const _OrderSummarySection({required this.cart, required this.isDelivery});
  final CartState cart;
  final bool isDelivery;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = double.tryParse(cart.computedTotal) ?? 0.0;
    final total = isDelivery ? base + _kShippingFee : base;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          Text(
            context.l10n.checkoutTitle,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black54,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          ...cart.items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${item.quantity}× ${item.product.name}',
                      style: const TextStyle(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'R\$ ${item.subtotal}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isDelivery) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.checkoutShippingFee,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                Text(
                  'R\$ ${_kShippingFee.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.total,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'R\$ ${total.toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Banner de erro ───────────────────────────────────────────────────────────

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red[200]!),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[700], size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.red[700], fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Loading overlay ──────────────────────────────────────────────────────────

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

// ─── Barra de pagamento ───────────────────────────────────────────────────────

class _PlaceOrderBar extends StatelessWidget {
  const _PlaceOrderBar({
    required this.displayTotal,
    required this.isLoading,
    required this.canSubmit,
    required this.buttonLabel,
    required this.onTap,
  });

  final String displayTotal;
  final bool isLoading;
  final bool canSubmit;
  final String buttonLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.total,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.black54,
                  ),
                ),
                Text(
                  'R\$ $displayTotal',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canSubmit && !isLoading ? onTap : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  buttonLabel,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

