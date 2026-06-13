library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/network/http_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/page_meta.dart';
import '../models/admin_promotion_model.dart';

class AdminPromotionsRemoteDatasource {
  AdminPromotionsRemoteDatasource({
    http.Client? httpClient,
    SecureStorage? secureStorage,
  }) : _client = DoglioHttpClient(
          httpClient: httpClient,
          secureStorage: secureStorage,
        );

  final DoglioHttpClient _client;

  /// GET /admin/promotions — lista paginada com filtros opcionais.
  Future<(List<AdminPromotionModel>, PageMeta)> getPromotions({
    bool? isActive,
    bool? expired,
    String? search,
    List<String>? productIds,
    int page = 1,
    int perPage = 20,
  }) async {
    final query = <String, String>{
      'page': '$page',
      'per_page': '$perPage',
      if (isActive != null) 'is_active': isActive ? '1' : '0',
      if (expired != null) 'expired': expired ? '1' : '0',
      if (search != null && search.isNotEmpty) 'search': search,
      // product_ids[] enviados como parâmetros indexados
      if (productIds != null)
        for (var i = 0; i < productIds.length; i++)
          'product_ids[$i]': productIds[i],
    };

    final response = await _client.send(
      'GET',
      '/admin/promotions',
      queryParams: query,
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = (body['data'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(AdminPromotionModel.fromJson)
        .toList();
    final meta = _parseMeta(body['meta'] as Map<String, dynamic>?);
    return (data, meta);
  }

  /// GET /admin/promotions/{id}.
  Future<AdminPromotionModel> getPromotion(String id) async {
    final response = await _client.send('GET', '/admin/promotions/$id');
    return _parseSingle(response.body);
  }

  /// POST /admin/promotions.
  Future<AdminPromotionModel> createPromotion(
    AdminPromotionModel model, {
    List<({String productId, int? useLimit})>? initialProducts,
  }) async {
    final response = await _client.send(
      'POST',
      '/admin/promotions',
      body: model.toCreateJson(initialProducts: initialProducts),
    );
    return _parseSingle(response.body);
  }

  /// PUT /admin/promotions/{id} — sem product_ids.
  Future<AdminPromotionModel> updatePromotion(AdminPromotionModel model) async {
    final response = await _client.send(
      'PUT',
      '/admin/promotions/${model.id}',
      body: model.toJson(),
    );
    return _parseSingle(response.body);
  }

  /// DELETE /admin/promotions/{id}.
  Future<void> deletePromotion(String id) async {
    await _client.send('DELETE', '/admin/promotions/$id');
  }

  /// POST /admin/promotions/{id}/products — vincula/atualiza produtos.
  Future<AdminPromotionModel> linkProducts(
    String id,
    List<({String productId, int? useLimit})> products,
  ) async {
    final body = {
      'products': products
          .map((p) => {
                'id': p.productId,
                if (p.useLimit != null) 'use_limit': p.useLimit,
              })
          .toList(),
    };

    final response = await _client.send(
      'POST',
      '/admin/promotions/$id/products',
      body: body,
    );
    return _parseSingleOrFetch(id, response.body);
  }

  /// DELETE /admin/promotions/{id}/products — desvincula produtos (body JSON).
  Future<AdminPromotionModel> unlinkProducts(
    String id,
    List<String> productIds,
  ) async {
    final response = await _client.send(
      'DELETE',
      '/admin/promotions/$id/products',
      body: {'product_ids': productIds},
    );
    return _parseSingleOrFetch(id, response.body);
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  AdminPromotionModel _parseSingle(String responseBody) {
    final body = jsonDecode(responseBody) as Map<String, dynamic>;
    return AdminPromotionModel.fromJson(body['data'] as Map<String, dynamic>);
  }

  /// Tenta parsear a resposta; se body vazio ou data==null, re-faz GET da promoção.
  Future<AdminPromotionModel> _parseSingleOrFetch(
      String promotionId, String responseBody) async {
    if (responseBody.isNotEmpty) {
      try {
        final body = jsonDecode(responseBody) as Map<String, dynamic>;
        final data = body['data'];
        if (data != null) {
          return AdminPromotionModel.fromJson(data as Map<String, dynamic>);
        }
      } catch (_) {}
    }
    return getPromotion(promotionId);
  }

  PageMeta _parseMeta(Map<String, dynamic>? meta) {
    if (meta == null) return PageMeta.empty;
    return PageMeta(
      currentPage: (meta['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (meta['last_page'] as num?)?.toInt() ?? 1,
      total: (meta['total'] as num?)?.toInt() ?? 0,
    );
  }
}
