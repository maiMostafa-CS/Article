import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:inc_project/core/error/failures.dart';
import 'package:inc_project/features/articles/domain/repositories/article_repository.dart';
import 'package:inc_project/features/articles/domain/usecases/save_favorite_ids.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'save_favorite_ids_test.mocks.dart';

@GenerateMocks([ArticleRepository])
void main() {
  late SaveFavoriteIds usecase;
  late MockArticleRepository mockRepository;

  setUp(() {
    mockRepository = MockArticleRepository();
    usecase = SaveFavoriteIds(mockRepository);
  });

  group('SaveFavoriteIds UseCase', () {
    const testFavoriteIds = ['1', '3', '5', '7'];
    const testParams = SaveFavoriteIdsParams(favoriteIds: testFavoriteIds);

    test(
      'should save favorite IDs successfully when repository call succeeds',
      () async {
        // Arrange
        when(
          mockRepository.saveFavoriteIds(any),
        ).thenAnswer((_) async => Right(unit));

        // Act
        final result = await usecase(testParams);

        // Assert
        expect(result, Right(unit));
        verify(mockRepository.saveFavoriteIds(testFavoriteIds));
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return CacheFailure when repository call fails', () async {
      // Arrange
      const failure = CacheFailure('Failed to save favorite IDs');
      when(
        mockRepository.saveFavoriteIds(any),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(testParams);

      // Assert
      expect(result, const Left(failure));
      verify(mockRepository.saveFavoriteIds(testFavoriteIds));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when server error occurs', () async {
      // Arrange
      const failure = ServerFailure('Server error');
      when(
        mockRepository.saveFavoriteIds(any),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(testParams);

      // Assert
      expect(result, const Left(failure));
      verify(mockRepository.saveFavoriteIds(testFavoriteIds));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should save empty list of favorite IDs', () async {
      // Arrange
      const emptyParams = SaveFavoriteIdsParams(favoriteIds: []);
      when(
        mockRepository.saveFavoriteIds(any),
      ).thenAnswer((_) async => Right(unit));

      // Act
      final result = await usecase(emptyParams);

      // Assert
      expect(result, Right(unit));
      verify(mockRepository.saveFavoriteIds([]));
    });

    test('should handle large list of favorite IDs', () async {
      // Arrange
      final largeFavoriteList = List.generate(
        1000,
        (index) => 'article_$index',
      );
      final largeParams = SaveFavoriteIdsParams(favoriteIds: largeFavoriteList);
      when(
        mockRepository.saveFavoriteIds(any),
      ).thenAnswer((_) async => Right(unit));

      // Act
      final result = await usecase(largeParams);

      // Assert
      expect(result, Right(unit));
      verify(mockRepository.saveFavoriteIds(largeFavoriteList));
    });

    test('should handle favorite IDs with special characters', () async {
      // Arrange
      const specialFavoriteIds = [
        'article-123',
        'article_456',
        'article@789',
        'article.abc',
        'article#def',
      ];
      const specialParams = SaveFavoriteIdsParams(
        favoriteIds: specialFavoriteIds,
      );
      when(
        mockRepository.saveFavoriteIds(any),
      ).thenAnswer((_) async => Right(unit));

      // Act
      final result = await usecase(specialParams);

      // Assert
      expect(result, Right(unit));
      verify(mockRepository.saveFavoriteIds(specialFavoriteIds));
    });

    test('should pass correct favorite IDs to repository', () async {
      // Arrange
      const customFavoriteIds = ['a', 'b', 'c'];
      const customParams = SaveFavoriteIdsParams(
        favoriteIds: customFavoriteIds,
      );
      when(
        mockRepository.saveFavoriteIds(any),
      ).thenAnswer((_) async => Right(unit));

      // Act
      await usecase(customParams);

      // Assert
      verify(mockRepository.saveFavoriteIds(customFavoriteIds));
    });

    test('should handle NetworkFailure', () async {
      // Arrange
      const failure = NetworkFailure('Network connection failed');
      when(
        mockRepository.saveFavoriteIds(any),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(testParams);

      // Assert
      expect(result, const Left(failure));
      verify(mockRepository.saveFavoriteIds(testFavoriteIds));
    });
  });

  group('SaveFavoriteIdsParams', () {
    test('should create params with correct favorite IDs', () {
      // Arrange
      const favoriteIds = ['1', '2', '3'];

      // Act
      const params = SaveFavoriteIdsParams(favoriteIds: favoriteIds);

      // Assert
      expect(params.favoriteIds, favoriteIds);
    });

    test('should support equality comparison', () {
      // Arrange
      const favoriteIds1 = ['1', '2', '3'];
      const favoriteIds2 = ['1', '2', '3'];
      const favoriteIds3 = ['4', '5', '6'];

      const params1 = SaveFavoriteIdsParams(favoriteIds: favoriteIds1);
      const params2 = SaveFavoriteIdsParams(favoriteIds: favoriteIds2);
      const params3 = SaveFavoriteIdsParams(favoriteIds: favoriteIds3);

      // Assert
      expect(params1, equals(params2));
      expect(params1, isNot(equals(params3)));
      expect(params1.hashCode, equals(params2.hashCode));
    });

    test('should return correct props for equality', () {
      // Arrange
      const favoriteIds = ['1', '2', '3'];
      const params = SaveFavoriteIdsParams(favoriteIds: favoriteIds);

      // Act
      final props = params.props;

      // Assert
      expect(props, [favoriteIds]);
    });

    test('should handle empty list', () {
      // Act
      const params = SaveFavoriteIdsParams(favoriteIds: []);

      // Assert
      expect(params.favoriteIds, isEmpty);
      expect(params.props, [[]]);
    });
  });
}
