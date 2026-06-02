/// Favorite entity
library;

import '../../../store/domain/entities/product.dart';

class Favorite {
  const Favorite({
    required this.id,
    required this.product,
    required this.createdAt,
    this.notifyOnRestock = false,
  });

  final String id;
  final Product product;
  final DateTime createdAt;
  final bool notifyOnRestock;
}
