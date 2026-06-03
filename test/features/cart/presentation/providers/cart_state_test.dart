import 'package:flutter_test/flutter_test.dart';
import 'package:doglio/features/cart/domain/entities/cart_item.dart';
import 'package:doglio/features/cart/presentation/providers/cart_provider.dart';
import 'package:doglio/features/store/domain/entities/product.dart';

// ─── Helpers ──────────────────────────────────────────────────────────────────

Product _product({String id = 'p1', String price = '10.00'}) => Product(
      id: id,
      name: 'Produto Teste',
      description: '',
      price: price,
      inStock: true,
      isHighlighted: false,
      isActive: true,
      images: [],
      categories: [],
      reviewsCount: 0,
      createdAt: DateTime(2000),
      updatedAt: DateTime(2000),
    );

CartItem _item({
  String productId = 'p1',
  String unitPrice = '10.00',
  String? effectiveUnitPrice,
  int quantity = 1,
}) =>
    CartItem(
      productId: productId,
      product: _product(id: productId, price: unitPrice),
      quantity: quantity,
      unitPrice: unitPrice,
      effectiveUnitPrice: effectiveUnitPrice,
      subtotal: '0.00', // não é usado em computedTotal
    );

// ─── Testes ───────────────────────────────────────────────────────────────────

void main() {
  group('CartState.computedTotal', () {
    test('carrinho vazio retorna 0.00', () {
      expect(const CartState().computedTotal, '0.00');
    });

    test('um item qty 1 retorna o preço unitário', () {
      final state = CartState(items: [_item(unitPrice: '89.90')]);
      expect(state.computedTotal, '89.90');
    });

    test('um item qty 2 retorna qty × preço', () {
      final state = CartState(items: [_item(unitPrice: '89.90', quantity: 2)]);
      expect(state.computedTotal, '179.80');
    });

    test('item com promoção usa effectiveUnitPrice, não unitPrice', () {
      final state = CartState(items: [
        _item(unitPrice: '100.00', effectiveUnitPrice: '79.90', quantity: 1),
      ]);
      expect(state.computedTotal, '79.90');
    });

    test('item com promoção e qty > 1 multiplica pelo effectiveUnitPrice', () {
      final state = CartState(items: [
        _item(unitPrice: '100.00', effectiveUnitPrice: '79.90', quantity: 3),
      ]);
      expect(state.computedTotal, '239.70');
    });

    test('múltiplos itens somam corretamente', () {
      final state = CartState(items: [
        _item(productId: 'p1', unitPrice: '50.00', quantity: 2),  // 100.00
        _item(productId: 'p2', unitPrice: '30.00', quantity: 3),  // 90.00
      ]);
      expect(state.computedTotal, '190.00');
    });

    test('mix de itens com e sem promoção', () {
      final state = CartState(items: [
        _item(productId: 'p1', unitPrice: '100.00', effectiveUnitPrice: '80.00', quantity: 2), // 160.00
        _item(productId: 'p2', unitPrice: '20.00', quantity: 5),  // 100.00
      ]);
      expect(state.computedTotal, '260.00');
    });

    test('preço inválido/vazio é tratado como zero', () {
      final state = CartState(items: [
        _item(unitPrice: 'abc', quantity: 3),
      ]);
      expect(state.computedTotal, '0.00');
    });

    test('resultado tem sempre 2 casas decimais', () {
      final state = CartState(items: [_item(unitPrice: '10.00', quantity: 3)]);
      expect(state.computedTotal, '30.00');
    });
  });

  group('CartState.totalItems', () {
    test('carrinho vazio retorna 0', () {
      expect(const CartState().totalItems, 0);
    });

    test('um item com qty 3 retorna 3', () {
      final state = CartState(items: [_item(quantity: 3)]);
      expect(state.totalItems, 3);
    });

    test('múltiplos itens somam as quantidades', () {
      final state = CartState(items: [
        _item(productId: 'p1', quantity: 2),
        _item(productId: 'p2', quantity: 5),
      ]);
      expect(state.totalItems, 7);
    });
  });

  group('CartState.isEmpty', () {
    test('carrinho sem itens é vazio', () {
      expect(const CartState().isEmpty, isTrue);
    });

    test('carrinho com item não é vazio', () {
      final state = CartState(items: [_item()]);
      expect(state.isEmpty, isFalse);
    });
  });

  group('CartState.copyWith', () {
    test('copia mantendo campos não alterados', () {
      const original = CartState(total: '50.00', isSyncing: true);
      final copy = original.copyWith(total: '80.00');
      expect(copy.total, '80.00');
      expect(copy.isSyncing, isTrue);
    });

    test('errorMessage pode ser zerado passando null explicitamente', () {
      final original = CartState(items: const [], errorMessage: 'erro anterior');
      final copy = original.copyWith(errorMessage: null);
      expect(copy.errorMessage, isNull);
    });

    test('errorMessage mantido quando não passado', () {
      final original = CartState(items: const [], errorMessage: 'erro');
      final copy = original.copyWith(total: '10.00');
      expect(copy.errorMessage, 'erro');
    });
  });

  group('CartItem.displayUnitPrice', () {
    test('sem promoção retorna unitPrice', () {
      final item = _item(unitPrice: '89.90');
      expect(item.displayUnitPrice, '89.90');
    });

    test('com promoção retorna effectiveUnitPrice', () {
      final item = _item(unitPrice: '100.00', effectiveUnitPrice: '79.90');
      expect(item.displayUnitPrice, '79.90');
    });

    test('hasPromotion é true quando effectiveUnitPrice está presente', () {
      final item = _item(effectiveUnitPrice: '79.90');
      expect(item.hasPromotion, isTrue);
    });

    test('hasPromotion é false quando effectiveUnitPrice é null', () {
      final item = _item();
      expect(item.hasPromotion, isFalse);
    });
  });
}
