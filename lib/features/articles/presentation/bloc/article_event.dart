import 'package:equatable/equatable.dart';

abstract class ArticleEvent extends Equatable {
  const ArticleEvent();

  @override
  List<Object> get props => [];
}

class LoadArticles extends ArticleEvent {
  const LoadArticles();
}

class LoadMoreArticles extends ArticleEvent {
  const LoadMoreArticles();
}

class RefreshArticles extends ArticleEvent {
  const RefreshArticles();
}

class ToggleArticleFavorite extends ArticleEvent {
  final String articleId;

  const ToggleArticleFavorite({required this.articleId});

  @override
  List<Object> get props => [articleId];
}