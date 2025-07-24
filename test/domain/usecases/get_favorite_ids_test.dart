import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:inc_project/core/error/failures.dart';
import 'package:inc_project/core/usecases/usecase.dart';
import 'package:inc_project/features/articles/domain/repositories/article_repository.dart';
import 'package:inc_project/features/articles/domain/usecases/get_favorite_ids.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_favorite_ids_test.mocks.dart';

@GenerateMocks([ArticleRepository])
void main() {
  late GetFavoriteIds usecase;
  late MockArticleRepository mockRepository;

  setUp(() {
    mockRepository = MockArticleRepository();
    usecase = GetFavoriteIds(mockRepository);
  });

  group('GetFavoriteIds UseCase', () {
    const testFavoriteIds = ['1', '3', '5', '7'];

    test(
      'should get favorite IDs from repository when call is successful',
      () async {
        // Arrange
        when(
          mockRepository.getFavoriteIds(),
        ).thenAnswer((_) async => const Right(testFavoriteIds));

        // Act
        final result = await usecase(NoParams());

        // Assert
        expect(result, const Right(testFavoriteIds));
        verify(mockRepository.getFavoriteIds());
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return empty list when no favorites exist', () async {
      // Arrange
      when(
        mockRepository.getFavoriteIds(),
      ).thenAnswer((_) async => const Right(<String>[]));

      // Act
      final result = await usecase(NoParams());

      // Assert
      expect(result, const Right(<String>[]));
      verify(mockRepository.getFavoriteIds());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return CacheFailure when repository call fails', () async {
      // Arrange
      const failure = CacheFailure('Failed to get favorite IDs');
      when(
        mockRepository.getFavoriteIds(),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(NoParams());

      // Assert
      expect(result, const Left(failure));
      verify(mockRepository.getFavoriteIds());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when server error occurs', () async {
      // Arrange
      const failure = ServerFailure('Server error');
      when(
        mockRepository.getFavoriteIds(),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(NoParams());

      // Assert
      expect(result, const Left(failure));
      verify(mockRepository.getFavoriteIds());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle large list of favorite IDs', () async {
      // Arrange
      final largeFavoriteList = List.generate(
        1000,
        (index) => 'article_$index',
      );
      when(
        mockRepository.getFavoriteIds(),
      ).thenAnswer((_) async => Right(largeFavoriteList));

      // Act
      final result = await usecase(NoParams());

      // Assert
      expect(result, Right(largeFavoriteList));
      verify(mockRepository.getFavoriteIds());
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
      when(
        mockRepository.getFavoriteIds(),
      ).thenAnswer((_) async => const Right(specialFavoriteIds));

      // Act
      final result = await usecase(NoParams());

      // Assert
      expect(result, const Right(specialFavoriteIds));
      verify(mockRepository.getFavoriteIds());
    });

    test('should not require any parameters', () async {
      // Arrange
      when(
        mockRepository.getFavoriteIds(),
      ).thenAnswer((_) async => const Right(testFavoriteIds));

      // Act
      final result = await usecase(NoParams());

      // Assert
      expect(result, const Right(testFavoriteIds));
      verify(mockRepository.getFavoriteIds());
    });

    test('should handle NetworkFailure', () async {
      // Arrange
      const failure = NetworkFailure('Network connection failed');
      when(
        mockRepository.getFavoriteIds(),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(NoParams());

      // Assert
      expect(result, const Left(failure));
      verify(mockRepository.getFavoriteIds());
    });
  });
}
