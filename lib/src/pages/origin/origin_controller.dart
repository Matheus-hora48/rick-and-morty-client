import 'package:asyncstate/asyncstate.dart';
import 'package:mobx/mobx.dart';
import 'package:rick_and_morty_client/src/core/exceptions/repository_exception.dart';
import 'package:rick_and_morty_client/src/core/fp/either.dart';
import 'package:rick_and_morty_client/src/model/character_model.dart';
import 'package:rick_and_morty_client/src/model/origin_model.dart';
import 'package:rick_and_morty_client/src/model/location_model.dart';
import 'package:rick_and_morty_client/src/repository/character_repository.dart';
import 'package:rick_and_morty_client/src/repository/location_repository.dart';

part 'origin_controller.g.dart';

class OriginController = OriginControllerBase with _$OriginController;

abstract class OriginControllerBase with Store {
  final CharacterRepository _characterRepository;
  final LocationRepository _locationRepository;

  OriginControllerBase({
    required CharacterRepository characterRepository,
    required LocationRepository locationRepository,
  })  : _characterRepository = characterRepository,
        _locationRepository = locationRepository;

  @observable
  OriginModel? origin;

  @observable
  LocationModel? location;

  @observable
  ObservableList<CharacterModel> characters = ObservableList<CharacterModel>();

  @observable
  String? errorMessage;

  @action
  Future<void> fetchLocation(int locationId) async {
    final result = await _locationRepository
        .getLocation(id: locationId)
        .asyncLoader();

    switch (result) {
      case Left(value: RepositoryException(:final message)):
        errorMessage = message;
      case Right(value: LocationModel data):
        location = data;
        await fetchCharacters(location!.residents);
    }
  }

  @action
  Future<void> fetchCharacters(List<String> characterUrls) async {
    final characterIds = characterUrls.map((url) => int.parse(url.split('/').last)).toList();
    final result = await _characterRepository
        .getMultipleCharacters(ids: characterIds)
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
