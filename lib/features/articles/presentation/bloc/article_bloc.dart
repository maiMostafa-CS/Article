import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_articles.dart';
import '../../domain/usecases/toggle_favorite.dart';
import 'article_event.dart';
import 'article_state.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  final GetArticles getArticles;
  final ToggleFavorite toggleFavorite;

  int _currentPage = 0;

  ArticleBloc({required this.getArticles, required this.toggleFavorite})
    : super(const ArticleInitial()) {
    on<LoadArticles>(_onLoadArticles);
    on<LoadMoreArticles>(_onLoadMoreArticles);
    on<RefreshArticles>(_onRefreshArticles);
    on<ToggleArticleFavorite>(_onToggleArticleFavorite);
  }

  Future<void> _onLoadArticles(
    LoadArticles event,
    Emitter<ArticleState> emit,
  ) async {
    emit(const ArticleLoading());
    _currentPage = 0;

    final result = await getArticles(
      GetArticlesParams(page: _currentPage, pageSize: AppConstants.pageSize),
    );

    result.fold(
      (failure) => emit(ArticleError(message: _mapFailureToMessage(failure))),
      (articles) => emit(
        ArticleLoaded(
          articles: articles,
          hasReachedMax: articles.length < AppConstants.pageSize,
        ),
      ),
    );
  }

  Future<void> _onLoadMoreArticles(
    LoadMoreArticles event,
    Emitter<ArticleState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ArticleLoaded ||
        currentState.hasReachedMax ||
        currentState.isLoadingMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));
    _currentPage++;

    final result = await getArticles(
      GetArticlesParams(page: _currentPage, pageSize: AppConstants.pageSize),
    );

    result.fold(
      (failure) => emit(ArticleError(message: _mapFailureToMessage(failure))),
      (newArticles) {
        final allArticles = List.of(currentState.articles)..addAll(newArticles);
        emit(
          ArticleLoaded(
            articles: allArticles,
            hasReachedMax: newArticles.length < AppConstants.pageSize,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  Future<void> _onRefreshArticles(
    RefreshArticles event,
    Emitter<ArticleState> emit,
  ) async {
    final currentState = state;

    // If we have loaded articles, keep them visible during refresh
    if (currentState is ArticleLoaded) {
      emit(currentState.copyWith(isRefreshing: true));
    } else {
      emit(const ArticleLoading());
    }


    _currentPage = 0;

    final result = await getArticles(
      GetArticlesParams(page: _currentPage, pageSize: AppConstants.pageSize),
    );

    result.fold(
      (failure) => emit(ArticleError(message: _mapFailureToMessage(failure))),
      (articles) => emit(
        ArticleLoaded(
          articles: articles,
          hasReachedMax: articles.length < AppConstants.pageSize,
          isRefreshing: false,
        ),
      ),
    );
  }

  Future<void> _onToggleArticleFavorite(
    ToggleArticleFavorite event,
    Emitter<ArticleState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ArticleLoaded) return;

    final result = await toggleFavorite(
      ToggleFavoriteParams(articleId: event.articleId),
    );

    result.fold(
      (failure) => emit(ArticleError(message: _mapFailureToMessage(failure))),
      (_) {
        // Update the article in the current list
        final updatedArticles = currentState.articles.map((article) {
          if (article.id == event.articleId) {
            return article.copyWith(isFavorite: !article.isFavorite);
          }
          return article;
        }).toList();

        emit(currentState.copyWith(articles: updatedArticles));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return AppConstants.networkError;
      case CacheFailure:
        return 'Cache error occurred';
      case NetworkFailure:
        return AppConstants.noInternetError;
      default:
        return AppConstants.unknownError;
    }
  }
}
