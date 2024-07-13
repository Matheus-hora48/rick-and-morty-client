import 'package:rick_and_morty_client/src/model/episode_model.dart';

class EpisodeResponse {
  final List<EpisodeModel> episodes;
  final String? next;

  EpisodeResponse({
    required this.episodes,
    required this.next,
  });
}
