import 'package:flutter_test/flutter_test.dart';
import 'package:doglio/features/admin/data/models/admin_category_model.dart';
import 'package:doglio/features/admin/domain/entities/admin_category.dart';

void main() {
  group('AdminCategoryModel.fromJson', () {
    test('parseia todos os campos', () {
      final model = AdminCategoryModel.fromJson({
        'id': '5',
        'name': 'Eletrônicos',
        'slug': 'eletronicos',
        'is_highlighted': true,
        'is_active': true,
        'products_count': 12,
      });

      expect(model.id, '5');
      expect(model.name, 'Eletrônicos');
      expect(model.slug, 'eletronicos');
      expect(model.isHighlighted, isTrue);
      expect(model.isActive, isTrue);
      expect(model.productsCount, 12);
    });

    test('normaliza id inteiro para String', () {
      final model = AdminCategoryModel.fromJson({'id': 42, 'name': 'X', 'slug': 'x'});
      expect(model.id, '42');
      expect(model.id, isA<String>());
    });

    test('is_active/is_highlighted aceitam variações (bool/int/string)', () {
      expect(
        AdminCategoryModel.fromJson({'id': '1', 'is_active': 0, 'is_highlighted': '0'}).isActive,
        isFalse,
      );
      expect(
        AdminCategoryModel.fromJson({'id': '1', 'is_active': 1, 'is_highlighted': true}).isHighlighted,
        isTrue,
      );
    });

    test('campos ausentes assumem defaults seguros', () {
      final model = AdminCategoryModel.fromJson({'id': '1'});
      expect(model.name, '');
      expect(model.slug, '');
      expect(model.isHighlighted, isFalse);
      expect(model.isActive, isTrue);
      expect(model.productsCount, 0);
    });
  });

  group('AdminCategoryModel.toJson', () {
    test('inclui name, is_highlighted, is_active; omite id, slug, products_count', () {
      const model = AdminCategoryModel(
        id: '5',
        name: 'Roupas',
        slug: 'roupas',
        isHighlighted: false,
        isActive: true,
        productsCount: 3,
      );

      final json = model.toJson();

      expect(json['name'], 'Roupas');
      expect(json['is_highlighted'], false);
      expect(json['is_active'], true);
      expect(json.containsKey('id'), isFalse);
      expect(json.containsKey('slug'), isFalse);
      expect(json.containsKey('products_count'), isFalse);
    });
  });

  group('conversões de entidade', () {
    test('toEntity mapeia todos os campos corretamente', () {
      const model = AdminCategoryModel(
        id: '3',
        name: 'Livros',
        slug: 'livros',
        isHighlighted: true,
        isActive: false,
        productsCount: 7,
      );

      final entity = model.toEntity();

      expect(entity.id, '3');
      expect(entity.name, 'Livros');
      expect(entity.slug, 'livros');
      expect(entity.isHighlighted, isTrue);
      expect(entity.isActive, isFalse);
      expect(entity.productsCount, 7);
    });

    test('fromEntity produz model equivalente', () {
      const entity = AdminCategory(
        id: '9',
        name: 'Games',
        slug: 'games',
        isHighlighted: false,
        isActive: true,
        productsCount: 0,
      );

      final model = AdminCategoryModel.fromEntity(entity);

      expect(model.id, '9');
      expect(model.name, 'Games');
      expect(model.isHighlighted, isFalse);
    });
  });
}
