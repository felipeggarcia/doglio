import 'package:flutter_test/flutter_test.dart';
import 'package:doglio/features/orders/domain/entities/order.dart';

void main() {
  group('OrderPayment', () {
    group('isPix', () {
      test('true quando type == "pix"', () {
        expect(const OrderPayment(type: 'pix', status: 'pending').isPix, isTrue);
      });
      test('false quando type != "pix"', () {
        expect(const OrderPayment(type: 'boleto', status: 'pending').isPix, isFalse);
        expect(const OrderPayment(type: 'credit_card', status: 'pending').isPix, isFalse);
      });
    });

    group('isBoleto', () {
      test('true quando type == "boleto"', () {
        expect(const OrderPayment(type: 'boleto', status: 'pending').isBoleto, isTrue);
      });
      test('false quando type != "boleto"', () {
        expect(const OrderPayment(type: 'pix', status: 'pending').isBoleto, isFalse);
        expect(const OrderPayment(type: 'credit_card', status: 'pending').isBoleto, isFalse);
      });
    });

    group('isCreditCard', () {
      test('true quando type == "credit_card"', () {
        expect(const OrderPayment(type: 'credit_card', status: 'pending').isCreditCard, isTrue);
      });
      test('false quando type != "credit_card"', () {
        expect(const OrderPayment(type: 'pix', status: 'pending').isCreditCard, isFalse);
        expect(const OrderPayment(type: 'boleto', status: 'pending').isCreditCard, isFalse);
      });
    });

    group('campos opcionais', () {
      test('todos nulos por padrão', () {
        const p = OrderPayment(type: 'pix', status: 'pending');
        expect(p.amount, isNull);
        expect(p.pixCode, isNull);
        expect(p.pixQrCode, isNull);
        expect(p.pixExpiresAt, isNull);
        expect(p.boletoCode, isNull);
        expect(p.boletoExpiresAt, isNull);
        expect(p.cardLastFour, isNull);
        expect(p.cardBrand, isNull);
        expect(p.installments, isNull);
      });

      test('preserva campos PIX quando fornecidos', () {
        final expires = DateTime(2026, 6, 9, 14, 9);
        final p = OrderPayment(
          type: 'pix',
          status: 'pending',
          amount: '45.90',
          pixCode: 'EMV_CODE_123',
          pixQrCode: 'base64imgdata',
          pixExpiresAt: expires,
        );
        expect(p.amount, '45.90');
        expect(p.pixCode, 'EMV_CODE_123');
        expect(p.pixQrCode, 'base64imgdata');
        expect(p.pixExpiresAt, expires);
      });

      test('preserva campos boleto quando fornecidos', () {
        final expires = DateTime(2026, 6, 10, 23, 59);
        final p = OrderPayment(
          type: 'boleto',
          status: 'pending',
          boletoCode: '03399.12345 67890.01234',
          boletoExpiresAt: expires,
        );
        expect(p.boletoCode, '03399.12345 67890.01234');
        expect(p.boletoExpiresAt, expires);
      });

      test('preserva campos cartão quando fornecidos', () {
        const p = OrderPayment(
          type: 'credit_card',
          status: 'approved',
          cardLastFour: '4242',
          cardBrand: 'Visa',
          installments: 3,
        );
        expect(p.cardLastFour, '4242');
        expect(p.cardBrand, 'Visa');
        expect(p.installments, 3);
      });
    });
  });

  group('Order', () {
    final tCreatedAt = DateTime(2026, 6, 8);

    test('payment é nulo por padrão', () {
      final order = Order(
        id: '1',
        status: OrderStatus.pending,
        items: const [],
        total: '10.00',
        createdAt: tCreatedAt,
      );
      expect(order.payment, isNull);
    });

    test('preserva payment PIX quando fornecido', () {
      const payment = OrderPayment(type: 'pix', status: 'pending', pixCode: 'CODE');
      final order = Order(
        id: '1',
        status: OrderStatus.pending,
        items: const [],
        total: '10.00',
        createdAt: tCreatedAt,
        payment: payment,
      );
      expect(order.payment, isNotNull);
      expect(order.payment!.isPix, isTrue);
      expect(order.payment!.pixCode, 'CODE');
    });

    test('igualdade baseada em id', () {
      final a = Order(id: '42', status: OrderStatus.pending, items: const [], total: '0', createdAt: tCreatedAt);
      final b = Order(id: '42', status: OrderStatus.delivered, items: const [], total: '99', createdAt: tCreatedAt);
      expect(a, equals(b));
    });

    test('statusHistory vazio por padrão', () {
      final order = Order(
        id: '1',
        status: OrderStatus.pending,
        items: const [],
        total: '0',
        createdAt: tCreatedAt,
      );
      expect(order.statusHistory, isEmpty);
    });
  });
}
