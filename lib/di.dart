import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:get_it/get_it.dart';
import 'package:quran/data/local/husn_proivder.dart';
import 'package:quran/data/local/preference.dart';
import 'package:quran/data/local/readers_provider.dart';
import 'package:quran/data/local/tafseer_database_client.dart';
import 'package:quran/data/local/zerk_provider.dart';
import 'package:quran/data/network/quran_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/local/husn_chapter_provider.dart';
import 'data/local/tafseer_repository.dart';

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
    SharedPreferences sharePreference = await SharedPreferences.getInstance();
    var readersProvider = ReadersProvider();
    _registrar.registerSingleton(client);
    _registrar.registerSingleton(QuranApi(client));
    _registrar.registerSingleton<TafseerRepository>(TafseerDataBaseClient());
    _registrar.registerSingleton<ReadersProvider>(readersProvider);
    _registrar.registerSingleton<ZekrProvider>(ZekrProvider());
    _registrar.registerSingleton<HusnProvider>(HusnProvider());
    _registrar.registerSingleton<HusnChapterProvider>(HusnChapterProvider());
    _registrar.registerSingleton<Preference>(
        Preference(sharePreference, readersProvider));

    _registrar
        .registerSingleton<TafseerDataBaseClient>(TafseerDataBaseClient());
  }

  static T provide<T>() {
    return _registrar.get<T>();
  }
}
