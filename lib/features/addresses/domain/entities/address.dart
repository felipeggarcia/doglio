/// Address domain entity
library;

class Address {
  const Address({
    required this.id,
    required this.street,
    required this.number,
    required this.district,
    required this.city,
    required this.state,
    required this.zipCode,
    this.complement,
    this.country = 'Brasil',
    this.isPrimary = false,
  });

  final String id;
  final String street;
  final String number;
  final String? complement;
  final String district;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final bool isPrimary;

  Address copyWith({
    String? id,
    String? street,
    String? number,
    String? complement,
    String? district,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    bool? isPrimary,
  }) {
    return Address(
      id: id ?? this.id,
      street: street ?? this.street,
      number: number ?? this.number,
      complement: complement ?? this.complement,
      district: district ?? this.district,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }

  @override
  bool operator ==(Object other) => other is Address && other.id == id;
  @override
  int get hashCode => id.hashCode;
}
