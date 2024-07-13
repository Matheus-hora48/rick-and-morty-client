import 'package:flutter_getit/flutter_getit.dart';
import 'package:rick_and_morty_client/src/core/env/env.dart';
import 'package:rick_and_morty_client/src/core/rest_client/rest_client.dart';
import 'package:rick_and_morty_client/src/pages/character/character_controller.dart';
import 'package:rick_and_morty_client/src/pages/character_datail/character_detail_controller.dart';
import 'package:rick_and_morty_client/src/pages/episode_detail/episode_detail_controller.dart';
import 'package:rick_and_morty_client/src/pages/episodes/episodes_controller.dart';
import 'package:rick_and_morty_client/src/pages/origin/origin_controller.dart';
import 'package:rick_and_morty_client/src/repository/character_repository.dart';
import 'package:rick_and_morty_client/src/repository/character_repository_impl.dart';
import 'package:rick_and_morty_client/src/repository/episode_repository.dart';
import 'package:rick_and_morty_client/src/repository/episode_repository_impl.dart';
import 'package:rick_and_morty_client/src/repository/location_repository.dart';
import 'package:rick_and_morty_client/src/repository/location_repository_impl.dart';

class RickAndMortyBinding extends ApplicationBindings {
  @override
  List<Bind<Object>> bindings() => [
        Bind.lazySingleton(
          (i) => RestClient(Env.backendBaseUrl),
        ),
        Bind.lazySingleton<EpisodeRepository>(
          (i) => EpisodeRepositoryImpl(restClient: i()),
        ),
        Bind.lazySingleton<CharacterRepository>(
          (i) => CharacterRepositoryImpl(restClient: i()),
        ),
        Bind.lazySingleton<LocationRepository>(
          (i) => LocationRepositoryImpl(restClient: i()),
        ),
        Bind.lazySingleton(
          (i) => EpisodeController(episodeRepository: i()),
        ),
        Bind.lazySingleton(
          (i) => CharacterDetailController(episodeRepository: i()),
        ),
        Bind.lazySingleton(
          (i) => OriginController(
            characterRepository: i(),
            locationRepository: i(),
          ),
        ),
        Bind.lazySingleton(
          (i) => EpisodeDetailController(characterRepository: i()),
        ),
        Bind.lazySingleton(
          (i) => CharacterController(characterRepository: i()),
        ),
      ];
}
