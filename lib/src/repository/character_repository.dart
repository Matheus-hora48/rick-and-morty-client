import 'package:rick_and_morty_client/src/core/exceptions/repository_exception.dart';
import 'package:rick_and_morty_client/src/core/fp/either.dart';
import 'package:rick_and_morty_client/src/model/character_model.dart';

abstract interface class CharacterRepository {
  Future<Either<RepositoryException, List<CharacterModel>>> getCharacters({
    required int page,
  });
  Future<Either<RepositoryException, CharacterModel>> getCharacter({
    required int id,
  });
}
