import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rick_and_morty_client/src/core/env/env.dart';
import 'package:rick_and_morty_client/src/core/exceptions/repository_exception.dart';
import 'package:rick_and_morty_client/src/core/fp/either.dart';
import 'package:rick_and_morty_client/src/core/rest_client/rest_client.dart';
import 'package:rick_and_morty_client/src/model/location_model.dart';
import 'package:rick_and_morty_client/src/repository/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final RestClient restClient;

  LocationRepositoryImpl({required this.restClient});

  @override
  Future<Either<RepositoryException, List<LocationModel>>> getLocations({
    required int page,
  }) async {
    try {
      final Response(data: {'result': locationResponse}) =
          await restClient.unAuth.get(
        '${Env.backendBaseUrl}/location',
        queryParameters: {
          'page': page,
        },
      );

      final locationList =
          locationResponse.map((c) => LocationModel.fromJson(c)).toList();

      return Right(locationList);
    } on DioException catch (e, s) {
      log(
        'Erro ao buscar lista de localização',
        error: e,
        stackTrace: s,
      );
      return Left(
        RepositoryException(
          message: 'Erro ao buscar lista de localização',
        ),
      );
    }
  }

  @override
  Future<Either<RepositoryException, LocationModel>> getLocation({
    required int id,
  }) async {
    try {
      final Response(:data) = await restClient.unAuth.get(
        '${Env.backendBaseUrl}/location/$id',
      );

      return Right(LocationModel.fromJson(data));
    } on DioException catch (e, s) {
      log(
        'Erro ao buscar localização',
        error: e,
        stackTrace: s,
      );
      return Left(
        RepositoryException(
          message: 'Erro ao buscar localização',
        ),
      );
    }
  }
}
