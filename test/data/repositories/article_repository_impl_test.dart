import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:inc_project/core/error/exceptions.dart';
import 'package:inc_project/core/error/failures.dart';
import 'package:inc_project/core/network/network_checker.dart';
import 'package:inc_project/features/articles/data/datasources/article_local_data_source.dart';
import 'package:inc_project/features/articles/data/datasources/article_remote_data_source.dart';
import 'package:inc_project/features/articles/data/models/article_model.dart';
import 'package:inc_project/features/articles/data/repositories/article_repository_impl.dart';
import 'package:inc_project/features/articles/domain/entities/article.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'article_repository_impl_test.mocks.dart';

@GenerateMocks([ArticleRemoteDataSource, ArticleLocalDataSource, NetworkInfo])
void main() {
  late ArticleRepositoryImpl repository;
  late MockArticleRemoteDataSource mockRemoteDataSource;
  late MockArticleLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockArticleRemoteDataSource();
    mockLocalDataSource = MockArticleLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ArticleRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getArticles', () {
    const testPage = 0;
    const testPageSize = 10;
    final testDateTime = DateTime(2024, 1, 15);

    final testArticleModels = [
      ArticleModel(
        id: '1',
        title: 'Test Article 1',
        summary: 'Test Summary 1',
        imageUrl: 'https://example.com/image1.jpg',
        publishedAt: testDateTime,
        isFavorite: false,
      ),
      ArticleModel(
        id: '2',
        title: 'Test Article 2',
        summary: 'Test Summary 2',
        imageUrl: 'https://example.com/image2.jpg',
        publishedAt: testDateTime,
        isFavorite: false,
      ),
    ];

    final testFavoriteIds = ['1'];

    final expectedArticlesWithFavorites = [
      testArticleModels[0].copyWith(isFavorite: true),
      testArticleModels[1].copyWith(isFavorite: false),
    ];

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.checkIsConnected).thenAnswer((_) async => true);
      });

      test(
        'should return remote data with favorites when call is successful',
        () async {
          // Arrange
          when(
            mockRemoteDataSource.getArticles(
              page: anyNamed('page'),
              pageSize: anyNamed('pageSize'),
            ),
          ).thenAnswer((_) async => testArticleModels);
          when(
            mockLocalDataSource.getFavoriteIds(),
          ).thenAnswer((_) async => testFavoriteIds);
          when(
            mockLocalDataSource.cacheArticles(any, any),
          ).thenAnswer((_) async {});

          // Act
          final result = await repository.getArticles(
            page: testPage,
            pageSize: testPageSize,
          );

          // Assert
          expect(result, Right(expectedArticlesWithFavorites));
          verify(
            mockRemoteDataSource.getArticles(
              page: testPage,
              pageSize: testPageSize,
            ),
          );
          verify(mockLocalDataSource.getFavoriteIds());
          verify(
            mockLocalDataSource.cacheArticles(
              expectedArticlesWithFavorites,
              testPage,
            ),
          );
        },
      );

      test(
        'should return cached data when remote call fails but cache exists',
        () async {
          // Arrange
          when(
            mockRemoteDataSource.getArticles(
              page: anyNamed('page'),
              pageSize: anyNamed('pageSize'),
            ),
          ).thenThrow(const ServerException('Server error'));
          when(mockLocalDataSource.isCached(any)).thenAnswer((_) async => true);
          when(
            mockLocalDataSource.getCachedArticles(any),
          ).thenAnswer((_) async => expectedArticlesWithFavorites);

          // Act
          final result = await repository.getArticles(
            page: testPage,
            pageSize: testPageSize,
          );

          // Assert
          expect(result, Right(expectedArticlesWithFavorites));
          verify(
            mockRemoteDataSource.getArticles(
              page: testPage,
              pageSize: testPageSize,
            ),
          );
          verify(mockLocalDataSource.isCached(testPage));
          verify(mockLocalDataSource.getCachedArticles(testPage));
        },
      );

      test(
        'should return ServerFailure when remote fails and no cache exists',
        () async {
          // Arrange
          when(
            mockRemoteDataSource.getArticles(
              page: anyNamed('page'),
              pageSize: anyNamed('pageSize'),
            ),
          ).thenThrow(const ServerException('Server error'));
          when(
            mockLocalDataSource.isCached(any),
          ).thenAnswer((_) async => false);

          // Act
          final result = await repository.getArticles(
            page: testPage,
            pageSize: testPageSize,
          );

          // Assert
          expect(result, const Left(ServerFailure('Server error')));
          verify(
            mockRemoteDataSource.getArticles(
              page: testPage,
              pageSize: testPageSize,
            ),
          );
          verify(mockLocalDataSource.isCached(testPage));
        },
      );

      test(
        'should return cached data when network exception occurs but cache exists',
        () async {
          // Arrange
          when(
            mockRemoteDataSource.getArticles(
              page: anyNamed('page'),
              pageSize: anyNamed('pageSize'),
            ),
          ).thenThrow(const NetworkException('Network error'));
          when(mockLocalDataSource.isCached(any)).thenAnswer((_) async => true);
          when(
            mockLocalDataSource.getCachedArticles(any),
          ).thenAnswer((_) async => expectedArticlesWithFavorites);

          // Act
          final result = await repository.getArticles(
            page: testPage,
            pageSize: testPageSize,
          );

          // Assert
          expect(result, Right(expectedArticlesWithFavorites));
          verify(mockLocalDataSource.isCached(testPage));
          verify(mockLocalDataSource.getCachedArticles(testPage));
        },
      );

      test(
        'should return NetworkFailure when network exception occurs and no cache exists',
        () async {
          // Arrange
          when(
            mockRemoteDataSource.getArticles(
              page: anyNamed('page'),
              pageSize: anyNamed('pageSize'),
            ),
          ).thenThrow(const NetworkException('Network error'));
          when(
            mockLocalDataSource.isCached(any),
          ).thenAnswer((_) async => false);

          // Act
          final result = await repository.getArticles(
            page: testPage,
            pageSize: testPageSize,
          );

          // Assert
          expect(result, const Left(NetworkFailure('Network error')));
          verify(mockLocalDataSource.isCached(testPage));
        },
      );
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.checkIsConnected).thenAnswer((_) async => false);
      });

      test('should return cached data when cache exists', () async {
        // Arrange
        when(mockLocalDataSource.isCached(any)).thenAnswer((_) async => true);
        when(
          mockLocalDataSource.getCachedArticles(any),
        ).thenAnswer((_) async => expectedArticlesWithFavorites);

        // Act
        final result = await repository.getArticles(
          page: testPage,
          pageSize: testPageSize,
        );

        // Assert
        expect(result, Right(expectedArticlesWithFavorites));
        verify(mockLocalDataSource.isCached(testPage));
        verify(mockLocalDataSource.getCachedArticles(testPage));
        verifyNever(
          mockRemoteDataSource.getArticles(
            page: anyNamed('page'),
            pageSize: anyNamed('pageSize'),
          ),
        );
      });

      test('should return NetworkFailure when no cache exists', () async {
        // Arrange
        when(mockLocalDataSource.isCached(any)).thenAnswer((_) async => false);

        // Act
        final result = await repository.getArticles(
          page: testPage,
          pageSize: testPageSize,
        );

        // Assert
        expect(
          result,
          const Left(
            NetworkFailure(
              'No internet connection and no cached data available',
            ),
          ),
        );
        verify(mockLocalDataSource.isCached(testPage));
        verifyNever(
          mockRemoteDataSource.getArticles(
            page: anyNamed('page'),
            pageSize: anyNamed('pageSize'),
          ),
        );
      });
    });

    test('should return CacheFailure when cache exception occurs', () async {
      // Arrange
      when(mockNetworkInfo.checkIsConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.getArticles(
          page: anyNamed('page'),
          pageSize: anyNamed('pageSize'),
        ),
      ).thenAnswer((_) async => testArticleModels);
      when(
        mockLocalDataSource.getFavoriteIds(),
      ).thenThrow(const CacheException('Cache error'));

      // Act
      final result = await repository.getArticles(
        page: testPage,
        pageSize: testPageSize,
      );

      // Assert
      expect(result, const Left(CacheFailure('Cache error')));
    });

    test('should return ServerFailure when unexpected error occurs', () async {
      // Arrange
      when(mockNetworkInfo.checkIsConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.getArticles(
          page: anyNamed('page'),
          pageSize: anyNamed('pageSize'),
        ),
      ).thenThrow(Exception('Unexpected error'));
      when(mockLocalDataSource.isCached(any)).thenAnswer((_) async => false);

      // Act
      final result = await repository.getArticles(
        page: testPage,
        pageSize: testPageSize,
      );

      // Assert
      expect(
        result,
        const Left(
          ServerFailure('Unexpected error: Exception: Unexpected error'),
        ),
      );
    });
  });

  group('toggleFavorite', () {
    const testArticleId = 'test_article_id';
    final testFavoriteIds = ['test_article_id'];
    final testCachedArticles = [
      ArticleModel(
        id: 'test_article_id',
        title: 'Test Article',
        summary: 'Test Summary',
        imageUrl: 'https://example.com/image.jpg',
        publishedAt: DateTime(2024, 1, 15),
        isFavorite: false,
      ),
    ];

    test('should toggle favorite successfully', () async {
      // Arrange
      when(mockLocalDataSource.toggleFavorite(any)).thenAnswer((_) async {});
      when(
        mockLocalDataSource.getFavoriteIds(),
      ).thenAnswer((_) async => testFavoriteIds);
      when(mockLocalDataSource.isCached(any)).thenAnswer((_) async => true);
      when(
        mockLocalDataSource.getCachedArticles(any),
      ).thenAnswer((_) async => testCachedArticles);
      when(
        mockLocalDataSource.updateCachedArticle(any),
      ).thenAnswer((_) async {});

      // Act
      final result = await repository.toggleFavorite(testArticleId);

      // Assert
      expect(result, Right(unit));
      verify(mockLocalDataSource.toggleFavorite(testArticleId));
      verify(mockLocalDataSource.getFavoriteIds());
    });

    test('should return CacheFailure when toggle favorite fails', () async {
      // Arrange
      when(
        mockLocalDataSource.toggleFavorite(any),
      ).thenThrow(const CacheException('Cache error'));

      // Act
      final result = await repository.toggleFavorite(testArticleId);

      // Assert
      expect(result, const Left(CacheFailure('Cache error')));
      verify(mockLocalDataSource.toggleFavorite(testArticleId));
    });

    test('should return CacheFailure when unexpected error occurs', () async {
      // Arrange
      when(
        mockLocalDataSource.toggleFavorite(any),
      ).thenThrow(Exception('Unexpected error'));

      // Act
      final result = await repository.toggleFavorite(testArticleId);

      // Assert
      expect(
        result,
        const Left(
          CacheFailure('Unexpected error: Exception: Unexpected error'),
        ),
      );
    });
  });

  group('getFavoriteIds', () {
    const testFavoriteIds = ['1', '3', '5'];

    test('should return favorite IDs successfully', () async {
      // Arrange
      when(
        mockLocalDataSource.getFavoriteIds(),
      ).thenAnswer((_) async => testFavoriteIds);

      // Act
      final result = await repository.getFavoriteIds();

      // Assert
      expect(result, const Right(testFavoriteIds));
      verify(mockLocalDataSource.getFavoriteIds());
    });

    test('should return CacheFailure when get favorite IDs fails', () async {
      // Arrange
      when(
        mockLocalDataSource.getFavoriteIds(),
      ).thenThrow(const CacheException('Cache error'));

      // Act
      final result = await repository.getFavoriteIds();

      // Assert
      expect(result, const Left(CacheFailure('Cache error')));
      verify(mockLocalDataSource.getFavoriteIds());
    });

    test('should return CacheFailure when unexpected error occurs', () async {
      // Arrange
      when(
        mockLocalDataSource.getFavoriteIds(),
      ).thenThrow(Exception('Unexpected error'));

      // Act
      final result = await repository.getFavoriteIds();

      // Assert
      expect(
        result,
        const Left(
          CacheFailure('Unexpected error: Exception: Unexpected error'),
        ),
      );
    });
  });

  group('saveFavoriteIds', () {
    const testFavoriteIds = ['1', '3', '5'];

    test('should save favorite IDs successfully', () async {
      // Arrange
      when(mockLocalDataSource.saveFavoriteIds(any)).thenAnswer((_) async {});

      // Act
      final result = await repository.saveFavoriteIds(testFavoriteIds);

      // Assert
      expect(result, Right(unit));
      verify(mockLocalDataSource.saveFavoriteIds(testFavoriteIds));
    });

    test('should return CacheFailure when save favorite IDs fails', () async {
      // Arrange
      when(
        mockLocalDataSource.saveFavoriteIds(any),
      ).thenThrow(const CacheException('Cache error'));

      // Act
      final result = await repository.saveFavoriteIds(testFavoriteIds);

      // Assert
      expect(result, const Left(CacheFailure('Cache error')));
      verify(mockLocalDataSource.saveFavoriteIds(testFavoriteIds));
    });

    test('should return CacheFailure when unexpected error occurs', () async {
      // Arrange
      when(
        mockLocalDataSource.saveFavoriteIds(any),
      ).thenThrow(Exception('Unexpected error'));

      // Act
      final result = await repository.saveFavoriteIds(testFavoriteIds);

      // Assert
      expect(
        result,
        const Left(
          CacheFailure('Unexpected error: Exception: Unexpected error'),
        ),
      );
    });
  });
}
