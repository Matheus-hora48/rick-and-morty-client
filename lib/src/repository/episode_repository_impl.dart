import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rick_and_morty_client/src/core/env/env.dart';
import 'package:rick_and_morty_client/src/core/exceptions/repository_exception.dart';
import 'package:rick_and_morty_client/src/core/fp/either.dart';
import 'package:rick_and_morty_client/src/core/rest_client/rest_client.dart';
import 'package:rick_and_morty_client/src/model/episode_model.dart';
import 'package:rick_and_morty_client/src/model/response/episode_response.dart';
import 'package:rick_and_morty_client/src/repository/episode_repository.dart';

class EpisodeRepositoryImpl implements EpisodeRepository {
  final RestClient restClient;

  EpisodeRepositoryImpl({required this.restClient});

  @override
  Future<Either<RepositoryException, EpisodeResponse>> getEpisodes({
    required int page,
  }) async {
    try {
      final response = await restClient.unAuth
          .get('${Env.backendBaseUrl}/episode', queryParameters: {
        'page': page,
      });

      final episodeResponse = response.data['results'] as List;
      final List<EpisodeModel> episodeList =
          episodeResponse.map((c) => EpisodeModel.fromJson(c)).toList();

      final next = response.data['info']['next'];

      return Right(EpisodeResponse(episodes: episodeList, next: next));
    } on DioException catch (e, s) {
      log(
        'Erro ao buscar lista de episódio',
        error: e,
        stackTrace: s,
      );
      return Left(
        RepositoryException(
          message: 'Erro ao buscar lista de episódio',
        ),
      );
    }
  }

  @override
  Future<Either<RepositoryException, EpisodeModel>> getEpisode({
    required int id,
  }) async {
    try {
      final Response(:data) = await restClient.unAuth.get(
        '${Env.backendBaseUrl}/episode/$id',
      );

      return Right(EpisodeModel.fromJson(data));
    } on DioException catch (e, s) {
      log(
        'Erro ao buscar episódio',
        error: e,
        stackTrace: s,
      );
      return Left(
        RepositoryException(
          message: 'Erro ao buscar episódio',
        ),
      );
    }
  }

  @override
  Future<Either<RepositoryException, List<EpisodeModel>>> getMultipleEpisodes(
      {required List<int> ids}) async {
    try {
      final Response(:data) = await restClient.unAuth.get(
        '${Env.backendBaseUrl}/episode/${ids.join(',')}',
      );

      final episodeList =
          (data as List).map((e) => EpisodeModel.fromJson(e)).toList();
      return Right(episodeList);
    } on DioException catch (e, s) {
      log(
        'Erro ao buscar múltiplos episódios',
        error: e,
        stackTrace: s,
      );
      return Left(
        RepositoryException(
          message: 'Erro ao buscar múltiplos episódios',
        ),
      );
    }
  }
}
