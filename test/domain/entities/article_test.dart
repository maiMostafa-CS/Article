import 'package:flutter_test/flutter_test.dart';
import 'package:inc_project/features/articles/domain/entities/article.dart';

void main() {
  group('Article Entity', () {
    final publishedAt = DateTime(2024, 1, 1);

    final testArticle = Article(
      id: '1',
      title: 'Test Article',
      summary: 'Test Summary',
      imageUrl: 'https://example.com/image.jpg',
      publishedAt: publishedAt,
      isFavorite: false,
    );

    test('should create Article with required properties', () {
      // Arrange

      // Act
      final article = Article(
        id: '1',
        title: 'Test Article',
        summary: 'Test Summary',
        imageUrl: 'https://example.com/image.jpg',
        publishedAt: publishedAt,
        isFavorite: false,
      );

      // Assert
      expect(article.id, '1');
      expect(article.title, 'Test Article');
      expect(article.summary, 'Test Summary');
      expect(article.imageUrl, 'https://example.com/image.jpg');
      expect(article.isFavorite, false);
    });

    test('should create Article with default isFavorite as false', () {
      // Act
      final article = Article(
        id: '1',
        title: 'Test Article',
        summary: 'Test Summary',
        imageUrl: 'https://example.com/image.jpg',
        publishedAt: publishedAt,
      );

      // Assert
      expect(article.isFavorite, false);
    });

    test('should create copy with updated properties', () {
      // Arrange
      final publishedAt = DateTime(2024, 1, 1);
      final article = Article(
        id: '1',
        title: 'Test Article',
        summary: 'Test Summary',
        imageUrl: 'https://example.com/image.jpg',
        publishedAt: publishedAt,
        isFavorite: false,
      );

      // Act
      final updatedArticle = article.copyWith(
        title: 'Updated Title',
        isFavorite: true,
      );

      // Assert
      expect(updatedArticle.id, '1');
      expect(updatedArticle.title, 'Updated Title');
      expect(updatedArticle.summary, 'Test Summary');
      expect(updatedArticle.imageUrl, 'https://example.com/image.jpg');
      expect(updatedArticle.publishedAt, publishedAt);
      expect(updatedArticle.isFavorite, true);
    });

    test('should maintain equality based on props', () {
      // Arrange
      final publishedAt = DateTime(2024, 1, 1);
      final article1 = Article(
        id: '1',
        title: 'Test Article',
        summary: 'Test Summary',
        imageUrl: 'https://example.com/image.jpg',
        publishedAt: publishedAt,
        isFavorite: false,
      );

      final article2 = Article(
        id: '1',
        title: 'Test Article',
        summary: 'Test Summary',
        imageUrl: 'https://example.com/image.jpg',
        publishedAt: publishedAt,
        isFavorite: false,
      );

      final article3 = Article(
        id: '2',
        title: 'Test Article',
        summary: 'Test Summary',
        imageUrl: 'https://example.com/image.jpg',
        publishedAt: publishedAt,
        isFavorite: false,
      );

      // Assert
      expect(article1, equals(article2));
      expect(article1, isNot(equals(article3)));
      expect(article1.hashCode, equals(article2.hashCode));
    });

    test('should return correct props for equality comparison', () {
      // Arrange
      final publishedAt = DateTime(2024, 1, 1);
      final article = Article(
        id: '1',
        title: 'Test Article',
        summary: 'Test Summary',
        imageUrl: 'https://example.com/image.jpg',
        publishedAt: publishedAt,
        isFavorite: true,
      );

      // Act
      final props = article.props;

      // Assert
      expect(props, [
        '1',
        'Test Article',
        'Test Summary',
        'https://example.com/image.jpg',
        publishedAt,
        true,
      ]);
    });
  });
}
