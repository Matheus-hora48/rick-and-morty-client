import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class RestClient extends DioForNative {
  RestClient(String baseUrl)
      : super(BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 60),
          baseUrl: baseUrl,
        )) {
    interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
    ]);
  }

  RestClient get unAuth {
    options.extra['DIO_AUTH_KEY'] = false;
    options.contentType = 'application/json';
    return this;
  }
}
