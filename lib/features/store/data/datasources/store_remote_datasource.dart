/// Store remote datasource for API communication
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../models/product_model.dart';

abstract class StoreRemoteDatasource {
  Future<List<ProductModel>> getProducts({
    String? categoryId,
    bool? isHighlighted,
    String? search,
    int? perPage,
  });

  Future<List<CategoryModel>> getCategories({
    bool? isHighlighted,
    bool withCount = false,
  });
}

class StoreRemoteDatasourceImpl implements StoreRemoteDatasource {
  StoreRemoteDatasourceImpl({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  Map<String, String> _getHeaders() {
    return {'Content-Type': 'application/json', 'Accept': 'application/json'};
  }

  @override
  Future<List<ProductModel>> getProducts({
    String? categoryId,
    bool? isHighlighted,
    String? search,
    int? perPage,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (categoryId != null) queryParams['category_id'] = categoryId;
      if (isHighlighted != null) {
        queryParams['is_highlighted'] = isHighlighted.toString();
      }
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (perPage != null) queryParams['per_page'] = perPage.toString();

      final uri = Uri.parse(
        '${ApiConfig.baseUrl}/products',
      ).replace(queryParameters: queryParams.isEmpty ? null : queryParams);

      print('🔵 [PRODUCTS] Chamando URL: $uri');

      final response = await _httpClient.get(uri, headers: _getHeaders());

      print('🔵 [PRODUCTS] Status Code: ${response.statusCode}');
      print('🔵 [PRODUCTS] Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final products = (data['data'] as List)
            .map((json) => ProductModel.fromJson(json))
            .toList();
        print('🔵 [PRODUCTS] Produtos carregados: ${products.length}');
        return products;
      } else {
        throw Exception(
          'Failed to load products: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('🔴 [PRODUCTS ERROR] $e');
      throw Exception('Error loading products: $e');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories({
    bool? isHighlighted,
    bool withCount = false,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (isHighlighted != null) {
        queryParams['is_highlighted'] = isHighlighted.toString();
      }
      if (withCount) queryParams['with_count'] = 'true';

      final uri = Uri.parse(
        '${ApiConfig.baseUrl}/categories',
      ).replace(queryParameters: queryParams.isEmpty ? null : queryParams);

      print('🟢 [CATEGORIES] Chamando URL: $uri');

      final response = await _httpClient.get(uri, headers: _getHeaders());

      print('🟢 [CATEGORIES] Status Code: ${response.statusCode}');
      print('🟢 [CATEGORIES] Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final categories = (data['data'] as List)
            .map((json) => CategoryModel.fromJson(json))
            .toList();
        print('🟢 [CATEGORIES] Categorias carregadas: ${categories.length}');
        return categories;
      } else {
        throw Exception(
          'Failed to load categories: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('🔴 [CATEGORIES ERROR] $e');
      throw Exception('Error loading categories: $e');
    }
  }
}
