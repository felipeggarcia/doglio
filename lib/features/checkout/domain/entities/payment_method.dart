library;

class PaymentMethod {
  const PaymentMethod({
    required this.id,
    required this.name,
    required this.type,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String type;
  final bool isActive;
}
