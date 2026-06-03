import 'package:flutter_test/flutter_test.dart';
import 'package:doglio/features/favorites/data/models/favorite_model.dart';

Map<String, dynamic> _productJson() => {
      'id': 'p1',
      'name': 'Ração Premium',
      'description': 'Para cães adultos',
      'price': '89.90',
      'in_stock': true,
      'is_highlighted': false,
      'is_active': true,
      'images': <dynamic>[],
      'categories': <dynamic>[],
      'reviews_count': 0,
      // sem created_at/updated_at — exatamente como a API retorna em /favorites
    };

Map<String, dynamic> _baseJson({dynamic createdAt = '2026-01-01T00:00:00Z'}) =>
    {
      'id': 'fav1',
      'notify_on_restock': true,
      'product': _productJson(),
      'created_at': createdAt,
    };

void main() {
  group('FavoriteModel.fromJson — parsing sem erros', () {
    test('parseia JSON completo sem erros', () {
      expect(() => FavoriteModel.fromJson(_baseJson()), returnsNormally);
    });

    test('created_at null usa DateTime de fallback', () {
      expect(
        () => FavoriteModel.fromJson(_baseJson(createdAt: null)),
        returnsNormally,
      );
    });

    test('created_at ausente usa DateTime de fallback', () {
      final json = _baseJson()..remove('created_at');
      expect(() => FavoriteModel.fromJson(json), returnsNormally);
    });

    test('produto embutido sem created_at/updated_at parseia corretamente', () {
      final model = FavoriteModel.fromJson(_baseJson());
      expect(model.product.id, 'p1');
      expect(model.product.price, '89.90');
      expect(model.product.inStock, isTrue);
    });

    test('produto embutido com imagem url parseia imagePath', () {
      final json = _baseJson()
        ..[  'product'] = {
          ..._productJson(),
          'images': [
            {'id': 'img1', 'url': '/storage/img.jpg', 'is_primary': true, 'order': 0},
          ],
          'primary_image': {'id': 'img1', 'url': '/storage/img.jpg', 'is_primary': true, 'order': 0},
        };
      final model = FavoriteModel.fromJson(json);
      expect(model.product.images.first.imagePath, '/storage/img.jpg');
      expect(model.product.primaryImage!.imagePath, '/storage/img.jpg');
    });
  });

  group('FavoriteModel.fromJson — campos opcionais', () {
    test('notify_on_restock false quando ausente', () {
      final json = _baseJson()..remove('notify_on_restock');
      final model = FavoriteModel.fromJson(json);
      expect(model.notifyOnRestock, false);
    });

    test('notify_on_restock false é preservado', () {
      final json = _baseJson()..[  'notify_on_restock'] = false;
      final model = FavoriteModel.fromJson(json);
      expect(model.notifyOnRestock, false);
    });
  });

  group('FavoriteModel.toEntity()', () {
    test('mapeia todos os campos para Favorite', () {
      final model = FavoriteModel.fromJson(_baseJson());
      final entity = model.toEntity();

      expect(entity.id, 'fav1');
      expect(entity.notifyOnRestock, true);
      expect(entity.product.id, 'p1');
      expect(entity.product.price, '89.90');
    });

    test('created_at null no fallback é um DateTime válido', () {
      final model = FavoriteModel.fromJson(_baseJson(createdAt: null));
      final entity = model.toEntity();
      expect(entity.createdAt, isA<DateTime>());
    });
  });
}
