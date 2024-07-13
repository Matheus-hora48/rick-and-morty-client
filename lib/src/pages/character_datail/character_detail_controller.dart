import 'package:asyncstate/asyncstate.dart';
import 'package:mobx/mobx.dart';
import 'package:rick_and_morty_client/src/core/exceptions/repository_exception.dart';
import 'package:rick_and_morty_client/src/core/fp/either.dart';
import 'package:rick_and_morty_client/src/model/character_model.dart';
import 'package:rick_and_morty_client/src/model/episode_model.dart';
import 'package:rick_and_morty_client/src/repository/episode_repository.dart';

part 'character_detail_controller.g.dart';

class CharacterDetailController = CharacterDetailControllerBase
    with _$CharacterDetailController;

abstract class CharacterDetailControllerBase with Store {
  final EpisodeRepository _episodeRepository;

  CharacterDetailControllerBase({
    required EpisodeRepository episodeRepository,
  }) : _episodeRepository = episodeRepository;

  @observable
  CharacterModel? character;

  @observable
  ObservableList<EpisodeModel> episode = ObservableList<EpisodeModel>();

  @observable
  String? errorMessage;

  @action
  Future<void> fetchEpisodes(List<int> episodeIds) async {
    final result = await _episodeRepository
        .getMultipleEpisodes(
          ids: episodeIds,
        )
        .asyncLoader();

    switch (result) {
      case Left(value: RepositoryException(:final message)):
        errorMessage = message;
      case Right(value: List<EpisodeModel> data):
        episode.clear();
        episode.addAll(data);
    }
  }
}
