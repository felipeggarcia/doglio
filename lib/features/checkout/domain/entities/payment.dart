library;

class Payment {
  const Payment({
    required this.type,
    required this.status,
    this.amount,
    // PIX
    this.pixCode,
    this.pixQrCode,
    this.pixExpiresAt,
    // Boleto
    this.boletoCode,
    this.boletoExpiresAt,
    // Cartão
    this.cardLastFour,
    this.cardBrand,
    this.installments,
  });

  final String type;   // 'pix' | 'boleto' | 'credit_card'
  final String status;
  final String? amount;

  // PIX
  final String? pixCode;
  final String? pixQrCode;   // base64 PNG puro (sem prefixo data:image)
  final DateTime? pixExpiresAt;

  // Boleto
  final String? boletoCode;
  final DateTime? boletoExpiresAt;

  // Cartão de crédito
  final String? cardLastFour;
  final String? cardBrand;
  final int? installments;

  bool get isPix => type == 'pix';
  bool get isBoleto => type == 'boleto';
  bool get isCreditCard => type == 'credit_card';
}
