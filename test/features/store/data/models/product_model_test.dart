import 'package:flutter_test/flutter_test.dart';
import 'package:doglio/features/store/data/models/product_model.dart';

Map<String, dynamic> _baseJson({
  dynamic price = '10.50',
  dynamic originalPrice,
  dynamic effectivePrice,
  dynamic discountAmount,
}) =>
    {
      'id': 'p1',
      'name': 'Produto Teste',
      'description': 'Descricao',
      'price': price,
      'original_price': originalPrice,
      'effective_price': effectivePrice,
      'discount_amount': discountAmount,
      'in_stock': true,
      'is_highlighted': false,
      'is_active': true,
      'images': <dynamic>[],
      'categories': <dynamic>[],
      'reviews_count': 0,
      'created_at': '2026-01-01T00:00:00Z',
      'updated_at': '2026-01-01T00:00:00Z',
    };

void main() {
  group('ProductModel.fromJson — campo price', () {
    test('aceita price como String', () {
      final model = ProductModel.fromJson(_baseJson(price: '29.90'));
      expect(model.price, '29.90');
    });

    test('aceita price como int', () {
      final model = ProductModel.fromJson(_baseJson(price: 30));
      expect(model.price, '30');
    });

    test('aceita price como double', () {
      final model = ProductModel.fromJson(_baseJson(price: 10.5));
      expect(model.price, '10.5');
    });

    test('usa "0.00" quando price é null', () {
      final model = ProductModel.fromJson(_baseJson(price: null));
      expect(model.price, '0.00');
    });

    test('effective_price null retorna null', () {
      final model = ProductModel.fromJson(_baseJson());
      expect(model.effectivePrice, isNull);
    });

    test('effective_price como double converte para String', () {
      final model = ProductModel.fromJson(
          _baseJson(originalPrice: 50.0, effectivePrice: 39.9));
      expect(model.originalPrice, '50.0');
      expect(model.effectivePrice, '39.9');
    });

    test('discount_amount como int converte para String', () {
      final model = ProductModel.fromJson(_baseJson(discountAmount: 10));
      expect(model.discountAmount, '10');
    });
  });

  group('ProductModel.fromJson — campos opcionais', () {
    test('campos ausentes no JSON ficam null ou default', () {
      final model = ProductModel.fromJson(_baseJson());
      expect(model.promotion, isNull);
      expect(model.primaryImage, isNull);
      expect(model.images, isEmpty);
      expect(model.categories, isEmpty);
      expect(model.averageRating, isNull);
      expect(model.reviewsCount, 0);
    });

    test('name e description ausentes usam string vazia', () {
      final json = _baseJson()
        ..remove('name')
        ..remove('description');
      final model = ProductModel.fromJson(json);
      expect(model.name, '');
      expect(model.description, '');
    });
  });

  group('ProductModel.fromJson — datas', () {
    test('created_at null usa DateTime de fallback', () {
      final json = _baseJson()
        ..['created_at'] = null
        ..['updated_at'] = null;
      expect(() => ProductModel.fromJson(json), returnsNormally);
    });

    test('created_at e updated_at ausentes usam fallback (estrutura real da API)', () {
      final json = _baseJson()
        ..remove('created_at')
        ..remove('updated_at');
      expect(() => ProductModel.fromJson(json), returnsNormally);
    });

    test('created_at como string ISO-8601 é parseado corretamente', () {
      final model = ProductModel.fromJson(
          _baseJson()..['created_at'] = '2026-01-15T10:00:00Z');
      expect(model.createdAt, DateTime.utc(2026, 1, 15, 10));
    });
  });

  group('ProductImageModel.fromJson', () {
    test('lê imagePath do campo url', () {
      final model = ProductImageModel.fromJson({
        'id': 'i1',
        'url': '/images/foo.jpg',
        'order': 1,
        'is_primary': true,
      });
      expect(model.imagePath, '/images/foo.jpg');
    });

    test('lê imagePath do campo image_path quando url ausente', () {
      final model = ProductImageModel.fromJson({
        'id': 'i1',
        'image_path': '/images/bar.jpg',
        'order': 0,
        'is_primary': false,
      });
      expect(model.imagePath, '/images/bar.jpg');
    });

    test('usa string vazia quando ambos url e image_path ausentes', () {
      final model = ProductImageModel.fromJson({
        'id': 'i1',
        'order': 0,
        'is_primary': false,
      });
      expect(model.imagePath, '');
    });
  });

  group('ProductModel.fromJson — JSON realista da API (sem datas)', () {
    test('parseia produto conforme retorno real do endpoint /products', () {
      final json = {
        'id': 'abc',
        'name': 'Ração Premium',
        'description': 'Ração para cães adultos',
        'price': '89.90',
        'original_price': null,
        'effective_price': null,
        'discount_amount': null,
        'promotion': null,
        'in_stock': true,
        'is_highlighted': true,
        'is_active': true,
        'images': [
          {'id': 'img1', 'url': '/storage/img.jpg', 'is_primary': true, 'order': 0},
        ],
        'primary_image': {'id': 'img1', 'url': '/storage/img.jpg', 'is_primary': true, 'order': 0},
        'categories': [
          {'id': 'cat1', 'name': 'Alimentos', 'slug': 'alimentos', 'is_highlighted': false, 'is_active': true},
        ],
        'average_rating': 4.5,
        'reviews_count': 12,
        // sem created_at / updated_at
      };

      final model = ProductModel.fromJson(json);
      expect(model.id, 'abc');
      expect(model.price, '89.90');
      expect(model.images.first.imagePath, '/storage/img.jpg');
      expect(model.primaryImage!.imagePath, '/storage/img.jpg');
      expect(model.categories.first.name, 'Alimentos');
    });
  });

  group('PromotionModel.fromJson', () {
    test('parseia promoção com todos os campos', () {
      final model = PromotionModel.fromJson({
        'id': 'promo1',
        'name': 'Black Friday',
        'type': 'percentage',
        'discount_value': 20.0,
      });
      expect(model.id, 'promo1');
      expect(model.discountValue, 20.0);
    });

    test('campos ausentes usam defaults', () {
      final model = PromotionModel.fromJson({'id': 'promo1'});
      expect(model.name, '');
      expect(model.type, '');
      expect(model.discountValue, 0.0);
    });
  });

  group('CategoryModel.fromJson', () {
    test('parseia categoria com todos os campos', () {
      final model = CategoryModel.fromJson({
        'id': 'cat1',
        'name': 'Alimentos',
        'slug': 'alimentos',
        'is_highlighted': true,
        'is_active': true,
        'products_count': 42,
      });
      expect(model.id, 'cat1');
      expect(model.productsCount, 42);
    });

    test('products_count ausente fica null', () {
      final model = CategoryModel.fromJson({
        'id': 'cat1',
        'name': 'Alimentos',
        'slug': 'alimentos',
        'is_highlighted': false,
        'is_active': true,
      });
      expect(model.productsCount, isNull);
    });
  });

  group('ProductModel.toEntity()', () {
    test('converte para Product com os mesmos campos', () {
      final model = ProductModel.fromJson(
        _baseJson(price: 25, effectivePrice: 20.0),
      );
      final entity = model.toEntity();

      expect(entity.id, 'p1');
      expect(entity.price, '25');
      expect(entity.effectivePrice, '20.0');
      expect(entity.inStock, isTrue);
    });
  });
}
