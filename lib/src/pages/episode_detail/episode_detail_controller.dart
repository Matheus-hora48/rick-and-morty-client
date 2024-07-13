import 'package:asyncstate/asyncstate.dart';
import 'package:mobx/mobx.dart';
import 'package:rick_and_morty_client/src/core/exceptions/repository_exception.dart';
import 'package:rick_and_morty_client/src/core/fp/either.dart';
import 'package:rick_and_morty_client/src/model/character_model.dart';
import 'package:rick_and_morty_client/src/model/episode_model.dart';
import 'package:rick_and_morty_client/src/repository/character_repository.dart';

part 'episode_detail_controller.g.dart';

class EpisodeDetailController = EpisodeDetailControllerBase with _$EpisodeDetailController;

abstract class EpisodeDetailControllerBase with Store {
  final CharacterRepository _characterRepository;

  EpisodeDetailControllerBase({
    required CharacterRepository characterRepository,
  }) : _characterRepository = characterRepository;

  @observable
  EpisodeModel? episode;

  @observable
  ObservableList<CharacterModel> characters = ObservableList<CharacterModel>();

  @observable
  String? errorMessage;

  @action
  Future<void> fetchCharacters(List<int> characterIds) async {
    final result = await _characterRepository
        .getMultipleCharacters(
          ids: characterIds,
        )
        .asyncLoader();

    switch (result) {
      case Left(value: RepositoryException(:final message)):
        errorMessage = message;
      case Right(value: List<CharacterModel> data):
        characters.clear();
        characters.addAll(data);
    }
  }
}
