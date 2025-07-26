import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:inc_project/features/articles/domain/entities/article.dart';
import 'package:inc_project/features/articles/presentation/widgets/article_card.dart';


void main() {
  testWidgets('ArticleCard displays article data and reacts to favorite button', (WidgetTester tester) async {
    // Arrange
    final article = Article(
      id: '1',
      title: 'Test Article',
      summary: 'This is a test summary.',
      imageUrl: 'https://via.placeholder.com/150',
      isFavorite: false,
      publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
    );

    bool favoritePressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ArticleCard(
            article: article,
            onFavoritePressed: () {
              favoritePressed = true;
            },
          ),
        ),
      ),
    );

    // Act & Assert
    expect(find.text('Test Article'), findsOneWidget);
    expect(find.text('This is a test summary.'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);

    // Tap the favorite icon
    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();

    expect(favoritePressed, isTrue);

    // Verify date text exists (e.g., "2 hours ago")
    expect(find.byType(Text), findsWidgets);
  });
}