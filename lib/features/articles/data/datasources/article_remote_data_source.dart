import 'dart:convert';
import 'dart:math';

import '../../../../core/error/exceptions.dart';
import '../models/article_model.dart';

abstract class ArticleRemoteDataSource {
  Future<List<ArticleModel>> getArticles({
    required int page,
    required int pageSize,
  });
}

class ArticleRemoteDataSourceImpl implements ArticleRemoteDataSource {
  // Mock data for demonstration
  static final List<Map<String, dynamic>> _mockArticles = [
    {
      'id': '1',
      'title': 'Flutter 3.0 Released with Amazing New Features',
      'summary':
          'Google announces Flutter 3.0 with improved performance, new widgets, and better developer experience.',
      'imageUrl': 'https://picsum.photos/400/200?random=1',
      'publishedAt': DateTime.now()
          .subtract(const Duration(hours: 2))
          .toIso8601String(),
    },
    {
      'id': '2',
      'title': 'Dart 3.0: The Future of Programming',
      'summary':
          'Explore the new features and improvements in Dart 3.0 that make development faster and more efficient.',
      'imageUrl': 'https://picsum.photos/400/200?random=2',
      'publishedAt': DateTime.now()
          .subtract(const Duration(hours: 4))
          .toIso8601String(),
    },
    {
      'id': '3',
      'title': 'Clean Architecture in Flutter: Best Practices',
      'summary':
          'Learn how to implement Clean Architecture in your Flutter apps for better maintainability and testability.',
      'imageUrl': 'https://picsum.photos/400/200?random=3',
      'publishedAt': DateTime.now()
          .subtract(const Duration(hours: 6))
          .toIso8601String(),
    },
    {
      'id': '4',
      'title': 'State Management with BLoC Pattern',
      'summary':
          'Master the BLoC pattern for effective state management in Flutter applications.',
      'imageUrl': 'https://picsum.photos/400/200?random=4',
      'publishedAt': DateTime.now()
          .subtract(const Duration(hours: 8))
          .toIso8601String(),
    },
    {
      'id': '5',
      'title': 'Building Responsive UIs in Flutter',
      'summary':
          'Create beautiful and responsive user interfaces that work across all screen sizes.',
      'imageUrl': 'https://picsum.photos/400/200?random=5',
      'publishedAt': DateTime.now()
          .subtract(const Duration(hours: 10))
          .toIso8601String(),
    },
    {
      'id': '6',
      'title': 'Flutter Performance Optimization Tips',
      'summary':
          'Discover techniques to optimize your Flutter app performance and reduce memory usage.',
      'imageUrl': 'https://picsum.photos/400/200?random=6',
      'publishedAt': DateTime.now()
          .subtract(const Duration(hours: 12))
          .toIso8601String(),
    },
    {
      'id': '7',
      'title': 'Testing Flutter Apps: A Complete Guide',
      'summary':
          'Learn how to write unit, widget, and integration tests for your Flutter applications.',
      'imageUrl': 'https://picsum.photos/400/200?random=7',
      'publishedAt': DateTime.now()
          .subtract(const Duration(hours: 14))
          .toIso8601String(),
    },
    {
      'id': '8',
      'title': 'Firebase Integration with Flutter',
      'summary':
          'Integrate Firebase services like Authentication, Firestore, and Cloud Functions in your Flutter app.',
      'imageUrl': 'https://picsum.photos/400/200?random=8',
      'publishedAt': DateTime.now()
          .subtract(const Duration(hours: 16))
          .toIso8601String(),
    },
    {
      'id': '9',
      'title': 'Flutter Web: Building for the Browser',
      'summary':
          'Explore Flutter Web capabilities and learn how to build web applications with Flutter.',
      'imageUrl': 'https://picsum.photos/400/200?random=9',
      'publishedAt': DateTime.now()
          .subtract(const Duration(hours: 18))
          .toIso8601String(),
    },
    {
      'id': '10',
      'title': 'Advanced Animation Techniques in Flutter',
      'summary':
          'Create stunning animations and transitions to enhance user experience in your Flutter apps.',
      'imageUrl': 'https://picsum.photos/400/200?random=10',
      'publishedAt': DateTime.now()
          .subtract(const Duration(hours: 20))
          .toIso8601String(),
    },
  ];

  @override
  Future<List<ArticleModel>> getArticles({
    required int page,
    required int pageSize,
  }) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Generate more articles if needed
      final totalArticles = _generateArticles(page * pageSize + pageSize);

      final startIndex = page * pageSize;
      final endIndex = (startIndex + pageSize).clamp(0, totalArticles.length);

      if (startIndex >= totalArticles.length) {
        return [];
      }

      final paginatedArticles = totalArticles.sublist(startIndex, endIndex);

      return paginatedArticles
          .map((json) => ArticleModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException('Failed to fetch articles: $e');
    }
  }

  List<Map<String, dynamic>> _generateArticles(int count) {
    final articles = <Map<String, dynamic>>[];
    final random = Random();

    for (int i = 0; i < count; i++) {
      if (i < _mockArticles.length) {
        articles.add(_mockArticles[i]);
      } else {
        // Generate additional articles
        articles.add({
          'id': '${i + 1}',
          'title': 'Generated Article ${i + 1}: Flutter Development Tips',
          'summary':
              'This is a generated article about Flutter development best practices and tips for building amazing apps.',
          'imageUrl': 'https://picsum.photos/400/200?random=${i + 1}',
          'publishedAt': DateTime.now()
              .subtract(Duration(hours: (i + 1) * 2))
              .toIso8601String(),
        });
      }
    }

    return articles;
  }
}
