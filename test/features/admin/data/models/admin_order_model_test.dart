import 'package:flutter_test/flutter_test.dart';
import 'package:doglio/features/admin/data/models/admin_order_model.dart';
import 'package:doglio/features/admin/domain/entities/admin_order.dart';

Map<String, dynamic> _orderJson({
  dynamic id = 'abc123',
  String status = 'confirmed',
  bool withAddress = true,
  bool withPayment = true,
  bool withHistory = true,
}) =>
    {
      'id': id,
      'order_number': '00042',
      'status': status,
      'total_amount': '189.90',
      'discount_amount': '10.00',
      'delivery_type': 'delivery',
      'customer': {'id': 'c1', 'name': 'João Silva', 'email': 'joao@example.com'},
      'items': [
        {
          'id': 'item1',
          'quantity': 2,
          'unit_price': '89.90',
          'subtotal': '179.80',
          'product': {
            'id': 'p1',
            'name': 'Ração Premium',
            'primary_image': {'url': 'http://localhost/img.jpg'},
          },
        }
      ],
      if (withAddress)
        'shipping_address': {
          'street': 'Rua das Flores',
          'number': '123',
          'complement': 'Apto 4',
          'district': 'Centro',
          'city': 'Curitiba',
          'state': 'PR',
          'zip_code': '80000000',
        },
      if (withPayment)
        'payment': {
          'status': 'pending',
          'amount': '189.90',
          'pix_code': 'qrcode123',
          'pix_expires_at': '2026-06-11T15:00:00.000Z',
          'payment_method': {'name': 'PIX', 'type': 'pix'},
        },
      if (withHistory)
        'status_history': [
          {
            'status': 'pending',
            'notes': null,
            'created_at': '2026-06-10T10:00:00.000Z',
          },
          {
            'status': 'confirmed',
            'notes': 'Pagamento confirmado',
            'created_at': '2026-06-10T11:00:00.000Z',
          },
        ],
      'created_at': '2026-06-10T10:00:00.000Z',
      'updated_at': '2026-06-10T11:00:00.000Z',
    };

void main() {
  group('AdminOrderModel.fromJson', () {
    test('parseia todos os campos corretamente', () {
      final model = AdminOrderModel.fromJson(_orderJson());

      expect(model.id, 'abc123');
      expect(model.orderNumber, '00042');
      expect(model.status, AdminOrderStatus.confirmed);
      expect(model.totalAmount, '189.90');
      expect(model.discountAmount, '10.00');
      expect(model.deliveryType, 'delivery');

      expect(model.customer.name, 'João Silva');
      expect(model.customer.email, 'joao@example.com');

      expect(model.items.length, 1);
      expect(model.items.first.productName, 'Ração Premium');
      expect(model.items.first.quantity, 2);
      expect(model.items.first.unitPrice, '89.90');
      expect(model.items.first.productImageUrl, 'http://localhost/img.jpg');

      expect(model.shippingAddress, isNotNull);
      expect(model.shippingAddress!.city, 'Curitiba');
      expect(model.shippingAddress!.complement, 'Apto 4');

      expect(model.payment, isNotNull);
      expect(model.payment!.isPix, isTrue);
      expect(model.payment!.pixCode, 'qrcode123');

      expect(model.statusHistory.length, 2);
      expect(model.statusHistory.last.notes, 'Pagamento confirmado');
    });

    test('normaliza id inteiro para String', () {
      final model = AdminOrderModel.fromJson(_orderJson(id: 99));
      expect(model.id, '99');
      expect(model.id, isA<String>());
    });

    test('status desconhecido vira pending', () {
      final model = AdminOrderModel.fromJson(_orderJson(status: 'foobar'));
      expect(model.status, AdminOrderStatus.pending);
    });

    test('shipping_address ausente vira null', () {
      final model = AdminOrderModel.fromJson(_orderJson(withAddress: false));
      expect(model.shippingAddress, isNull);
    });

    test('payment ausente vira null', () {
      final model = AdminOrderModel.fromJson(_orderJson(withPayment: false));
      expect(model.payment, isNull);
    });

    test('items ausente vira lista vazia', () {
      final json = _orderJson()..remove('items');
      final model = AdminOrderModel.fromJson(json);
      expect(model.items, isEmpty);
    });

    test('status_history ausente vira lista vazia', () {
      final model = AdminOrderModel.fromJson(_orderJson(withHistory: false));
      expect(model.statusHistory, isEmpty);
    });

    test('discount_amount ausente vira null', () {
      final json = _orderJson()..remove('discount_amount');
      final model = AdminOrderModel.fromJson(json);
      expect(model.discountAmount, isNull);
    });

    test('customer map ausente usa valores em branco', () {
      final json = _orderJson()..remove('customer');
      final model = AdminOrderModel.fromJson(json);
      expect(model.customer.id, '');
      expect(model.customer.email, '');
    });
  });

  group('AdminOrderModel.toEntity', () {
    test('mapeia todos os campos para AdminOrder', () {
      final model = AdminOrderModel.fromJson(_orderJson());
      final entity = model.toEntity();

      expect(entity, isA<AdminOrder>());
      expect(entity.id, 'abc123');
      expect(entity.status, AdminOrderStatus.confirmed);
      expect(entity.customer.name, 'João Silva');
      expect(entity.items.first.productName, 'Ração Premium');
      expect(entity.shippingAddress!.city, 'Curitiba');
      expect(entity.payment!.isPix, isTrue);
      expect(entity.statusHistory.length, 2);
    });
  });

  group('AdminOrderShippingAddress.formatted', () {
    test('gera string formatada com complemento', () {
      const address = AdminOrderShippingAddress(
        street: 'Rua A',
        number: '10',
        complement: 'Sala 2',
        district: 'Bairro X',
        city: 'Cidade Y',
        state: 'PR',
        zipCode: '12345678',
      );
      expect(address.formatted, contains('Rua A, 10'));
      expect(address.formatted, contains('Sala 2'));
      expect(address.formatted, contains('Cidade Y - PR'));
    });

    test('omite complemento quando vazio', () {
      const address = AdminOrderShippingAddress(
        street: 'Av B',
        number: '5',
        district: 'Centro',
        city: 'X',
        state: 'SP',
        zipCode: '00000000',
      );
      expect(address.formatted, isNot(contains('null')));
    });
  });

  group('AdminOrderStatus', () {
    test('toApi e fromApi são inversos', () {
      for (final status in AdminOrderStatus.values) {
        expect(AdminOrderStatus.fromApi(status.toApi()), status);
      }
    });

    test('isFinal somente em delivered e cancelled', () {
      expect(AdminOrderStatus.delivered.isFinal, isTrue);
      expect(AdminOrderStatus.cancelled.isFinal, isTrue);
      expect(AdminOrderStatus.pending.isFinal, isFalse);
      expect(AdminOrderStatus.confirmed.isFinal, isFalse);
    });

    test('nextAllowed respeita o fluxo de transições', () {
      expect(AdminOrderStatus.pending.nextAllowed,
          containsAll([AdminOrderStatus.confirmed, AdminOrderStatus.cancelled]));
      expect(AdminOrderStatus.delivered.nextAllowed, isEmpty);
      expect(AdminOrderStatus.cancelled.nextAllowed, isEmpty);
    });
  });
}
