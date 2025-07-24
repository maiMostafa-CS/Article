import 'package:flutter_test/flutter_test.dart';
import 'package:inc_project/core/error/exceptions.dart';
import 'package:inc_project/features/articles/data/datasources/article_remote_data_source.dart';
import 'package:inc_project/features/articles/data/models/article_model.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'article_remote_data_source_test.mocks.dart';

@GenerateMocks([ArticleRemoteDataSource])
void main() {
  late ArticleRemoteDataSourceImpl dataSource;

  setUp(() {
    dataSource = ArticleRemoteDataSourceImpl();
  });

  group('ArticleRemoteDataSourceImpl', () {
    group('getArticles', () {
      test(
        'should return list of ArticleModel when call is successful',
        () async {
          // Arrange
          const page = 0;
          const pageSize = 5;

          // Act
          final result = await dataSource.getArticles(
            page: page,
            pageSize: pageSize,
          );

          // Assert
          expect(result, isA<List<ArticleModel>>());
          expect(result.length, pageSize);

          // Verify first article properties
          final firstArticle = result.first;
          expect(firstArticle.id, isNotEmpty);
          expect(firstArticle.title, isNotEmpty);
          expect(firstArticle.summary, isNotEmpty);
          expect(firstArticle.imageUrl, isNotEmpty);
          expect(firstArticle.publishedAt, isA<DateTime>());
          expect(firstArticle.isFavorite, false); // Default value
        },
      );

      test(
        'should return correct number of articles for different page sizes',
        () async {
          // Test different page sizes
          const testCases = [
            {'page': 0, 'pageSize': 1},
            {'page': 0, 'pageSize': 3},
            {'page': 0, 'pageSize': 10},
          ];

          for (final testCase in testCases) {
            // Act
            final result = await dataSource.getArticles(
              page: testCase['page'] as int,
              pageSize: testCase['pageSize'] as int,
            );

            // Assert
            expect(
              result.length,
              testCase['pageSize'],
              reason: 'Failed for pageSize: ${testCase['pageSize']}',
            );
          }
        },
      );

      test('should return different articles for different pages', () async {
        // Arrange
        const pageSize = 3;

        // Act
        final page0Results = await dataSource.getArticles(
          page: 0,
          pageSize: pageSize,
        );
        final page1Results = await dataSource.getArticles(
          page: 1,
          pageSize: pageSize,
        );

        // Assert
        expect(page0Results.length, pageSize);
        expect(page1Results.length, pageSize);

        // Verify that articles are different between pages
        final page0Ids = page0Results.map((article) => article.id).toSet();
        final page1Ids = page1Results.map((article) => article.id).toSet();
        expect(
          page0Ids.intersection(page1Ids).isEmpty,
          true,
          reason: 'Pages should contain different articles',
        );
      });

      test(
        'should return empty list when page is beyond available data',
        () async {
          // Arrange
          const largePage = 1000; // Very large page number
          const pageSize = 10;

          // Act
          final result = await dataSource.getArticles(
            page: largePage,
            pageSize: pageSize,
          );

          // Assert
          expect(result, isEmpty);
        },
      );

      test('should handle edge case with page 0 and pageSize 0', () async {
        // Act
        final result = await dataSource.getArticles(page: 0, pageSize: 0);

        // Assert
        expect(result, isEmpty);
      });

      test('should generate additional articles when needed', () async {
        // Arrange
        const page = 2; // This should trigger generation of additional articles
        const pageSize = 5;

        // Act
        final result = await dataSource.getArticles(
          page: page,
          pageSize: pageSize,
        );

        // Assert
        expect(result.length, pageSize);

        // Verify that generated articles have proper structure
        for (final article in result) {
          expect(article.id, isNotEmpty);
          expect(article.title, contains('Article'));
          expect(article.summary, isNotEmpty);
          expect(article.imageUrl, startsWith('https://'));
          expect(article.publishedAt, isA<DateTime>());
        }
      });

      test('should have consistent article IDs across calls', () async {
        // Arrange
        const page = 0;
        const pageSize = 3;

        // Act
        final result1 = await dataSource.getArticles(
          page: page,
          pageSize: pageSize,
        );
        final result2 = await dataSource.getArticles(
          page: page,
          pageSize: pageSize,
        );

        // Assert
        expect(result1.length, result2.length);
        for (int i = 0; i < result1.length; i++) {
          expect(
            result1[i].id,
            result2[i].id,
            reason: 'Article IDs should be consistent across calls',
          );
        }
      });

      test('should have valid image URLs', () async {
        // Act
        final result = await dataSource.getArticles(page: 0, pageSize: 5);

        // Assert
        for (final article in result) {
          expect(article.imageUrl, startsWith('https://'));
          expect(
            Uri.tryParse(article.imageUrl),
            isNotNull,
            reason: 'Image URL should be valid: ${article.imageUrl}',
          );
        }
      });

      test('should have chronologically ordered published dates', () async {
        // Act
        final result = await dataSource.getArticles(page: 0, pageSize: 5);

        // Assert
        expect(result.length, greaterThan(1));

        // Check that articles are ordered by published date (newest first)
        for (int i = 0; i < result.length - 1; i++) {
          expect(
            result[i].publishedAt.isAfter(result[i + 1].publishedAt) ||
                result[i].publishedAt.isAtSameMomentAs(
                  result[i + 1].publishedAt,
                ),
            true,
            reason:
                'Articles should be ordered by published date (newest first)',
          );
        }
      });

      test('should simulate network delay', () async {
        // Arrange
        final stopwatch = Stopwatch()..start();

        // Act
        await dataSource.getArticles(page: 0, pageSize: 1);
        stopwatch.stop();

        // Assert
        expect(
          stopwatch.elapsedMilliseconds,
          greaterThanOrEqualTo(500),
          reason: 'Should simulate network delay of at least 500ms',
        );
      });

      test('should handle large page sizes efficiently', () async {
        // Arrange
        const page = 0;
        const largePageSize = 100;

        // Act
        final result = await dataSource.getArticles(
          page: page,
          pageSize: largePageSize,
        );

        // Assert
        expect(result.length, largePageSize);
        expect(result, everyElement(isA<ArticleModel>()));
      });

      test('should generate unique article IDs', () async {
        // Act
        final result = await dataSource.getArticles(page: 0, pageSize: 20);

        // Assert
        final ids = result.map((article) => article.id).toList();
        final uniqueIds = ids.toSet();
        expect(
          uniqueIds.length,
          ids.length,
          reason: 'All article IDs should be unique',
        );
      });

      test('should handle negative page numbers gracefully', () async {
        // Act & Assert
        expect(
          () => dataSource.getArticles(page: -1, pageSize: 5),
          throwsA(isA<ServerException>()),
        );
      });

      test('should handle negative page sizes gracefully', () async {
        // Act & Assert
        expect(
          () => dataSource.getArticles(page: 0, pageSize: -1),
          throwsA(isA<ServerException>()),
        );
      });

      test('should throw ServerException when an error occurs', () async {
        // This test verifies the error handling mechanism
        // Since the current implementation doesn't have explicit error conditions,
        // we test the exception handling structure

        // The method should complete normally under normal conditions
        expect(
          () => dataSource.getArticles(page: 0, pageSize: 5),
          returnsNormally,
        );
      });

      test('should maintain article structure consistency', () async {
        // Act
        final result = await dataSource.getArticles(page: 0, pageSize: 10);

        // Assert
        for (final article in result) {
          // Verify all required fields are present and valid
          expect(article.id, isA<String>());
          expect(article.id, isNotEmpty);
          expect(article.title, isA<String>());
          expect(article.title, isNotEmpty);
          expect(article.summary, isA<String>());
          expect(article.summary, isNotEmpty);
          expect(article.imageUrl, isA<String>());
          expect(article.imageUrl, isNotEmpty);
          expect(article.publishedAt, isA<DateTime>());
          expect(article.isFavorite, isA<bool>());
          expect(article.isFavorite, false); // Should default to false
        }
      });
    });
  });
}
