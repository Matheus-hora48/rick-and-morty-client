import 'package:rick_and_morty_client/src/core/exceptions/repository_exception.dart';
import 'package:rick_and_morty_client/src/core/fp/either.dart';
import 'package:rick_and_morty_client/src/model/episode_model.dart';

abstract interface class EpisodeRepository {
Future<Either<RepositoryException, List<EpisodeModel>>> getEpisodes({
    required int page,
  });
  Future<Either<RepositoryException, EpisodeModel>> getEpisode({
    required int id,
  });
}