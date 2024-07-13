import 'package:rick_and_morty_client/src/core/exceptions/repository_exception.dart';
import 'package:rick_and_morty_client/src/core/fp/either.dart';
import 'package:rick_and_morty_client/src/model/episode_model.dart';
import 'package:rick_and_morty_client/src/model/response/episode_response.dart';

abstract interface class EpisodeRepository {
  Future<Either<RepositoryException, EpisodeResponse>> getEpisodes({
    required int page,
  });
  Future<Either<RepositoryException, EpisodeModel>> getEpisode({
    required int id,
  });
  Future<Either<RepositoryException, List<EpisodeModel>>> getMultipleEpisodes({
    required List<int> ids,
  });
}
