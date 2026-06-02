/// Favorite data model (API ↔ Domain)
library;

import '../../domain/entities/favorite.dart';
import '../../../store/data/models/product_model.dart';

class FavoriteModel extends Favorite {
  const FavoriteModel({
    required super.id,
    required super.product,
    required super.createdAt,
    super.notifyOnRestock,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'] as String,
      product: ProductModel.fromJson(
        json['product'] as Map<String, dynamic>,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      notifyOnRestock: json['notify_on_restock'] as bool? ?? false,
    );
  }
}
