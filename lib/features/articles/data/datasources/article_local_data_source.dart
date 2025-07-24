import 'dart:convert';

import 'package:inc_project/core/cache/hive_local_storage.dart';
import 'package:inc_project/features/articles/domain/entities/article.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/article_model.dart';

abstract class ArticleLocalDataSource {
  Future<List<String>> getFavoriteIds();
  Future<void> saveFavoriteIds(List<String> favoriteIds);
  Future<void> toggleFavorite(String articleId);
  Future<void> cacheArticles(List<Article> articles, int page);
  Future<List<Article>> getCachedArticles(int page);
  Future<void> clearCache();
  Future<bool> isCached(int page);
  Future<void> updateCachedArticle(Article article);
}

class ArticleLocalDataSourceImpl implements ArticleLocalDataSource {
  final SharedPreferences sharedPreferences;
  final HiveLocalStorage _localStorage;
  static const String _articlesBoxName = 'articles';
  static const String _articlesKey = 'cached_articles';

  ArticleLocalDataSourceImpl({
    required this.sharedPreferences,
    required HiveLocalStorage localStorage,
  }) : _localStorage = localStorage;

  @override
  Future<List<String>> getFavoriteIds() async {
    try {
      final favoriteIdsString = sharedPreferences.getString(
        AppConstants.favoritesKey,
      );
      if (favoriteIdsString != null) {
        final List<dynamic> favoriteIdsList = json.decode(favoriteIdsString);
        return favoriteIdsList.cast<String>();
      }
      return [];
    } catch (e) {
      throw CacheException('Failed to get favorite IDs: $e');
    }
  }

  @override
  Future<void> saveFavoriteIds(List<String> favoriteIds) async {
    try {
      final favoriteIdsString = json.encode(favoriteIds);
      await sharedPreferences.setString(
        AppConstants.favoritesKey,
        favoriteIdsString,
      );
    } catch (e) {
      throw CacheException('Failed to save favorite IDs: $e');
    }
  }

  @override
  Future<void> toggleFavorite(String articleId) async {
    try {
      final currentFavorites = await getFavoriteIds();
      final updatedFavorites = List<String>.from(currentFavorites);

      if (updatedFavorites.contains(articleId)) {
        updatedFavorites.remove(articleId);
      } else {
        updatedFavorites.add(articleId);
      }

      await saveFavoriteIds(updatedFavorites);
    } catch (e) {
      throw CacheException('Failed to toggle favorite: $e');
    }
  }

  @override
  Future<void> cacheArticles(List<Article> articles, int page) async {
    try {
      final articlesJson = articles
          .map((article) => ArticleModel.fromEntity(article).toJson())
          .toList();

      final cacheKey = '${_articlesKey}_page_$page';
      await _localStorage.save(
        key: cacheKey,
        value: json.encode(articlesJson),
        boxName: _articlesBoxName,
      );
    } catch (e) {
      throw CacheException('Failed to cache articles: $e');
    }
  }

  @override
  Future<List<Article>> getCachedArticles(int page) async {
    try {
      final cacheKey = '${_articlesKey}_page_$page';
      final cachedData = await _localStorage.load(
        key: cacheKey,
        boxName: _articlesBoxName,
      );

      if (cachedData == null) {
        return [];
      }

      final List<dynamic> articlesJson = json.decode(cachedData);
      final favoriteIds = await getFavoriteIds();

      return articlesJson.map((articleJson) {
        final article = ArticleModel.fromJson(articleJson);
        return article.copyWith(isFavorite: favoriteIds.contains(article.id));
      }).toList();
    } catch (e) {
      throw CacheException('Failed to get cached articles: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      // Clear all cached pages
      for (int page = 1; page <= 10; page++) {
        final cacheKey = '${_articlesKey}_page_$page';
        await _localStorage.delete(key: cacheKey, boxName: _articlesBoxName);
      }
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }

  @override
  Future<bool> isCached(int page) async {
    try {
      final cacheKey = '${_articlesKey}_page_$page';
      final cachedData = await _localStorage.load(
        key: cacheKey,
        boxName: _articlesBoxName,
      );
      return cachedData != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> updateCachedArticle(Article article) async {
    try {
      // Update article in all cached pages where it exists
      for (int page = 1; page <= 10; page++) {
        final cacheKey = '${_articlesKey}_page_$page';
        final cachedData = await _localStorage.load(
          key: cacheKey,
          boxName: _articlesBoxName,
        );

        if (cachedData != null) {
          final List<dynamic> articlesJson = json.decode(cachedData);
          bool updated = false;

          for (int i = 0; i < articlesJson.length; i++) {
            if (articlesJson[i]['id'] == article.id) {
              articlesJson[i] = ArticleModel.fromEntity(article).toJson();
              updated = true;
              break;
            }
          }

          if (updated) {
            await _localStorage.save(
              key: cacheKey,
              value: json.encode(articlesJson),
              boxName: _articlesBoxName,
            );
          }
        }
      }
    } catch (e) {
      throw CacheException('Failed to update cached article: $e');
    }
  }
}
