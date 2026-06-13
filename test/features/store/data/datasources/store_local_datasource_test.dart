import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doglio/features/store/data/datasources/store_local_datasource.dart';
import 'package:doglio/features/store/data/models/product_model.dart';

CategoryModel _cat({String id = 'c1'}) => CategoryModel(
      id: id,
      name: 'Cat $id',
      slug: 'cat-$id',
      isHighlighted: false,
      isActive: true,
    );

ProductModel _product({String id = 'p1'}) => ProductModel(
      id: id,
      name: 'Produto $id',
      description: 'Desc',
      price: '10.00',
      inStock: true,
      isHighlighted: false,
      isActive: true,
      images: const [],
      categories: const [],
      reviewsCount: 0,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

void main() {
  late StoreLocalDatasourceImpl datasource;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    datasource = StoreLocalDatasourceImpl(prefs);
  });

  group('products', () {
    test('loadProducts retorna null quando cache vazio', () async {
      final result = await datasource.loadProducts('key');
      expect(result, isNull);
    });

    test('save + load retorna a mesma lista', () async {
      final products = [_product(id: 'p1'), _product(id: 'p2')];

      await datasource.saveProducts('default', products);
      final loaded = await datasource.loadProducts('default');

      expect(loaded, isNotNull);
      expect(loaded!.length, 2);
      expect(loaded.map((p) => p.id), containsAll(['p1', 'p2']));
    });

    test('chaves diferentes retornam caches independentes', () async {
      await datasource.saveProducts('key1', [_product(id: 'p1')]);
      await datasource.saveProducts('key2', [_product(id: 'p2'), _product(id: 'p3')]);

      final r1 = await datasource.loadProducts('key1');
      final r2 = await datasource.loadProducts('key2');

      expect(r1!.single.id, 'p1');
      expect(r2!.length, 2);
    });
  });

  group('categories', () {
    test('loadCategories retorna null quando cache vazio', () async {
      final result = await datasource.loadCategories();
      expect(result, isNull);
    });

    test('save + load retorna a mesma lista', () async {
      final cats = [_cat(id: 'c1'), _cat(id: 'c2')];

      await datasource.saveCategories(cats);
      final loaded = await datasource.loadCategories();

      expect(loaded, isNotNull);
      expect(loaded!.length, 2);
      expect(loaded.map((c) => c.id), containsAll(['c1', 'c2']));
    });
  });

  group('clearAll', () {
    test('remove produtos e categorias', () async {
      await datasource.saveProducts('k', [_product()]);
      await datasource.saveCategories([_cat()]);

      await datasource.clearAll();

      expect(await datasource.loadProducts('k'), isNull);
      expect(await datasource.loadCategories(), isNull);
    });
  });
}
