library;

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/favorite.dart';
import '../../../store/data/models/product_model.dart';

part 'favorite_model.freezed.dart';
part 'favorite_model.g.dart';

@freezed
abstract class FavoriteModel with _$FavoriteModel {
  const FavoriteModel._();

  const factory FavoriteModel({
    required String id,
    required ProductModel product,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'notify_on_restock', defaultValue: false)
    required bool notifyOnRestock,
  }) = _FavoriteModel;

  factory FavoriteModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteModelFromJson(json);

  Favorite toEntity() => Favorite(
        id: id,
        product: product.toEntity(),
        createdAt: createdAt,
        notifyOnRestock: notifyOnRestock,
      );
}
