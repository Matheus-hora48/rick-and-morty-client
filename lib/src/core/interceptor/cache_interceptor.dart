import 'package:dio/dio.dart';
import 'package:rick_and_morty_client/src/db/database_cache_helper.dart';

class CacheInterceptor implements InterceptorsWrapper {
  final DatabaseCacheHelper _databaseCacheHelper = DatabaseCacheHelper();
  final int cacheDuration = 3600000; // 1 hora

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final cache = await _databaseCacheHelper.getCache(
      options.uri.toString(),
    );
    if (cache != null &&
        cache['timestamp'] >
            DateTime.now().millisecondsSinceEpoch - cacheDuration) {
      return handler.resolve(Response(
        requestOptions: options,
        data: cache['response'],
        statusCode: 200,
      ));
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    await _databaseCacheHelper.insertCache(
      response.requestOptions.uri.toString(),
      response.data.toString(),
    );

    await _databaseCacheHelper.clearOldCache(cacheDuration);
    handler.next(response);
  }
}
