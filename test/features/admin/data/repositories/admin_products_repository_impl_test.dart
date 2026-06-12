import 'dart:async';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doglio/core/errors/exceptions.dart';
import 'package:doglio/core/errors/failures.dart';
import 'package:doglio/features/admin/data/datasources/admin_products_remote_datasource.dart';
import 'package:doglio/features/admin/data/models/admin_product_model.dart';
import 'package:doglio/features/admin/data/models/stock_movement_model.dart';
import 'package:doglio/features/admin/data/repositories/admin_products_repository_impl.dart';
import 'package:doglio/features/admin/domain/entities/admin_product.dart';
import 'package:doglio/features/admin/domain/entities/admin_product_filters.dart';
import 'package:doglio/features/admin/domain/entities/page_meta.dart';
import 'package:doglio/features/admin/domain/entities/stock_movement.dart';

class MockDatasource extends Mock implements AdminProductsRemoteDatasource {}

const _model = AdminProductModel(
  id: 'p1',
  name: 'Ração',
  description: 'Desc',
  price: '89.90',
  isHighlighted: false,
  isActive: true,
  inStock: true,
  stockQuantity: 5,
);

const _product = AdminProduct(
  id: 'p1',
  name: 'Ração',
  description: 'Desc',
  price: '89.90',
  isHighlighted: false,
  isActive: true,
  inStock: true,
  stockQuantity: 5,
);

const _movement = StockMovementModel(
  id: 'm1',
  type: StockMovementType.stockIn,
  quantity: 10,
  stockBefore: 0,
  stockAfter: 10,
  reason: StockMovementReason.purchase,
);

void main() {
  late MockDatasource datasource;
  late AdminProductsRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(_model);
    registerFallbackValue(AdminProductFilters.empty);
  });

  setUp(() {
    datasource = MockDatasource();
    repository = AdminProductsRepositoryImpl(datasource);
  });

  group('getProducts', () {
    test('Right com lista + meta no sucesso', () async {
      when(() => datasource.getProducts(
            filters: any(named: 'filters'),
            page: any(named: 'page'),
          )).thenAnswer((_) async =>
          ([_model], const PageMeta(currentPage: 1, lastPage: 2, total: 30)));

      final result = await repository.getProducts();

      expect(result.isRight(), isTrue);
      final (products, meta) = result.getRight().toNullable()!;
      expect(products.single.id, 'p1');
      expect(meta.hasMore, isTrue);
    });

    test('Left(TimeoutFailure) em timeout', () async {
      when(() => datasource.getProducts(
            filters: any(named: 'filters'),
            page: any(named: 'page'),
          )).thenThrow(TimeoutException(null));

      final result = await repository.getProducts();
      expect(result.getLeft().toNullable(), isA<TimeoutFailure>());
    });

    test('Left(NetworkFailure) em erro de socket', () async {
      when(() => datasource.getProducts(
            filters: any(named: 'filters'),
            page: any(named: 'page'),
          )).thenThrow(const SocketException('sem rede'));

      final result = await repository.getProducts();
      expect(result.getLeft().toNullable(), isA<NetworkFailure>());
    });
  });

  group('createProduct', () {
    test('Right no sucesso', () async {
      when(() => datasource.createProduct(any(),
              imagePaths: any(named: 'imagePaths')))
          .thenAnswer((_) async => _model);

      final result =
          await repository.createProduct(_product, newImagePaths: const []);
      expect(result.isRight(), isTrue);
    });

    test('ValidationException vira ValidationFailure', () async {
      when(() => datasource.createProduct(any(),
              imagePaths: any(named: 'imagePaths')))
          .thenThrow(const ValidationException(
        'Falha na validação.',
        errors: {
          'price': ['O preço é obrigatório.'],
        },
      ));

      final result =
          await repository.createProduct(_product, newImagePaths: const []);

      final failure = result.getLeft().toNullable();
      expect(failure, isA<ValidationFailure>());
      expect(failure!.userMessage, contains('O preço é obrigatório.'));
    });
  });

  group('updateProduct', () {
    test('Right no sucesso', () async {
      when(() => datasource.updateProduct(
            any(),
            imagePaths: any(named: 'imagePaths'),
            removeImageIds: any(named: 'removeImageIds'),
          )).thenAnswer((_) async => _model);

      final result = await repository.updateProduct(
        _product,
        newImagePaths: const [],
        removeImageIds: const ['img1'],
      );
      expect(result.isRight(), isTrue);
    });

    test('Left(UnknownFailure) com a mensagem da exceção genérica', () async {
      when(() => datasource.updateProduct(
            any(),
            imagePaths: any(named: 'imagePaths'),
            removeImageIds: any(named: 'removeImageIds'),
          )).thenThrow(Exception('Máximo de 6 imagens.'));

      final result = await repository.updateProduct(
        _product,
        newImagePaths: const [],
        removeImageIds: const [],
      );

      final failure = result.getLeft().toNullable();
      expect(failure!.userMessage, contains('Máximo de 6 imagens.'));
    });
  });

  group('deleteProduct', () {
    test('Right(unit) no sucesso', () async {
      when(() => datasource.deleteProduct(any())).thenAnswer((_) async {});

      final result = await repository.deleteProduct('p1');
      expect(result.isRight(), isTrue);
    });

    test('Left quando datasource lança', () async {
      when(() => datasource.deleteProduct(any()))
          .thenThrow(Exception('não encontrado'));

      final result = await repository.deleteProduct('p1');
      expect(result.isLeft(), isTrue);
    });
  });

  group('getStockMovements', () {
    test('Right com histórico + meta', () async {
      when(() => datasource.getStockMovements(any(), page: any(named: 'page')))
          .thenAnswer((_) async => ([_movement], PageMeta.empty));

      final result = await repository.getStockMovements('p1');

      expect(result.isRight(), isTrue);
      final (movements, _) = result.getRight().toNullable()!;
      expect(movements.single.stockAfter, 10);
    });
  });

  group('adjustStock', () {
    test('converte enums para os valores da API', () async {
      when(() => datasource.adjustStock(
            any(),
            type: any(named: 'type'),
            quantity: any(named: 'quantity'),
            absolute: any(named: 'absolute'),
            reason: any(named: 'reason'),
            notes: any(named: 'notes'),
          )).thenAnswer((_) async => _movement);

      final result = await repository.adjustStock(
        'p1',
        type: StockMovementType.stockOut,
        quantity: 2,
        reason: StockMovementReason.productReturn,
      );

      expect(result.isRight(), isTrue);
      verify(() => datasource.adjustStock(
            'p1',
            type: 'out',
            quantity: 2,
            absolute: null,
            reason: 'return',
            notes: null,
          )).called(1);
    });

    test('Left quando datasource lança (INSUFFICIENT_STOCK)', () async {
      when(() => datasource.adjustStock(
            any(),
            type: any(named: 'type'),
            quantity: any(named: 'quantity'),
            absolute: any(named: 'absolute'),
            reason: any(named: 'reason'),
            notes: any(named: 'notes'),
          )).thenThrow(Exception('Estoque insuficiente.'));

      final result = await repository.adjustStock(
        'p1',
        type: StockMovementType.stockOut,
        quantity: 99,
      );

      expect(result.getLeft().toNullable()!.userMessage,
          contains('Estoque insuficiente.'));
    });
  });
}
