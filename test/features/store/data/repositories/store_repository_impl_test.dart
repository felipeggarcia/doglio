import 'dart:async';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doglio/core/errors/exceptions.dart';
import 'package:doglio/core/errors/failures.dart';
import 'package:doglio/features/store/data/datasources/store_local_datasource.dart';
import 'package:doglio/features/store/data/datasources/store_remote_datasource.dart';
import 'package:doglio/features/store/data/models/product_model.dart';
import 'package:doglio/features/store/data/repositories/store_repository_impl.dart';

class MockRemote extends Mock implements StoreRemoteDatasource {}

class MockLocal extends Mock implements StoreLocalDatasource {}

ProductModel _product({String id = 'p1'}) => ProductModel(
      id: id,
      name: 'Produto $id',
      description: '',
      price: '9.99',
      inStock: true,
      isHighlighted: false,
      isActive: true,
      images: const [],
      categories: const [],
      reviewsCount: 0,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

CategoryModel _cat({String id = 'c1'}) => CategoryModel(
      id: id,
      name: 'Cat $id',
      slug: 'cat-$id',
      isHighlighted: false,
      isActive: true,
    );

void main() {
  late MockRemote remote;
  late MockLocal local;
  late StoreRepositoryImpl repository;

  setUp(() {
    remote = MockRemote();
    local = MockLocal();
    repository = StoreRepositoryImpl(
      remoteDatasource: remote,
      localDatasource: local,
    );
  });

  group('getProducts — online-first', () {
    test('Right com lista no sucesso remoto e salva no cache', () async {
      when(() => remote.getProducts()).thenAnswer(
        (_) async => [_product(id: 'p1'), _product(id: 'p2')],
      );
      when(() => local.saveProducts(any(), any())).thenAnswer((_) async {});

      final result = await repository.getProducts();

      expect(result.isRight(), isTrue);
      expect(result.getRight().toNullable()!.length, 2);
      verify(() => local.saveProducts(any(), any())).called(1);
    });

    test('SocketException → fallback para cache quando disponível', () async {
      when(() => remote.getProducts())
          .thenThrow(const SocketException('sem rede'));
      when(() => local.loadProducts(any()))
          .thenAnswer((_) async => [_product(id: 'cached')]);

      final result = await repository.getProducts();

      expect(result.isRight(), isTrue);
      expect(result.getRight().toNullable()!.single.id, 'cached');
    });

    test('SocketException sem cache → Left(NetworkFailure)', () async {
      when(() => remote.getProducts())
          .thenThrow(const SocketException('sem rede'));
      when(() => local.loadProducts(any())).thenAnswer((_) async => null);

      final result = await repository.getProducts();

      expect(result.getLeft().toNullable(), isA<NetworkFailure>());
    });

    test('TimeoutException sem cache → Left(TimeoutFailure)', () async {
      when(() => remote.getProducts())
          .thenThrow(TimeoutException('timeout'));
      when(() => local.loadProducts(any())).thenAnswer((_) async => null);

      final result = await repository.getProducts();

      expect(result.getLeft().toNullable(), isA<TimeoutFailure>());
    });

    test('NetworkException sem cache → Left(NetworkFailure)', () async {
      when(() => remote.getProducts())
          .thenThrow(const NetworkException('offline'));
      when(() => local.loadProducts(any())).thenAnswer((_) async => null);

      final result = await repository.getProducts();

      expect(result.getLeft().toNullable(), isA<NetworkFailure>());
    });
  });

  group('getCategories — online-first', () {
    test('Right no sucesso remoto e salva no cache', () async {
      when(() => remote.getCategories()).thenAnswer(
        (_) async => [_cat(id: 'c1')],
      );
      when(() => local.saveCategories(any())).thenAnswer((_) async {});

      final result = await repository.getCategories();

      expect(result.isRight(), isTrue);
      expect(result.getRight().toNullable()!.single.id, 'c1');
      verify(() => local.saveCategories(any())).called(1);
    });

    test('SocketException → fallback para cache', () async {
      when(() => remote.getCategories())
          .thenThrow(const SocketException('sem rede'));
      when(() => local.loadCategories())
          .thenAnswer((_) async => [_cat(id: 'cached')]);

      final result = await repository.getCategories();

      expect(result.isRight(), isTrue);
      expect(result.getRight().toNullable()!.single.id, 'cached');
    });

    test('SocketException sem cache → Left(NetworkFailure)', () async {
      when(() => remote.getCategories())
          .thenThrow(const SocketException('sem rede'));
      when(() => local.loadCategories()).thenAnswer((_) async => null);

      final result = await repository.getCategories();

      expect(result.getLeft().toNullable(), isA<NetworkFailure>());
    });
  });

  group('sem localDatasource', () {
    test('repositório funciona normalmente sem cache', () async {
      final repoWithoutCache = StoreRepositoryImpl(remoteDatasource: remote);
      when(() => remote.getProducts())
          .thenAnswer((_) async => [_product()]);

      final result = await repoWithoutCache.getProducts();

      expect(result.isRight(), isTrue);
    });
  });
}
