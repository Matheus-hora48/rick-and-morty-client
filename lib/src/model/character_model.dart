import 'package:json_annotation/json_annotation.dart';
import 'package:rick_and_morty_client/src/model/origin_model.dart';

part 'character_model.g.dart';

@JsonSerializable()
class CharacterModel {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final OriginModel origin;
  final OriginModel location;
  final String image;
  final List<String> episode;
  final String url;
  final String created;

  CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episode,
    required this.url,
    required this.created,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) =>
      _$CharacterModelFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterModelToJson(this);

  List<int> get episodeIds =>
      episode.map((url) => int.parse(url.split('/').last)).toList();
}
