import 'package:flutter_test/flutter_test.dart';
import 'package:doglio/features/store/domain/entities/product.dart';

Product _makeProduct({
  String? effectivePrice,
  Promotion? promotion,
  ProductImage? primaryImage,
  List<ProductImage> images = const [],
}) {
  return Product(
    id: 'p1',
    name: 'Produto Teste',
    description: '',
    price: '100.00',
    effectivePrice: effectivePrice,
    inStock: true,
    isHighlighted: false,
    isActive: true,
    primaryImage: primaryImage,
    images: images,
    categories: const [],
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
    promotion: promotion,
  );
}

const _promo = Promotion(
  id: 'promo1',
  name: 'Desconto',
  type: 'percentage',
  discountValue: 10,
);

const _img = ProductImage(id: 'i1', imagePath: '/img/a.jpg', order: 0, isPrimary: true);
const _imgNoPrimary = ProductImage(id: 'i2', imagePath: '/img/b.jpg', order: 1, isPrimary: false);
const _imgEmpty = ProductImage(id: 'i3', imagePath: '', order: 2, isPrimary: true);

void main() {
  group('Product.hasPromotion', () {
    test('false quando sem promoção', () {
      final p = _makeProduct();
      expect(p.hasPromotion, isFalse);
    });

    test('false quando tem promotion mas effectivePrice é null', () {
      final p = _makeProduct(promotion: _promo);
      expect(p.hasPromotion, isFalse);
    });

    test('false quando tem effectivePrice mas sem promotion', () {
      final p = _makeProduct(effectivePrice: '90.00');
      expect(p.hasPromotion, isFalse);
    });

    test('true quando tem promotion e effectivePrice', () {
      final p = _makeProduct(promotion: _promo, effectivePrice: '90.00');
      expect(p.hasPromotion, isTrue);
    });
  });

  group('Product.displayPrice', () {
    test('retorna price quando não há promoção', () {
      final p = _makeProduct();
      expect(p.displayPrice, '100.00');
    });

    test('retorna effectivePrice quando há promoção', () {
      final p = _makeProduct(promotion: _promo, effectivePrice: '90.00');
      expect(p.displayPrice, '90.00');
    });
  });

  group('Product.bestImagePath', () {
    test('null quando sem imagens', () {
      final p = _makeProduct();
      expect(p.bestImagePath, isNull);
    });

    test('usa primaryImage quando disponível', () {
      final p = _makeProduct(primaryImage: _img);
      expect(p.bestImagePath, '/img/a.jpg');
    });

    test('ignora primaryImage com path vazio e usa images', () {
      final p = _makeProduct(
        primaryImage: _imgEmpty,
        images: const [_imgNoPrimary],
      );
      expect(p.bestImagePath, '/img/b.jpg');
    });

    test('prefere imagem isPrimary da lista quando primaryImage é null', () {
      final primary = const ProductImage(id: 'i4', imagePath: '/img/primary.jpg', order: 0, isPrimary: true);
      final other = const ProductImage(id: 'i5', imagePath: '/img/other.jpg', order: 1, isPrimary: false);
      final p = _makeProduct(images: [other, primary]);
      expect(p.bestImagePath, '/img/primary.jpg');
    });

    test('usa primeira imagem da lista quando nenhuma é isPrimary', () {
      final p = _makeProduct(
        images: const [_imgNoPrimary],
      );
      expect(p.bestImagePath, '/img/b.jpg');
    });

    test('ignora imagens com path vazio na lista', () {
      final p = _makeProduct(
        images: const [_imgEmpty, _imgNoPrimary],
      );
      expect(p.bestImagePath, '/img/b.jpg');
    });
  });
}
