import 'package:equatable/equatable.dart';

import '../../domain/entities/article.dart';

abstract class ArticleState extends Equatable {
  const ArticleState();

  @override
  List<Object> get props => [];
}

class ArticleInitial extends ArticleState {
  const ArticleInitial();
}

class ArticleLoading extends ArticleState {
  const ArticleLoading();
}

class ArticleLoaded extends ArticleState {
  final List<Article> articles;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final bool isRefreshing;

  const ArticleLoaded({
    required this.articles,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
  });

  ArticleLoaded copyWith({
    List<Article>? articles,
    bool? hasReachedMax,
    bool? isLoadingMore,
    bool? isRefreshing,
  }) {
    return ArticleLoaded(
      articles: articles ?? this.articles,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object> get props => [articles, hasReachedMax, isLoadingMore, isRefreshing];
}

class ArticleError extends ArticleState {
  final String message;

  const ArticleError({required this.message});

  @override
  List<Object> get props => [message];
}