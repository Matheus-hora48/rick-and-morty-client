import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rick_and_morty_client/src/core/env/env.dart';
import 'package:rick_and_morty_client/src/core/exceptions/repository_exception.dart';
import 'package:rick_and_morty_client/src/core/fp/either.dart';
import 'package:rick_and_morty_client/src/core/rest_client/rest_client.dart';
import 'package:rick_and_morty_client/src/model/character_model.dart';
import 'package:rick_and_morty_client/src/model/response/character_response.dart';
import 'package:rick_and_morty_client/src/repository/character_repository.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final RestClient restClient;

  CharacterRepositoryImpl({required this.restClient});

  @override
  Future<Either<RepositoryException, CharacterResponse>> getCharacters({
    required int page,
  }) async {
    try {
      final response = await restClient.unAuth
          .get('${Env.backendBaseUrl}/character', queryParameters: {
        'page': page,
      });

      final characterResponse = response.data['results'] as List;
      final List<CharacterModel> characterList =
          characterResponse.map((c) => CharacterModel.fromJson(c)).toList();

      final next = response.data['info']['next'];
      return Right(CharacterResponse(character: characterList, next: next));
    } on DioException catch (e, s) {
      log(
        'Erro ao buscar lista de personagens',
        error: e,
        stackTrace: s,
      );
      return Left(
        RepositoryException(
          message: 'Erro ao buscar lista de personagens',
        ),
      );
    }
  }

  @override
  Future<Either<RepositoryException, CharacterModel>> getCharacter({
    required int id,
  }) async {
    try {
      final Response(:data) = await restClient.unAuth.get(
        '${Env.backendBaseUrl}/character/$id',
      );

      return Right(CharacterModel.fromJson(data));
    } on DioException catch (e, s) {
      log(
        'Erro ao buscar personagem',
        error: e,
        stackTrace: s,
      );
      return Left(
        RepositoryException(
          message: 'Erro ao buscar personagem',
        ),
      );
    }
  }

  @override
  Future<Either<RepositoryException, List<CharacterModel>>>
      getMultipleCharacters({
    required List<int> ids,
  }) async {
    try {
      final Response(:data) = await restClient.unAuth.get(
        '${Env.backendBaseUrl}/character/${ids.join(',')}',
      );

      final characterList =
          (data as List).map((c) => CharacterModel.fromJson(c)).toList();
      return Right(characterList);
    } on DioException catch (e, s) {
      log(
        'Erro ao buscar múltiplos personagens',
        error: e,
        stackTrace: s,
      );
      return Left(
        RepositoryException(
          message: 'Erro ao buscar múltiplos personagens',
        ),
      );
    }
  }
}
