import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doglio/features/admin/data/datasources/admin_categories_remote_datasource.dart';
import 'package:doglio/features/admin/data/models/admin_category_model.dart';
import 'package:doglio/features/admin/data/repositories/admin_categories_repository_impl.dart';
import 'package:doglio/features/admin/domain/entities/admin_category.dart';

class MockDatasource extends Mock
    implements AdminCategoriesRemoteDatasource {}

const _model = AdminCategoryModel(
  id: '1',
  name: 'Eletrônicos',
  slug: 'eletronicos',
  isHighlighted: false,
  isActive: true,
  productsCount: 5,
);

const _category = AdminCategory(
  id: '1',
  name: 'Eletrônicos',
  slug: 'eletronicos',
  isHighlighted: false,
  isActive: true,
  productsCount: 5,
);

void main() {
  late MockDatasource datasource;
  late AdminCategoriesRepositoryImpl repository;

  setUpAll(() => registerFallbackValue(_model));

  setUp(() {
    datasource = MockDatasource();
    repository = AdminCategoriesRepositoryImpl(datasource);
  });

  group('getCategories', () {
    test('Right com lista no sucesso', () async {
      when(() => datasource.getCategories(
            search: any(named: 'search'),
            isActive: any(named: 'isActive'),
          )).thenAnswer((_) async => [_model]);

      final result = await repository.getCategories();

      expect(result.isRight(), isTrue);
      final categories = result.getRight().toNullable()!;
      expect(categories.first.id, '1');
      expect(categories.first.name, 'Eletrônicos');
    });

    test('Left quando datasource lança', () async {
      when(() => datasource.getCategories(
            search: any(named: 'search'),
            isActive: any(named: 'isActive'),
          )).thenThrow(Exception('erro de rede'));

      final result = await repository.getCategories();
      expect(result.isLeft(), isTrue);
    });
  });

  group('createCategory', () {
    test('Right no sucesso', () async {
      when(() => datasource.createCategory(any()))
          .thenAnswer((_) async => _model);

      final result = await repository.createCategory(_category);
      expect(result.isRight(), isTrue);
    });

    test('Left quando datasource lança', () async {
      when(() => datasource.createCategory(any()))
          .thenThrow(Exception('nome duplicado'));

      final result = await repository.createCategory(_category);
      expect(result.isLeft(), isTrue);
    });
  });

  group('updateCategory', () {
    test('Right no sucesso', () async {
      when(() => datasource.updateCategory(any()))
          .thenAnswer((_) async => _model);

      final result = await repository.updateCategory(_category);
      expect(result.isRight(), isTrue);
    });
  });

  group('deleteCategory', () {
    test('Right(unit) no sucesso', () async {
      when(() => datasource.deleteCategory(any())).thenAnswer((_) async {});

      final result = await repository.deleteCategory('1');
      expect(result.isRight(), isTrue);
    });

    test('Left quando datasource lança', () async {
      when(() => datasource.deleteCategory(any()))
          .thenThrow(Exception('não encontrado'));

      final result = await repository.deleteCategory('1');
      expect(result.isLeft(), isTrue);
    });
  });
}
