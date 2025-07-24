import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/article_repository.dart';

class SaveFavoriteIds implements UseCase<Unit, SaveFavoriteIdsParams> {
  final ArticleRepository _repository;

  SaveFavoriteIds(this._repository);

  @override
  Future<Either<Failure, Unit>> call(SaveFavoriteIdsParams params) async {
    return await _repository.saveFavoriteIds(params.favoriteIds);
  }
}

class SaveFavoriteIdsParams extends Equatable {
  final List<String> favoriteIds;

  const SaveFavoriteIdsParams({required this.favoriteIds});

  @override
  List<Object> get props => [favoriteIds];
}
