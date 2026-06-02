/// API Response wrapper for Doglio API
///
/// Standardizes API responses based on Laravel backend format
library;

/// Standard API response format
class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.meta,
    this.links,
  });

  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? meta;
  final Map<String, dynamic>? links;

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? '',
      data: json['data'] as T?,
      meta: json['meta'] as Map<String, dynamic>?,
      links: json['links'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (data != null) 'data': data,
      if (meta != null) 'meta': meta,
      if (links != null) 'links': links,
    };
  }

  @override
  String toString() {
    return 'ApiResponse(success: $success, message: $message, data: $data)';
  }
}

/// Paginated API response
class PaginatedResponse<T> {
  const PaginatedResponse({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    this.from,
    this.to,
    this.links,
  });

  final List<T> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final int? from;
  final int? to;
  final Map<String, String?>? links;

  bool get hasNextPage => currentPage < lastPage;
  bool get hasPreviousPage => currentPage > 1;

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final dataList = (json['data'] as List)
        .map((item) => fromJsonT(item as Map<String, dynamic>))
        .toList();

    final meta = json['meta'] as Map<String, dynamic>;
    final links = json['links'] as Map<String, dynamic>?;

    return PaginatedResponse<T>(
      data: dataList,
      currentPage: meta['current_page'] as int,
      lastPage: meta['last_page'] as int,
      perPage: meta['per_page'] as int,
      total: meta['total'] as int,
      from: meta['from'] as int?,
      to: meta['to'] as int?,
      links: links?.map((key, value) => MapEntry(key, value as String?)),
    );
  }
}
