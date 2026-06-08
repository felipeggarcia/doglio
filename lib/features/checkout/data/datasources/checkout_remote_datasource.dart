library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/checkout_result.dart';
import '../../domain/entities/payment.dart';
import '../../domain/entities/payment_method.dart';

class CheckoutRemoteDatasource {
  CheckoutRemoteDatasource({
    http.Client? httpClient,
    SecureStorage? secureStorage,
  })  : _httpClient = httpClient ?? http.Client(),
        _secureStorage = secureStorage ?? SecureStorage();

  final http.Client _httpClient;
  final SecureStorage _secureStorage;

  Future<Map<String, String>> _authHeaders() async {
    final token = await _secureStorage.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Host': ApiConfig.virtualHost,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Map<String, String> get _publicHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Host': ApiConfig.virtualHost,
      };

  Future<List<PaymentMethod>> getPaymentMethods() async {
    final response = await _httpClient
        .get(
          Uri.parse('${ApiConfig.baseUrl}/payment_methods'),
          headers: _publicHeaders,
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != 200) {
      throw Exception(
          'Falha ao carregar métodos de pagamento: ${response.statusCode}');
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = (body['data'] as List<dynamic>).cast<Map<String, dynamic>>();
    return data
        .map(
          (json) => PaymentMethod(
            id: json['id'] as String,
            name: json['name'] as String,
            type: json['type'] as String,
            isActive: json['is_active'] as bool? ?? true,
          ),
        )
        .toList();
  }

  /// Retorna `true` se o carrinho está válido, `false` se há mudanças.
  Future<bool> validateCart() async {
    final response = await _httpClient
        .get(
          Uri.parse('${ApiConfig.baseUrl}/cart/validate'),
          headers: await _authHeaders(),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != 200) {
      throw Exception('Falha ao validar carrinho: ${response.statusCode}');
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return body['valid'] as bool? ?? true;
  }

  Future<CheckoutResult> placeOrder({
    required String paymentMethodId,
    required String deliveryType,
    String? addressId,
    String? shippingStreet,
    String? shippingNumber,
    String? shippingComplement,
    String? shippingDistrict,
    String? shippingCity,
    String? shippingState,
    String? shippingZipCode,
    String? cardLastFour,
    String? cardBrand,
    int? installments,
  }) async {
    final payload = <String, dynamic>{
      'payment_method_id': paymentMethodId,
      'delivery_type': deliveryType,
    };

    if (addressId != null) {
      payload['address_id'] = addressId;
    } else {
      if (shippingStreet != null) payload['shipping_street'] = shippingStreet;
      if (shippingNumber != null) payload['shipping_number'] = shippingNumber;
      if (shippingComplement != null) {
        payload['shipping_complement'] = shippingComplement;
      }
      if (shippingDistrict != null) payload['shipping_district'] = shippingDistrict;
      if (shippingCity != null) payload['shipping_city'] = shippingCity;
      if (shippingState != null) payload['shipping_state'] = shippingState;
      if (shippingZipCode != null) payload['shipping_zip_code'] = shippingZipCode;
    }

    if (cardLastFour != null) payload['card_last_four'] = cardLastFour;
    if (cardBrand != null) payload['card_brand'] = cardBrand;
    if (installments != null) payload['installments'] = installments;

    final response = await _httpClient
        .post(
          Uri.parse('${ApiConfig.baseUrl}/checkout'),
          headers: await _authHeaders(),
          body: jsonEncode(payload),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode == 401) {
      throw Exception('Não autenticado');
    }

    if (response.statusCode == 422) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final errorCode =
          (body['error'] as Map<String, dynamic>?)?['code'] as String? ??
              'VALIDATION_ERROR';
      throw Exception(errorCode);
    }

    if (response.statusCode != 201) {
      throw Exception('Falha ao criar pedido: ${response.statusCode}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;

    final paymentData = data['payment'] as Map<String, dynamic>?;
    final methodData = paymentData?['payment_method'] as Map<String, dynamic>?;
    final paymentType =
        (methodData?['type'] ?? paymentData?['type'] ?? 'pix') as String;

    final payment = paymentData != null
        ? Payment(
            type: paymentType,
            status: paymentData['status'] as String? ?? 'pending',
            amount: paymentData['amount']?.toString(),
            // PIX
            pixCode: paymentData['pix_code'] as String?,
            pixQrCode: paymentData['pix_qr_code'] as String?,
            pixExpiresAt: _parseDate(paymentData['pix_expires_at']),
            // Boleto
            boletoCode: paymentData['boleto_code'] as String?,
            boletoExpiresAt: _parseDate(paymentData['boleto_expires_at']),
            // Cartão
            cardLastFour: paymentData['card_last_four'] as String?,
            cardBrand: paymentData['card_brand'] as String?,
            installments: paymentData['installments'] as int?,
          )
        : null;

    final orderId = (data['id'] ?? '').toString();
    final orderNumber = data['order_number'] as String?;
    final orderTotal =
        (data['total_amount'] ?? data['total'] ?? data['amount'] ?? '0')
            .toString();

    return CheckoutResult(
      orderId: orderId,
      orderNumber: orderNumber,
      orderTotal: orderTotal,
      payment: payment,
    );
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
