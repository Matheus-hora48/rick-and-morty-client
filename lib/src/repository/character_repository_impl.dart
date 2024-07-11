import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rick_and_morty_client/src/core/env/env.dart';
import 'package:rick_and_morty_client/src/core/exceptions/repository_exception.dart';
import 'package:rick_and_morty_client/src/core/fp/either.dart';
import 'package:rick_and_morty_client/src/core/rest_client/rest_client.dart';
import 'package:rick_and_morty_client/src/model/character_model.dart';
import 'package:rick_and_morty_client/src/repository/character_repository.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final RestClient restClient;

  CharacterRepositoryImpl({required this.restClient});

  @override
  Future<Either<RepositoryException, List<CharacterModel>>> getCharacters({
    required int page,
  }) async {
    try {
      final Response(data: {'result': characterResponse}) = await restClient
          .unAuth
          .get('${Env.backendBaseUrl}/character', queryParameters: {
        'page': page,
      });

      final characterList =
          characterResponse.map((c) => CharacterModel.fromJson(c)).toList();

      return Right(characterList);
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
}
