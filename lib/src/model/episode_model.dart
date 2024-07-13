import 'package:json_annotation/json_annotation.dart';

part 'episode_model.g.dart';

@JsonSerializable()
class EpisodeModel {
  final int id;
  final String name;
  @JsonKey(name: 'air_date')
  final String airDate;
  final String episode;
  final List<String> characters;
  final String url;
  final String created;

  EpisodeModel({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episode,
    required this.characters,
    required this.url,
    required this.created,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) =>
      _$EpisodeModelFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeModelToJson(this);

  List<int> get characterIds =>
      characters.map((url) => int.parse(url.split('/').last)).toList();
}
