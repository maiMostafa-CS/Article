import 'package:fpdart/fpdart.dart';
import 'package:inc_project/core/network/network_checker.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/article_repository.dart';
import '../datasources/article_local_data_source.dart';
import '../datasources/article_remote_data_source.dart';
import '../models/article_model.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleRemoteDataSource remoteDataSource;
  final ArticleLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ArticleRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Article>>> getArticles({
    required int page,
    required int pageSize,
  }) async {
    try {
      if (await networkInfo.checkIsConnected) {
        try {
          // Try to fetch from remote
          final remoteArticles = await remoteDataSource.getArticles(
            page: page,
            pageSize: pageSize,
          );

          // Get favorite IDs and mark articles as favorites
          final favoriteIds = await localDataSource.getFavoriteIds();
          final articlesWithFavorites = remoteArticles.map((article) {
            return article.copyWith(
              isFavorite: favoriteIds.contains(article.id),
            );
          }).toList();

          // Cache the articles for offline access
          await localDataSource.cacheArticles(articlesWithFavorites, page);

          return Right(articlesWithFavorites);
        } on ServerException catch (e) {
          // If server fails but we have cache, return cached data
          if (await localDataSource.isCached(page)) {
            final cachedArticles = await localDataSource.getCachedArticles(
              page,
            );
            return Right(cachedArticles);
          }
          return Left(ServerFailure(e.message));
        } on NetworkException catch (e) {
          // If network fails but we have cache, return cached data
          if (await localDataSource.isCached(page)) {
            final cachedArticles = await localDataSource.getCachedArticles(
              page,
            );
            return Right(cachedArticles);
          }
          return Left(NetworkFailure(e.message));
        }
      } else {
        // No internet connection, try to get cached articles
        if (await localDataSource.isCached(page)) {
          final cachedArticles = await localDataSource.getCachedArticles(page);
          return Right(cachedArticles);
        }
        return Left(
          NetworkFailure('No internet connection and no cached data available'),
        );
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> toggleFavorite(String articleId) async {
    try {
      // Toggle in local storage
      await localDataSource.toggleFavorite(articleId);

      // Find and update the article in cache
      final favoriteIds = await localDataSource.getFavoriteIds();

      // Check all cached pages for the article and update it
      for (int page = 1; page <= 10; page++) {
        if (await localDataSource.isCached(page)) {
          final cachedArticles = await localDataSource.getCachedArticles(page);
          final articleIndex = cachedArticles.indexWhere(
            (article) => article.id == articleId,
          );

          if (articleIndex != -1) {
            final updatedArticle = cachedArticles[articleIndex].copyWith(
              isFavorite: favoriteIds.contains(articleId),
            );
            await localDataSource.updateCachedArticle(updatedArticle);
            break;
          }
        }
      }
      return Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getFavoriteIds() async {
    try {
      final favoriteIds = await localDataSource.getFavoriteIds();
      return Right(favoriteIds);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveFavoriteIds(
    List<String> favoriteIds,
  ) async {
    try {
      await localDataSource.saveFavoriteIds(favoriteIds);
      return Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: $e'));
    }
  }
}
