import 'package:rick_and_morty_client/src/model/character_model.dart';

class CharacterResponse {
  final List<CharacterModel> character;
  final String? next;

  CharacterResponse({
    required this.character,
    required this.next,
  });
}
