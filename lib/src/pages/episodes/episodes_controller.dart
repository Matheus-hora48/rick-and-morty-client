import 'package:mobx/mobx.dart';
import 'package:rick_and_morty_client/src/core/exceptions/repository_exception.dart';
import 'package:rick_and_morty_client/src/core/fp/either.dart';
import 'package:rick_and_morty_client/src/model/episode_model.dart';
import 'package:rick_and_morty_client/src/model/response/episode_response.dart';
import 'package:rick_and_morty_client/src/repository/episode_repository.dart';

part 'episodes_controller.g.dart';

enum EpisodeStateStatus {
  initial,
  loading,
  loaded,
  error,
}

class EpisodeController = EpisodeControllerBase with _$EpisodeController;

abstract class EpisodeControllerBase with Store {
  final EpisodeRepository _episodeRepository;

  EpisodeControllerBase({
    required EpisodeRepository episodeRepository,
  }) : _episodeRepository = episodeRepository;

  @observable
  ObservableList<EpisodeModel> episodes = ObservableList<EpisodeModel>();

  @observable
  String? errorMessage;

  @observable
  EpisodeStateStatus episodeStateStatus = EpisodeStateStatus.initial;

  @observable
  int currentPage = 1;

  @observable
  String? next;

  @action
  Future<void> fetchEpisodes({int page = 1}) async {
    if (next == null && page > 1) return;

    episodeStateStatus = EpisodeStateStatus.loading;
    final result = await _episodeRepository.getEpisodes(page: page);

    switch (result) {
      case Left(value: RepositoryException(:final message)):
        errorMessage = message;
        episodeStateStatus = EpisodeStateStatus.error;
      case Right(value: EpisodeResponse(:final episodes, :final next)):
        if (page == 1) {
          this.episodes.clear();
        }
        this.episodes.addAll(episodes);
        this.next = next;
        episodeStateStatus = EpisodeStateStatus.loaded;
    }
    currentPage = page;
  }
}
