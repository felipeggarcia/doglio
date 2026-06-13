/// Datasource remoto dos produtos admin — chamadas HTTP a `/admin/products`.
///
/// Create/update usam multipart/form-data (imagens). PHP não parseia
/// multipart em PUT real, então o update é POST com `_method=PUT`.
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/network/http_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/admin_product_filters.dart';
import '../../domain/entities/page_meta.dart';
import '../models/admin_product_model.dart';
import '../models/stock_movement_model.dart';

class AdminProductsRemoteDatasource {
  AdminProductsRemoteDatasource({
    http.Client? httpClient,
    SecureStorage? secureStorage,
  }) : _client = DoglioHttpClient(
          httpClient: httpClient,
          secureStorage: secureStorage,
        );

  final DoglioHttpClient _client;

  /// GET /admin/products com filtros e paginação.
  Future<(List<AdminProductModel>, PageMeta)> getProducts({
    AdminProductFilters filters = AdminProductFilters.empty,
    int page = 1,
    int perPage = 20,
  }) async {
    final dateFormat = DateFormat('yyyy-MM-dd');
    // Valores podem ser String ou Iterable<String> (arrays como
    // `category_ids[]`) — Uri.replace aceita ambos.
    final query = <String, dynamic>{
      'page': '$page',
      'per_page': '$perPage',
      if (filters.search.isNotEmpty) 'search': filters.search,
      if (filters.isActive != null)
        'is_active': filters.isActive! ? '1' : '0',
      if (filters.isHighlighted != null)
        'is_highlighted': filters.isHighlighted! ? '1' : '0',
      if (filters.outOfStock != null)
        'out_of_stock': filters.outOfStock! ? '1' : '0',
      if (filters.categoryIds.isNotEmpty) 'category_ids[]': filters.categoryIds,
      if (filters.priceMin != null) 'price_min': filters.priceMin,
      if (filters.priceMax != null) 'price_max': filters.priceMax,
      if (filters.dateFrom != null)
        'date_from': dateFormat.format(filters.dateFrom!),
      if (filters.dateTo != null) 'date_to': dateFormat.format(filters.dateTo!),
      'sort_by': filters.sortBy.toApi(),
      'sort_order': filters.sortDesc ? 'desc' : 'asc',
    };

    // category_ids[] needs List values — build URI manually then strip base URL
    // so send() can re-prepend it (Uri.replace(queryParameters: null) preserves params).
    final uri = Uri.parse('${ApiConfig.baseUrl}/admin/products')
        .replace(queryParameters: query);
    final endpoint = uri.toString().substring(ApiConfig.baseUrl.length);

    final response = await _client.send('GET', endpoint);

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = (body['data'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(AdminProductModel.fromJson)
        .toList();
    final meta = _parseMeta(body['meta'] as Map<String, dynamic>?);
    return (data, meta);
  }

  /// POST /admin/products (multipart).
  Future<AdminProductModel> createProduct(
    AdminProductModel product, {
    required List<String> imagePaths,
  }) async {
    final response = await _client.sendMultipart(
      await _buildMultipartRequest(
        Uri.parse('${ApiConfig.baseUrl}/admin/products'),
        fields: product.toMultipartFields(),
        imagePaths: imagePaths,
      ),
    );
    return _parseSingle(response.body);
  }

  /// PUT /admin/products/{id} via POST multipart + `_method=PUT`.
  Future<AdminProductModel> updateProduct(
    AdminProductModel product, {
    required List<String> imagePaths,
    required List<String> removeImageIds,
    List<String> imageOrder = const [],
  }) async {
    final response = await _client.sendMultipart(
      await _buildMultipartRequest(
        Uri.parse('${ApiConfig.baseUrl}/admin/products/${product.id}'),
        fields: product.toMultipartFields(
          forUpdate: true,
          removeImageIds: removeImageIds,
          imageOrder: imageOrder,
        ),
        imagePaths: imagePaths,
      ),
    );
    return _parseSingle(response.body);
  }

  /// DELETE /admin/products/{id} (soft delete).
  Future<void> deleteProduct(String id) async {
    await _client.send('DELETE', '/admin/products/$id');
  }

  /// GET /admin/products/{id}/stock — histórico paginado.
  Future<(List<StockMovementModel>, PageMeta)> getStockMovements(
    String id, {
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await _client.send(
      'GET',
      '/admin/products/$id/stock',
      queryParams: {'page': '$page', 'per_page': '$perPage'},
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = (body['data'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(StockMovementModel.fromJson)
        .toList();
    final meta = _parseMeta(body['meta'] as Map<String, dynamic>?);
    return (data, meta);
  }

  /// POST /admin/products/{id}/stock — JSON normal (não multipart).
  /// Modo delta: `type` + `quantity`. Modo absoluto: `absolute`.
  Future<StockMovementModel> adjustStock(
    String id, {
    String? type,
    int? quantity,
    int? absolute,
    required String reason,
    String? notes,
  }) async {
    final body = <String, dynamic>{
      'type': ?type,
      'quantity': ?quantity,
      'absolute': ?absolute,
      'reason': reason,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    };

    final response = await _client.send(
      'POST',
      '/admin/products/$id/stock',
      body: body,
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return StockMovementModel.fromJson(
      decoded['data'] as Map<String, dynamic>? ?? const {},
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  /// Builds a multipart POST request without auth headers (sendMultipart injects them).
  Future<http.MultipartRequest> _buildMultipartRequest(
    Uri uri, {
    required Map<String, String> fields,
    required List<String> imagePaths,
  }) async {
    final request = http.MultipartRequest('POST', uri)..fields.addAll(fields);
    for (final path in imagePaths) {
      request.files.add(await http.MultipartFile.fromPath('images[]', path));
    }
    return request;
  }

  AdminProductModel _parseSingle(String responseBody) {
    final body = jsonDecode(responseBody) as Map<String, dynamic>;
    return AdminProductModel.fromJson(body['data'] as Map<String, dynamic>);
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
