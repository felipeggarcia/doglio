import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doglio/core/errors/exceptions.dart';
import 'package:doglio/core/errors/failures.dart';
import 'package:doglio/features/admin/data/datasources/admin_promotions_remote_datasource.dart';
import 'package:doglio/features/admin/data/models/admin_promotion_model.dart';
import 'package:doglio/features/admin/data/repositories/admin_promotions_repository_impl.dart';
import 'package:doglio/features/admin/domain/entities/admin_promotion.dart';
import 'package:doglio/features/admin/domain/entities/page_meta.dart';

class MockDatasource extends Mock
    implements AdminPromotionsRemoteDatasource {}

AdminPromotionModel _model({String id = '1'}) =>
    AdminPromotionModel.fromJson({
      'id': id,
      'name': 'Promo $id',
      'type': 'percentage',
      'discount_value': '10.00',
      'starts_at': '2026-01-01T00:00:00.000Z',
      'is_active': true,
      'is_currently_active': true,
      'min_quantity': 1,
    });

AdminPromotion _entity({String id = '1'}) => _model(id: id).toEntity();

const _meta = PageMeta(currentPage: 1, lastPage: 1, total: 2);

void main() {
  late MockDatasource datasource;
  late AdminPromotionsRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(_model());
    registerFallbackValue(<({String productId, int? useLimit})>[]);
    registerFallbackValue(<String>[]);
  });

  setUp(() {
    datasource = MockDatasource();
    repository = AdminPromotionsRepositoryImpl(datasource);
  });

  group('getPromotions', () {
    test('Right com lista e meta no sucesso', () async {
      when(() => datasource.getPromotions(
            isActive: any(named: 'isActive'),
            expired: any(named: 'expired'),
            search: any(named: 'search'),
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
          )).thenAnswer((_) async => ([_model(), _model(id: '2')], _meta));

      final result = await repository.getPromotions();

      expect(result.isRight(), isTrue);
      final (list, meta) = result.getRight().toNullable()!;
      expect(list.length, 2);
      expect(meta.total, 2);
    });

    test('Left quando datasource lança', () async {
      when(() => datasource.getPromotions(
            isActive: any(named: 'isActive'),
            expired: any(named: 'expired'),
            search: any(named: 'search'),
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
          )).thenThrow(Exception('erro'));

      final result = await repository.getPromotions();
      expect(result.isLeft(), isTrue);
    });
  });

  group('createPromotion', () {
    test('Right com entidade no sucesso', () async {
      when(() => datasource.createPromotion(
            any(),
            initialProducts: any(named: 'initialProducts'),
          )).thenAnswer((_) async => _model(id: '10'));

      final result = await repository.createPromotion(_entity());
      expect(result.isRight(), isTrue);
      expect(result.getRight().toNullable()!.id, '10');
    });

    test('Left(ValidationFailure) quando datasource lança ValidationException',
        () async {
      when(() => datasource.createPromotion(
            any(),
            initialProducts: any(named: 'initialProducts'),
          )).thenThrow(
        ValidationException(
          'Erro de validação.',
          errors: {
            'name': ['Obrigatório.']
          },
        ),
      );

      final result = await repository.createPromotion(_entity());
      expect(result.isLeft(), isTrue);
      expect(result.getLeft().toNullable(), isA<ValidationFailure>());
    });
  });

  group('updatePromotion', () {
    test('Right no sucesso', () async {
      when(() => datasource.updatePromotion(any()))
          .thenAnswer((_) async => _model());

      final result = await repository.updatePromotion(_entity());
      expect(result.isRight(), isTrue);
    });

    test('Left quando datasource lança', () async {
      when(() => datasource.updatePromotion(any()))
          .thenThrow(Exception('erro'));

      final result = await repository.updatePromotion(_entity());
      expect(result.isLeft(), isTrue);
    });
  });

  group('deletePromotion', () {
    test('Right(unit) no sucesso', () async {
      when(() => datasource.deletePromotion(any())).thenAnswer((_) async {});

      final result = await repository.deletePromotion('1');
      expect(result.isRight(), isTrue);
      expect(result.getRight().toNullable(), unit);
    });

    test('Left quando datasource lança', () async {
      when(() => datasource.deletePromotion(any()))
          .thenThrow(Exception('não encontrado'));

      final result = await repository.deletePromotion('1');
      expect(result.isLeft(), isTrue);
    });
  });

  group('linkProducts', () {
    test('Right no sucesso', () async {
      when(() => datasource.linkProducts(any(), any()))
          .thenAnswer((_) async => _model());

      final result = await repository.linkProducts(
        '1',
        [(productId: 'p1', useLimit: null)],
      );
      expect(result.isRight(), isTrue);
    });
  });

  group('unlinkProducts', () {
    test('Right no sucesso', () async {
      when(() => datasource.unlinkProducts(any(), any()))
          .thenAnswer((_) async => _model());

      final result = await repository.unlinkProducts('1', ['p1']);
      expect(result.isRight(), isTrue);
    });
  });
}
