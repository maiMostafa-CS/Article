import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/article.dart';

abstract class ArticleRepository {
  Future<Either<Failure, List<Article>>> getArticles({
    required int page,
    required int pageSize,
  });
  Future<Either<Failure, Unit>> toggleFavorite(String articleId);
  Future<Either<Failure, List<String>>> getFavoriteIds();
  Future<Either<Failure, Unit>> saveFavoriteIds(List<String> favoriteIds);
}
