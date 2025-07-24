import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/article_repository.dart';

class GetFavoriteIds implements UseCase<List<String>, NoParams> {
  final ArticleRepository _repository;

  GetFavoriteIds(this._repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await _repository.getFavoriteIds();
  }
}
