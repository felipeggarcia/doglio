import 'package:flutter_test/flutter_test.dart';
import 'package:doglio/features/admin/data/models/admin_category_model.dart';
import 'package:doglio/features/admin/data/models/admin_product_model.dart';

Map<String, dynamic> _json({Object? id = 'p1'}) => {
      'id': id,
      'name': 'Ração Premium',
      'description': 'Ração para cães adultos',
      'price': '89.90',
      'is_highlighted': true,
      'is_active': false,
      'in_stock': true,
      'stock_quantity': 12,
      'images': [
        {'id': 'img1', 'url': 'http://x/img1.jpg', 'is_primary': true, 'order': 0},
        {'id': 'img2', 'image_path': '/storage/img2.jpg', 'order': 1},
      ],
      'primary_image': {
        'id': 'img1',
        'url': 'http://x/img1.jpg',
        'is_primary': true,
        'order': 0,
      },
      'categories': [
        {'id': 'cat1', 'name': 'Rações', 'slug': 'racoes', 'is_active': true},
      ],
      'created_at': '2026-01-01T10:00:00',
      'updated_at': '2026-06-01T10:00:00',
    };

void main() {
  group('AdminProductModel.fromJson', () {
    test('parseia todos os campos', () {
      final model = AdminProductModel.fromJson(_json());

      expect(model.id, 'p1');
      expect(model.name, 'Ração Premium');
      expect(model.description, 'Ração para cães adultos');
      expect(model.price, '89.90');
      expect(model.isHighlighted, isTrue);
      expect(model.isActive, isFalse);
      expect(model.inStock, isTrue);
      expect(model.stockQuantity, 12);
      expect(model.images.length, 2);
      expect(model.primaryImage?.id, 'img1');
      expect(model.categories.single.id, 'cat1');
      expect(model.createdAt, '2026-01-01T10:00:00');
    });

    test('normaliza id inteiro e preço numérico para String', () {
      final model = AdminProductModel.fromJson({
        'id': 42,
        'name': 'X',
        'price': 19.9,
      });
      expect(model.id, '42');
      expect(model.price, '19.9');
    });

    test('campos ausentes assumem defaults seguros', () {
      final model = AdminProductModel.fromJson({'id': 'p1'});
      expect(model.name, '');
      expect(model.price, '0');
      expect(model.isActive, isTrue);
      expect(model.isHighlighted, isFalse);
      expect(model.inStock, isFalse);
      expect(model.stockQuantity, 0);
      expect(model.images, isEmpty);
      expect(model.primaryImage, isNull);
      expect(model.categories, isEmpty);
    });

    test('imagem aceita url ou image_path', () {
      final model = AdminProductModel.fromJson(_json());
      expect(model.images[0].url, 'http://x/img1.jpg');
      expect(model.images[1].url, '/storage/img2.jpg');
    });

    test('booleans aceitam 1/0 e strings', () {
      final model = AdminProductModel.fromJson({
        'id': 'p1',
        'is_highlighted': 1,
        'is_active': '0',
        'in_stock': 'true',
      });
      expect(model.isHighlighted, isTrue);
      expect(model.isActive, isFalse);
      expect(model.inStock, isTrue);
    });
  });

  group('AdminProductModel.toMultipartFields', () {
    const model = AdminProductModel(
      id: 'p1',
      name: 'Ração',
      description: 'Desc',
      price: '89.90',
      isHighlighted: true,
      isActive: false,
      inStock: true,
      stockQuantity: 5,
      categories: [
        AdminCategoryModel(
          id: 'cat1',
          name: 'Rações',
          slug: 'racoes',
          isHighlighted: false,
          isActive: true,
          productsCount: 0,
        ),
        AdminCategoryModel(
          id: 'cat2',
          name: 'Brinquedos',
          slug: 'brinquedos',
          isHighlighted: false,
          isActive: true,
          productsCount: 0,
        ),
      ],
    );

    test('criação: booleans como 1/0, categorias indexadas, sem _method', () {
      final fields = model.toMultipartFields();

      expect(fields['name'], 'Ração');
      expect(fields['description'], 'Desc');
      expect(fields['price'], '89.90');
      expect(fields['is_highlighted'], '1');
      expect(fields['category_ids[0]'], 'cat1');
      expect(fields['category_ids[1]'], 'cat2');
      expect(fields.containsKey('_method'), isFalse);
      expect(fields.containsKey('is_active'), isFalse);
      expect(fields.containsKey('id'), isFalse);
      expect(fields.containsKey('stock_quantity'), isFalse);
    });

    test('edição: inclui _method=PUT, is_active e remove_images indexados',
        () {
      final fields = model.toMultipartFields(
        forUpdate: true,
        removeImageIds: ['img1', 'img2'],
      );

      expect(fields['_method'], 'PUT');
      expect(fields['is_active'], '0');
      expect(fields['remove_images[0]'], 'img1');
      expect(fields['remove_images[1]'], 'img2');
    });
  });

  group('conversão entity ↔ model', () {
    test('toEntity e fromEntity preservam os campos', () {
      final entity = AdminProductModel.fromJson(_json()).toEntity();
      expect(entity.id, 'p1');
      expect(entity.images.length, 2);
      expect(entity.categories.single.name, 'Rações');

      final back = AdminProductModel.fromEntity(entity);
      expect(back.id, entity.id);
      expect(back.price, entity.price);
      expect(back.categories.single.id, 'cat1');
    });
  });
}
