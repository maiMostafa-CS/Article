import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/article.dart';
import '../repositories/article_repository.dart';

class GetArticles implements UseCase<List<Article>, GetArticlesParams> {
  final ArticleRepository _repository;

  GetArticles(this._repository);

  @override
  Future<Either<Failure, List<Article>>> call(GetArticlesParams params) async {
    return await _repository.getArticles(
      page: params.page,
      pageSize: params.pageSize,
    );
  }
}

class GetArticlesParams extends Equatable {
  final int page;
  final int pageSize;

  const GetArticlesParams({required this.page, required this.pageSize});

  @override
  List<Object> get props => [page, pageSize];
}
