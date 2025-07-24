import 'package:inc_project/features/articles/data/models/article_model.dart';
import 'package:inc_project/features/articles/domain/entities/article.dart';

/// Test helper class providing common test utilities and mock data
class TestHelper {
  /// Creates a test Article entity with default or custom values
  static Article createTestArticle({
    String? id,
    String? title,
    String? summary,
    String? imageUrl,
    DateTime? publishedAt,
    bool? isFavorite,
  }) {
    return Article(
      id: id ?? 'test_id_1',
      title: title ?? 'Test Article Title',
      summary:
          summary ?? 'This is a test article summary for testing purposes.',
      imageUrl: imageUrl ?? 'https://example.com/test-image.jpg',
      publishedAt: publishedAt ?? DateTime(2023, 1, 1, 12, 0, 0),
      isFavorite: isFavorite ?? false,
    );
  }

  /// Creates a test ArticleModel with default or custom values
  static ArticleModel createTestArticleModel({
    String? id,
    String? title,
    String? summary,
    String? imageUrl,
    DateTime? publishedAt,
    bool? isFavorite,
  }) {
    return ArticleModel(
      id: id ?? 'test_model_id_1',
      title: title ?? 'Test Article Model Title',
      summary:
          summary ??
          'This is a test article model summary for testing purposes.',
      imageUrl: imageUrl ?? 'https://example.com/test-model-image.jpg',
      publishedAt: publishedAt ?? DateTime(2023, 1, 1, 12, 0, 0),
      isFavorite: isFavorite ?? false,
    );
  }

  /// Creates a list of test articles with sequential IDs
  static List<Article> createTestArticleList(int count, {bool? isFavorite}) {
    return List.generate(count, (index) {
      return createTestArticle(
        id: 'test_id_${index + 1}',
        title: 'Test Article ${index + 1}',
        summary: 'Test summary for article ${index + 1}',
        imageUrl: 'https://example.com/image${index + 1}.jpg',
        publishedAt: DateTime(2023, 1, index + 1, 12, 0, 0),
        isFavorite: isFavorite ?? (index % 2 == 0), // Alternate favorites
      );
    });
  }

  /// Creates a list of test article models with sequential IDs
  static List<ArticleModel> createTestArticleModelList(
    int count, {
    bool? isFavorite,
  }) {
    return List.generate(count, (index) {
      return createTestArticleModel(
        id: 'test_model_id_${index + 1}',
        title: 'Test Article Model ${index + 1}',
        summary: 'Test model summary for article ${index + 1}',
        imageUrl: 'https://example.com/model-image${index + 1}.jpg',
        publishedAt: DateTime(2023, 1, index + 1, 12, 0, 0),
        isFavorite: isFavorite ?? (index % 2 == 0), // Alternate favorites
      );
    });
  }

  /// Creates test JSON data for ArticleModel
  static Map<String, dynamic> createTestArticleJson({
    String? id,
    String? title,
    String? summary,
    String? imageUrl,
    String? publishedAt,
    bool? isFavorite,
  }) {
    return {
      'id': id ?? 'test_json_id_1',
      'title': title ?? 'Test JSON Article Title',
      'summary': summary ?? 'This is a test JSON article summary.',
      'imageUrl': imageUrl ?? 'https://example.com/test-json-image.jpg',
      'publishedAt': publishedAt ?? '2023-01-01T12:00:00.000Z',
      'isFavorite': isFavorite ?? false,
    };
  }

  /// Creates a list of test JSON data for articles
  static List<Map<String, dynamic>> createTestArticleJsonList(int count) {
    return List.generate(count, (index) {
      return createTestArticleJson(
        id: 'test_json_id_${index + 1}',
        title: 'Test JSON Article ${index + 1}',
        summary: 'Test JSON summary for article ${index + 1}',
        imageUrl: 'https://example.com/json-image${index + 1}.jpg',
        publishedAt: DateTime(2023, 1, index + 1, 12, 0, 0).toIso8601String(),
        isFavorite: index % 2 == 0, // Alternate favorites
      );
    });
  }

  /// Creates test favorite IDs list
  static List<String> createTestFavoriteIds(int count) {
    return List.generate(count, (index) => 'favorite_id_${index + 1}');
  }

  /// Creates test article with special characters in fields
  static Article createTestArticleWithSpecialCharacters() {
    return Article(
      id: 'test_id_special_@#\$%',
      title: 'Test Article with Special Characters: @#\$%^&*()_+-=[]{}|;:,.<>?',
      summary:
          'Summary with special chars: àáâãäåæçèéêëìíîïñòóôõöøùúûüý & emojis 🚀📱💻',
      imageUrl: 'https://example.com/special-image-@#\$%.jpg',
      publishedAt: DateTime(2023, 12, 31, 23, 59, 59),
      isFavorite: true,
    );
  }

  /// Creates test article with very long content
  static Article createTestArticleWithLongContent() {
    final longTitle = 'Very Long Title ' * 20; // 340 characters
    final longSummary =
        'This is a very long summary that contains a lot of text to test how the application handles articles with extensive content. ' *
        10; // ~1200 characters

    return Article(
      id: 'test_id_long_content',
      title: longTitle,
      summary: longSummary,
      imageUrl:
          'https://example.com/very-long-image-url-with-many-parameters.jpg?param1=value1&param2=value2&param3=value3',
      publishedAt: DateTime(2023, 6, 15, 14, 30, 45),
      isFavorite: false,
    );
  }

  /// Creates test article with minimal content
  static Article createTestArticleWithMinimalContent() {
    return Article(
      id: '1',
      title: 'A',
      summary: 'B',
      imageUrl: 'https://a.com/b.jpg',
      publishedAt: DateTime(2023, 1, 1),
      isFavorite: false,
    );
  }

  /// Creates test article with future date
  static Article createTestArticleWithFutureDate() {
    final futureDate = DateTime.now().add(Duration(days: 365));
    return createTestArticle(
      id: 'test_id_future',
      title: 'Future Article',
      summary: 'This article is from the future!',
      publishedAt: futureDate,
    );
  }

  /// Creates test article with past date
  static Article createTestArticleWithPastDate() {
    final pastDate = DateTime(1990, 1, 1);
    return createTestArticle(
      id: 'test_id_past',
      title: 'Historical Article',
      summary: 'This article is from the past!',
      publishedAt: pastDate,
    );
  }

  /// Creates test articles with different date ranges for sorting tests
  static List<Article> createTestArticlesWithDateRange() {
    return [
      createTestArticle(
        id: 'newest',
        title: 'Newest Article',
        publishedAt: DateTime(2023, 12, 31),
      ),
      createTestArticle(
        id: 'middle',
        title: 'Middle Article',
        publishedAt: DateTime(2023, 6, 15),
      ),
      createTestArticle(
        id: 'oldest',
        title: 'Oldest Article',
        publishedAt: DateTime(2023, 1, 1),
      ),
    ];
  }

  /// Creates test articles with mixed favorite status
  static List<Article> createTestArticlesWithMixedFavorites() {
    return [
      createTestArticle(id: 'fav_1', title: 'Favorite 1', isFavorite: true),
      createTestArticle(
        id: 'not_fav_1',
        title: 'Not Favorite 1',
        isFavorite: false,
      ),
      createTestArticle(id: 'fav_2', title: 'Favorite 2', isFavorite: true),
      createTestArticle(
        id: 'not_fav_2',
        title: 'Not Favorite 2',
        isFavorite: false,
      ),
    ];
  }

  /// Creates malformed JSON data for testing error handling
  static Map<String, dynamic> createMalformedArticleJson() {
    return {
      'id': 'malformed_id',
      // Missing required fields: title, summary, imageUrl, publishedAt
      'extraField': 'This should not be here',
      'publishedAt': 'invalid_date_format',
    };
  }

  /// Creates JSON with invalid date format
  static Map<String, dynamic> createArticleJsonWithInvalidDate() {
    return {
      'id': 'invalid_date_id',
      'title': 'Article with Invalid Date',
      'summary': 'This article has an invalid date format',
      'imageUrl': 'https://example.com/invalid-date.jpg',
      'publishedAt': 'not-a-valid-date',
      'isFavorite': false,
    };
  }

  /// Creates empty JSON object
  static Map<String, dynamic> createEmptyArticleJson() {
    return {};
  }

  /// Utility method to compare articles ignoring specific fields
  static bool compareArticlesIgnoringFields(
    Article article1,
    Article article2, {
    bool ignoreId = false,
    bool ignoreFavorite = false,
    bool ignorePublishedAt = false,
  }) {
    if (!ignoreId && article1.id != article2.id) return false;
    if (article1.title != article2.title) return false;
    if (article1.summary != article2.summary) return false;
    if (article1.imageUrl != article2.imageUrl) return false;
    if (!ignorePublishedAt && article1.publishedAt != article2.publishedAt)
      return false;
    if (!ignoreFavorite && article1.isFavorite != article2.isFavorite)
      return false;

    return true;
  }

  /// Utility method to extract IDs from article list
  static List<String> extractArticleIds(List<Article> articles) {
    return articles.map((article) => article.id).toList();
  }

  /// Utility method to filter favorite articles
  static List<Article> filterFavoriteArticles(List<Article> articles) {
    return articles.where((article) => article.isFavorite).toList();
  }

  /// Utility method to filter non-favorite articles
  static List<Article> filterNonFavoriteArticles(List<Article> articles) {
    return articles.where((article) => !article.isFavorite).toList();
  }

  /// Utility method to sort articles by date (newest first)
  static List<Article> sortArticlesByDateDesc(List<Article> articles) {
    final sortedList = List<Article>.from(articles);
    sortedList.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    return sortedList;
  }

  /// Utility method to sort articles by date (oldest first)
  static List<Article> sortArticlesByDateAsc(List<Article> articles) {
    final sortedList = List<Article>.from(articles);
    sortedList.sort((a, b) => a.publishedAt.compareTo(b.publishedAt));
    return sortedList;
  }

  /// Utility method to create paginated article lists
  static List<Article> createPaginatedArticles(int page, int pageSize) {
    final startIndex = page * pageSize;
    return List.generate(pageSize, (index) {
      final articleIndex = startIndex + index + 1;
      return createTestArticle(
        id: 'page_${page}_article_$articleIndex',
        title: 'Page $page Article $articleIndex',
        summary: 'Summary for page $page, article $articleIndex',
        publishedAt: DateTime(2023, 1, 1).add(Duration(days: articleIndex)),
      );
    });
  }

  /// Utility method to simulate network delay
  static Future<void> simulateNetworkDelay([int milliseconds = 500]) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }

  /// Utility method to create test data for different scenarios
  static Map<String, dynamic> createTestScenario(String scenarioName) {
    switch (scenarioName) {
      case 'empty_list':
        return {
          'articles': <Article>[],
          'favoriteIds': <String>[],
          'page': 0,
          'pageSize': 10,
        };
      case 'single_article':
        return {
          'articles': [createTestArticle()],
          'favoriteIds': ['test_id_1'],
          'page': 0,
          'pageSize': 1,
        };
      case 'multiple_articles':
        return {
          'articles': createTestArticleList(5),
          'favoriteIds': ['test_id_1', 'test_id_3', 'test_id_5'],
          'page': 0,
          'pageSize': 5,
        };
      case 'large_dataset':
        return {
          'articles': createTestArticleList(100),
          'favoriteIds': createTestFavoriteIds(50),
          'page': 0,
          'pageSize': 20,
        };
      default:
        throw ArgumentError('Unknown test scenario: $scenarioName');
    }
  }
}
