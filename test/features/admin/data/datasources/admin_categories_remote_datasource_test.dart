import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:doglio/core/errors/exceptions.dart';
import 'package:doglio/core/storage/secure_storage.dart';
import 'package:doglio/features/admin/data/datasources/admin_categories_remote_datasource.dart';
import 'package:doglio/features/admin/data/models/admin_category_model.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockSecureStorage extends Mock implements SecureStorage {}

Map<String, dynamic> _catJson({String id = '1', bool active = true}) => {
      'id': id,
      'name': 'Categoria $id',
      'slug': 'categoria-$id',
      'is_highlighted': false,
      'is_active': active,
      'products_count': 5,
    };

void main() {
  late MockHttpClient http_;
  late MockSecureStorage storage;
  late AdminCategoriesRemoteDatasource datasource;

  setUpAll(() {
    registerFallbackValue(Uri.parse('http://example.com'));
    registerFallbackValue(<String, String>{});
  });

  setUp(() {
    http_ = MockHttpClient();
    storage = MockSecureStorage();
    datasource = AdminCategoriesRemoteDatasource(
      httpClient: http_,
      secureStorage: storage,
    );
    when(() => storage.getToken()).thenAnswer((_) async => 'token');
  });

  group('getCategories', () {
    test('parseia lista e aceita filtros de busca e status', () async {
      when(() => http_.get(any(), headers: any(named: 'headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'data': [_catJson(id: '1'), _catJson(id: '2', active: false)],
          }),
          200,
        ),
      );

      final result = await datasource.getCategories(search: 'cat', isActive: true);

      expect(result.length, 2);

      final captured =
          verify(() => http_.get(captureAny(), headers: any(named: 'headers')))
              .captured
              .single as Uri;
      expect(captured.queryParameters['search'], 'cat');
      expect(captured.queryParameters['is_active'], '1');
    });

    test('omite query params quando não fornecidos', () async {
      when(() => http_.get(any(), headers: any(named: 'headers'))).thenAnswer(
        (_) async => http.Response(jsonEncode({'data': []}), 200),
      );

      await datasource.getCategories();

      final captured =
          verify(() => http_.get(captureAny(), headers: any(named: 'headers')))
              .captured
              .single as Uri;
      expect(captured.queryParameters.containsKey('search'), isFalse);
      expect(captured.queryParameters.containsKey('is_active'), isFalse);
    });

    test('lança UnauthorizedException em 401', () async {
      when(() => http_.get(any(), headers: any(named: 'headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode({'message': 'Não autorizado.'}),
          401,
        ),
      );

      await expectLater(
        datasource.getCategories(),
        throwsA(isA<UnauthorizedException>()),
      );
    });
  });

  group('createCategory', () {
    test('faz POST 201 e parseia o retorno', () async {
      when(() => http_.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer(
        (_) async =>
            http.Response(jsonEncode({'data': _catJson(id: '10')}), 201),
      );

      const model = AdminCategoryModel(
        id: '',
        name: 'Nova',
        slug: '',
        isHighlighted: false,
        isActive: true,
        productsCount: 0,
      );

      final result = await datasource.createCategory(model);
      expect(result.id, '10');
    });
  });

  group('updateCategory', () {
    test('faz PUT em /admin/categories/{id}', () async {
      when(() => http_.put(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer(
        (_) async =>
            http.Response(jsonEncode({'data': _catJson(id: '7')}), 200),
      );

      const model = AdminCategoryModel(
        id: '7',
        name: 'Editada',
        slug: 'editada',
        isHighlighted: true,
        isActive: false,
        productsCount: 2,
      );

      await datasource.updateCategory(model);

      final uri = verify(() => http_.put(captureAny(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .captured
          .single as Uri;
      expect(uri.path, endsWith('/admin/categories/7'));
    });
  });

  group('deleteCategory', () {
    test('aceita 204 sem erro', () async {
      when(() => http_.delete(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('', 204));

      await expectLater(datasource.deleteCategory('3'), completes);
    });
  });
}
