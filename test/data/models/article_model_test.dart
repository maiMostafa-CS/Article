import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:inc_project/features/articles/data/models/article_model.dart';
import 'package:inc_project/features/articles/domain/entities/article.dart';

void main() {
  group('ArticleModel', () {
    final testDateTime = DateTime(2024, 1, 15, 10, 30);

    final testArticleModel = ArticleModel(
      id: '1',
      title: 'Test Article',
      summary: 'Test Summary',
      imageUrl: 'https://example.com/image.jpg',
      publishedAt: testDateTime,
      isFavorite: false,
    );

    final testJson = {
      'id': '1',
      'title': 'Test Article',
      'summary': 'Test Summary',
      'imageUrl': 'https://example.com/image.jpg',
      'publishedAt': testDateTime.toIso8601String(),
      'isFavorite': false,
    };

    test('should be a subclass of Article entity', () {
      // Assert
      expect(testArticleModel, isA<Article>());
    });

    test('should create ArticleModel with all required properties', () {
      // Act
      final model = ArticleModel(
        id: '1',
        title: 'Test Article',
        summary: 'Test Summary',
        imageUrl: 'https://example.com/image.jpg',
        publishedAt: testDateTime,
        isFavorite: true,
      );

      // Assert
      expect(model.id, '1');
      expect(model.title, 'Test Article');
      expect(model.summary, 'Test Summary');
      expect(model.imageUrl, 'https://example.com/image.jpg');
      expect(model.publishedAt, testDateTime);
      expect(model.isFavorite, true);
    });

    test('should create ArticleModel with default isFavorite as false', () {
      // Act
      final model = ArticleModel(
        id: '1',
        title: 'Test Article',
        summary: 'Test Summary',
        imageUrl: 'https://example.com/image.jpg',
        publishedAt: testDateTime,
      );

      // Assert
      expect(model.isFavorite, false);
    });

    group('fromJson', () {
      test('should return a valid ArticleModel from JSON', () {
        // Act
        final result = ArticleModel.fromJson(testJson);

        // Assert
        expect(result, testArticleModel);
        expect(result.id, '1');
        expect(result.title, 'Test Article');
        expect(result.summary, 'Test Summary');
        expect(result.imageUrl, 'https://example.com/image.jpg');
        expect(result.publishedAt, testDateTime);
        expect(result.isFavorite, false);
      });

      test('should handle JSON without isFavorite field', () {
        // Arrange
        final jsonWithoutFavorite = Map<String, dynamic>.from(testJson);
        jsonWithoutFavorite.remove('isFavorite');

        // Act
        final result = ArticleModel.fromJson(jsonWithoutFavorite);

        // Assert
        expect(result.isFavorite, false); // Should default to false
      });

      test('should handle JSON with null values appropriately', () {
        // Arrange
        final jsonWithNulls = {
          'id': '1',
          'title': 'Test Article',
          'summary': 'Test Summary',
          'imageUrl': 'https://example.com/image.jpg',
          'publishedAt': testDateTime.toIso8601String(),
          'isFavorite': null,
        };

        // Act & Assert
        expect(
          () => ArticleModel.fromJson(jsonWithNulls),
          throwsA(isA<TypeError>()),
        );
      });

      test('should parse different date formats correctly', () {
        // Arrange
        final jsonWithDifferentDate = Map<String, dynamic>.from(testJson);
        jsonWithDifferentDate['publishedAt'] = '2024-01-15T10:30:00.000Z';

        // Act
        final result = ArticleModel.fromJson(jsonWithDifferentDate);

        // Assert
        expect(result.publishedAt, isA<DateTime>());
      });
    });

    group('toJson', () {
      test('should return a valid JSON map', () {
        // Act
        final result = testArticleModel.toJson();

        // Assert
        expect(result, testJson);
        expect(result['id'], '1');
        expect(result['title'], 'Test Article');
        expect(result['summary'], 'Test Summary');
        expect(result['imageUrl'], 'https://example.com/image.jpg');
        expect(result['publishedAt'], testDateTime.toIso8601String());
        expect(result['isFavorite'], false);
      });

      test('should include all required fields in JSON', () {
        // Act
        final result = testArticleModel.toJson();

        // Assert
        expect(result.containsKey('id'), true);
        expect(result.containsKey('title'), true);
        expect(result.containsKey('summary'), true);
        expect(result.containsKey('imageUrl'), true);
        expect(result.containsKey('publishedAt'), true);
        expect(result.containsKey('isFavorite'), true);
      });

      test('should handle favorite article correctly', () {
        // Arrange
        final favoriteModel = testArticleModel.copyWith(isFavorite: true);

        // Act
        final result = favoriteModel.toJson();

        // Assert
        expect(result['isFavorite'], true);
      });
    });

    group('fromEntity', () {
      test('should create ArticleModel from Article entity', () {
        // Arrange
        final article = Article(
          id: '1',
          title: 'Test Article',
          summary: 'Test Summary',
          imageUrl: 'https://example.com/image.jpg',
          publishedAt: testDateTime,
          isFavorite: true,
        );

        // Act
        final result = ArticleModel.fromEntity(article);

        // Assert
        expect(result, isA<ArticleModel>());
        expect(result.id, article.id);
        expect(result.title, article.title);
        expect(result.summary, article.summary);
        expect(result.imageUrl, article.imageUrl);
        expect(result.publishedAt, article.publishedAt);
        expect(result.isFavorite, article.isFavorite);
      });

      test('should preserve all properties from entity', () {
        // Arrange
        final article = Article(
          id: 'complex_id_123',
          title: 'Complex Title with Special Characters !@#',
          summary: 'Long summary with multiple sentences. This is a test.',
          imageUrl: 'https://example.com/path/to/image.png?param=value',
          publishedAt: DateTime(2023, 12, 25, 15, 45, 30),
          isFavorite: false,
        );

        // Act
        final result = ArticleModel.fromEntity(article);

        // Assert
        expect(result.id, 'complex_id_123');
        expect(result.title, 'Complex Title with Special Characters !@#');
        expect(
          result.summary,
          'Long summary with multiple sentences. This is a test.',
        );
        expect(
          result.imageUrl,
          'https://example.com/path/to/image.png?param=value',
        );
        expect(result.publishedAt, DateTime(2023, 12, 25, 15, 45, 30));
        expect(result.isFavorite, false);
      });
    });

    group('copyWith', () {
      test('should create a copy with updated properties', () {
        // Act
        final result = testArticleModel.copyWith(
          title: 'Updated Title',
          isFavorite: true,
        );

        // Assert
        expect(result, isA<ArticleModel>());
        expect(result.id, testArticleModel.id);
        expect(result.title, 'Updated Title');
        expect(result.summary, testArticleModel.summary);
        expect(result.imageUrl, testArticleModel.imageUrl);
        expect(result.publishedAt, testArticleModel.publishedAt);
        expect(result.isFavorite, true);
      });

      test('should return same values when no parameters provided', () {
        // Act
        final result = testArticleModel.copyWith();

        // Assert
        expect(result, testArticleModel);
      });

      test('should update all properties independently', () {
        // Arrange
        final newDateTime = DateTime(2025, 6, 1);

        // Act
        final result = testArticleModel.copyWith(
          id: 'new_id',
          title: 'New Title',
          summary: 'New Summary',
          imageUrl: 'https://new.example.com/image.jpg',
          publishedAt: newDateTime,
          isFavorite: true,
        );

        // Assert
        expect(result.id, 'new_id');
        expect(result.title, 'New Title');
        expect(result.summary, 'New Summary');
        expect(result.imageUrl, 'https://new.example.com/image.jpg');
        expect(result.publishedAt, newDateTime);
        expect(result.isFavorite, true);
      });
    });

    group('JSON serialization round trip', () {
      test('should maintain data integrity through JSON conversion', () {
        // Act
        final json = testArticleModel.toJson();
        final reconstructed = ArticleModel.fromJson(json);

        // Assert
        expect(reconstructed, testArticleModel);
      });

      test('should handle complex data through JSON conversion', () {
        // Arrange
        final complexModel = ArticleModel(
          id: 'complex-id_123@test.com',
          title: 'Title with "quotes" and \'apostrophes\'',
          summary: 'Summary with\nnewlines and\ttabs',
          imageUrl: 'https://example.com/image.jpg?param1=value1&param2=value2',
          publishedAt: DateTime(
            2024,
            2,
            29,
            23,
            59,
            59,
            999,
          ), // Leap year edge case
          isFavorite: true,
        );

        // Act
        final json = complexModel.toJson();
        final reconstructed = ArticleModel.fromJson(json);

        // Assert
        expect(reconstructed, complexModel);
      });
    });
  });
}
