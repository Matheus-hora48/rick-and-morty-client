import 'package:rick_and_morty_client/src/core/exceptions/repository_exception.dart';
import 'package:rick_and_morty_client/src/core/fp/either.dart';
import 'package:rick_and_morty_client/src/model/location_model.dart';

abstract interface class LocationRepository {
  Future<Either<RepositoryException, List<LocationModel>>> getLocations({
    required int page,
  });
  Future<Either<RepositoryException, LocationModel>> getLocation({
    required int id,
  });
}
