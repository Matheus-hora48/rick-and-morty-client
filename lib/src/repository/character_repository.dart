import 'package:rick_and_morty_client/src/core/exceptions/repository_exception.dart';
import 'package:rick_and_morty_client/src/core/fp/either.dart';
import 'package:rick_and_morty_client/src/model/character_model.dart';
import 'package:rick_and_morty_client/src/model/response/character_response.dart';

abstract interface class CharacterRepository {
  Future<Either<RepositoryException, CharacterResponse>> getCharacters({
    required int page,
  });
  Future<Either<RepositoryException, CharacterModel>> getCharacter({
    required int id,
  });
  Future<Either<RepositoryException, List<CharacterModel>>> getMultipleCharacters({
    required List<int> ids,
  });

}
