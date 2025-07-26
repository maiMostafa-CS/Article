import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/article_bloc.dart';
import '../bloc/article_event.dart';
import '../bloc/article_state.dart';
import '../widgets/article_card.dart';

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ArticleBloc>()..add(const LoadArticles()),
      child: const ArticlesView(),
    );
  }
}

class ArticlesView extends StatefulWidget {
  const ArticlesView({super.key});

  @override
  State<ArticlesView> createState() => _ArticlesViewState();
}

class _ArticlesViewState extends State<ArticlesView> {
  final ScrollController _scrollController = ScrollController();
  Completer<void>? _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ArticleBloc>().add(const LoadMoreArticles());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'News Feed',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        actions: [
          IconButton(
          onPressed: () {
    _refreshCompleter = Completer<void>();
    context.read<ArticleBloc>().add(const RefreshArticles());
    if (_refreshCompleter != null) {
      _refreshCompleter!.future.then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Articles refreshed')),
        );
      });
    }
    },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocListener<ArticleBloc, ArticleState>(
        listener: (context, state) {
          // Complete refresh when state changes from refreshing
          if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
            if (state is ArticleLoaded && !state.isRefreshing) {
              _refreshCompleter!.complete();
              _refreshCompleter = null;
            } else if (state is ArticleError) {
              _refreshCompleter!.complete();
              _refreshCompleter = null;
            }
          }
        },
        child: BlocBuilder<ArticleBloc, ArticleState>(
          builder: (context, state) {
            if (state is ArticleInitial || state is ArticleLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ArticleError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      'Oops! Something went wrong',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<ArticleBloc>().add(const LoadArticles());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

            if (state is ArticleLoaded) {
              if (state.articles.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.article_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No articles found',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pull to refresh or try again later',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  _refreshCompleter = Completer<void>();
                  context.read<ArticleBloc>().add(const RefreshArticles());
                  return _refreshCompleter!.future;
                },
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.hasReachedMax
                      ? state.articles.length
                      : state.articles.length + 1,
                  itemBuilder: (context, index) {
                    if (index >= state.articles.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final article = state.articles[index];
                    return ArticleCard(
                      article: article,
                      onFavoritePressed: () {
                        context.read<ArticleBloc>().add(
                          ToggleArticleFavorite(articleId: article.id),
                        );
                      },
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
