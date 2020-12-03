import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:get_it/get_it.dart';

var _registrar = GetIt.instance;

class DependencyProvider {
  DependencyProvider._();

  static build() async {
    var options = BaseOptions(
        baseUrl: "http://api.alquran.cloud/v1/",
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        connectTimeout: 30000);

    var client = Dio(options);

    client.interceptors
      ..add(DioCacheManager(CacheConfig(
              baseUrl: 'http://api.alquran.cloud/v1/',
              defaultMaxAge: Duration(days: 356),
              defaultMaxStale: Duration(days: 356)))
          .interceptor)
      ..add(LogInterceptor(
        error: true,
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
      ));
  }

  static T provide<T>() {
    return _registrar.get<T>();
  }
}
