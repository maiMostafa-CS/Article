import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/article_repository.dart';

class ToggleFavorite implements UseCase<Unit, ToggleFavoriteParams> {
  final ArticleRepository _repository;

  ToggleFavorite(this._repository);

  @override
  Future<Either<Failure, Unit>> call(ToggleFavoriteParams params) async {
    return await _repository.toggleFavorite(params.articleId);
  }
}

class ToggleFavoriteParams extends Equatable {
  final String articleId;

  const ToggleFavoriteParams({required this.articleId});

  @override
  List<Object> get props => [articleId];
}
