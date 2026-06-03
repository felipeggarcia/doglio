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
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Host': ApiConfig.virtualHost,
    };
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

      final response = await _httpClient
          .get(uri, headers: _getHeaders())
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['data'] as List)
            .map((json) => ProductModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'Failed to load products: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
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

      final response = await _httpClient
          .get(uri, headers: _getHeaders())
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['data'] as List)
            .map((json) => CategoryModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'Failed to load categories: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error loading categories: $e');
    }
  }
}
