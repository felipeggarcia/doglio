import 'package:flutter_test/flutter_test.dart';
import 'package:doglio/features/admin/data/models/admin_promotion_model.dart';
import 'package:doglio/features/admin/domain/entities/admin_promotion.dart';

Map<String, dynamic> _promoJson({
  String id = '1',
  String type = 'percentage',
  bool isActive = true,
  bool isCurrentlyActive = true,
  bool includeProducts = true,
  String? endsAt,
}) =>
    {
      'id': id,
      'name': 'Promo $id',
      'description': 'Desconto especial',
      'type': type,
      'discount_value': '10.00',
      'starts_at': '2026-06-01T00:00:00.000Z',
      'is_active': isActive,
      'is_currently_active': isCurrentlyActive,
      'min_quantity': 2,
      'ends_at': ?endsAt,
      if (includeProducts)
        'products': [
          {
            'id': 'p1',
            'name': 'Produto A',
            'use_limit': 5,
            'uses_count': 3,
          },
        ],
    };

void main() {
  group('AdminPromotionModel.fromJson', () {
    test('parseia todos os campos', () {
      final model = AdminPromotionModel.fromJson(_promoJson());

      expect(model.id, '1');
      expect(model.name, 'Promo 1');
      expect(model.description, 'Desconto especial');
      expect(model.type, DiscountType.percentage);
      expect(model.discountValue, '10.00');
      expect(model.isActive, isTrue);
      expect(model.isCurrentlyActive, isTrue);
      expect(model.minQuantity, 2);
      expect(model.products.length, 1);
      expect(model.products.first.id, 'p1');
      expect(model.products.first.useLimit, 5);
      expect(model.products.first.usesCount, 3);
    });

    test('normaliza id inteiro para String', () {
      final model = AdminPromotionModel.fromJson({
        ...(_promoJson()),
        'id': 42,
      });
      expect(model.id, '42');
      expect(model.id, isA<String>());
    });

    test('type desconhecido usa fallback percentage', () {
      final model = AdminPromotionModel.fromJson({
        ...(_promoJson()),
        'type': 'unknown_type',
      });
      expect(model.type, DiscountType.percentage);
    });

    test('type fixed é parseado corretamente', () {
      final model = AdminPromotionModel.fromJson(_promoJson(type: 'fixed'));
      expect(model.type, DiscountType.fixed);
    });

    test('ends_at nullable — ausente não causa erro', () {
      final model = AdminPromotionModel.fromJson(_promoJson());
      expect(model.endsAt, isNull);
    });

    test('ends_at preenchido é parseado como DateTime', () {
      final model = AdminPromotionModel.fromJson(
        _promoJson(endsAt: '2026-12-31T23:59:59.000Z'),
      );
      expect(model.endsAt, isNotNull);
      expect(model.endsAt!.year, 2026);
    });

    test('products ausente retorna lista vazia', () {
      final model = AdminPromotionModel.fromJson(
        _promoJson(includeProducts: false),
      );
      expect(model.products, isEmpty);
    });

    test('is_currently_active aceita variações bool/int', () {
      expect(
        AdminPromotionModel.fromJson({
          ...(_promoJson()),
          'is_currently_active': 0,
        }).isCurrentlyActive,
        isFalse,
      );
      expect(
        AdminPromotionModel.fromJson({
          ...(_promoJson()),
          'is_currently_active': 1,
        }).isCurrentlyActive,
        isTrue,
      );
    });

    test('campos ausentes assumem defaults seguros', () {
      final model = AdminPromotionModel.fromJson({'id': '1'});
      expect(model.name, '');
      expect(model.discountValue, '0');
      expect(model.minQuantity, 1);
      expect(model.products, isEmpty);
      expect(model.isActive, isTrue);
      expect(model.isCurrentlyActive, isFalse);
    });
  });

  group('AdminPromotionModel.toJson', () {
    test('inclui campos editáveis e omite is_currently_active e products', () {
      final model = AdminPromotionModel.fromJson(_promoJson());
      final json = model.toJson();

      expect(json['name'], 'Promo 1');
      expect(json['type'], 'percentage');
      expect(json['is_active'], isTrue);
      expect(json.containsKey('is_currently_active'), isFalse);
      expect(json.containsKey('products'), isFalse);
      expect(json.containsKey('product_ids'), isFalse);
    });

    test('endsAt ausente não aparece no JSON', () {
      final model = AdminPromotionModel.fromJson(_promoJson());
      expect(model.toJson().containsKey('ends_at'), isFalse);
    });
  });

  group('AdminPromotionModel.toCreateJson', () {
    test('sem initialProducts não inclui product_ids', () {
      final model = AdminPromotionModel.fromJson(_promoJson());
      expect(model.toCreateJson().containsKey('product_ids'), isFalse);
    });

    test('com initialProducts inclui product_ids corretos', () {
      final model = AdminPromotionModel.fromJson(_promoJson());
      final json = model.toCreateJson(
        initialProducts: [(productId: 'abc', useLimit: 10)],
      );
      final ids = json['product_ids'] as List<dynamic>;
      expect(ids.length, 1);
      expect((ids.first as Map)['id'], 'abc');
      expect((ids.first as Map)['use_limit'], 10);
    });
  });

  group('toEntity / fromEntity', () {
    test('toEntity mapeia corretamente', () {
      final model = AdminPromotionModel.fromJson(_promoJson());
      final entity = model.toEntity();

      expect(entity.id, '1');
      expect(entity.type, DiscountType.percentage);
      expect(entity.products.first.id, 'p1');
    });

    test('fromEntity → toEntity é round-trip', () {
      final original = AdminPromotionModel.fromJson(_promoJson()).toEntity();
      final roundTrip = AdminPromotionModel.fromEntity(original).toEntity();
      expect(roundTrip.id, original.id);
      expect(roundTrip.name, original.name);
      expect(roundTrip.products.length, original.products.length);
    });
  });
}
