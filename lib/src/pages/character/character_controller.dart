import 'package:mobx/mobx.dart';
import 'package:rick_and_morty_client/src/core/exceptions/repository_exception.dart';
import 'package:rick_and_morty_client/src/core/fp/either.dart';
import 'package:rick_and_morty_client/src/model/character_model.dart';
import 'package:rick_and_morty_client/src/model/response/character_response.dart';
import 'package:rick_and_morty_client/src/repository/character_repository.dart';

part 'character_controller.g.dart';

enum CharacterStateStatus {
  initial,
  loading,
  loaded,
  error,
}

class CharacterController = CharacterControllerBase with _$CharacterController;

abstract class CharacterControllerBase with Store {
  final CharacterRepository _characterRepository;

  CharacterControllerBase({
    required CharacterRepository characterRepository,
  }) : _characterRepository = characterRepository;

  @observable
  ObservableList<CharacterModel> character = ObservableList<CharacterModel>();

  @observable
  String? errorMessage;

  @observable
  CharacterStateStatus characterStateStatus = CharacterStateStatus.initial;

  @observable
  int currentPage = 1;

  @observable
  String? next;

  @action
  Future<void> fetchEpisodes({int page = 1}) async {
    if (next == null && page > 1) return;

    characterStateStatus = CharacterStateStatus.loading;
    final result = await _characterRepository.getCharacters(page: page);

    switch (result) {
      case Left(value: RepositoryException(:final message)):
        errorMessage = message;
        characterStateStatus = CharacterStateStatus.error;
      case Right(value: CharacterResponse(:final character, :final next)):
        if (page == 1) {
          this.character.clear();
        }
        this.character.addAll(character);
        this.next = next;
        characterStateStatus = CharacterStateStatus.loaded;
    }
    currentPage = page;
  }
}
