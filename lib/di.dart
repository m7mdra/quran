import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:quran/data/local/bookmark_repository.dart';
import 'package:quran/data/local/database_file.dart';
import 'package:quran/data/local/husn_proivder.dart';
import 'package:quran/data/local/note_repository.dart';
import 'package:quran/data/local/preference.dart';
import 'package:quran/data/local/readers_provider.dart';
import 'package:quran/data/local/riyadh_file.dart';
import 'package:quran/data/local/zerk_provider.dart';
import 'package:quran/data/network/quran_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/local/dua_mathor_provider.dart';
import 'data/local/husn_chapter_provider.dart';
import 'data/local/quran_database.dart';
import 'data/local/quran_meta_database.dart';

var _registrar = GetIt.instance;

class DependencyProvider {
  DependencyProvider._();

  static Future<void> build() async {
    var options = BaseOptions(
        baseUrl: "http://api.quran.cloud/v1/",
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        connectTimeout: 30000);

    var client = Dio(options);

    client.interceptors
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
    var quranDb = QuranMetaDatabase();
    _registrar.registerSingleton(client);
    _registrar.registerSingleton(QuranApi(client));
    _registrar.registerSingleton(RiyadhFile());
    var databaseFile = DatabaseFile();
    _registrar.registerSingleton(databaseFile);
    _registrar.registerSingleton(quranDb);
    var quranDatabase = QuranDatabase(databaseFile);
    quranDatabase.translationEditions().then((value){
      value.forEach((element) {
        print(element.toMap());
      });
    });
    _registrar.registerSingleton(quranDatabase);
    _registrar.registerSingleton<NoteRepository>(quranDb);
    _registrar.registerSingleton<BookmarkRepository>(quranDb);
    _registrar.registerSingletonAsync(() => SharedPreferences.getInstance());
    _registrar.registerSingleton<ReadersProvider>(readersProvider);
    _registrar.registerSingleton<ZekrProvider>(ZekrProvider());
    _registrar.registerSingleton<DuaMathorProvider>(DuaMathorProvider());
    _registrar.registerSingleton<HusnProvider>(HusnProvider());
    _registrar.registerSingleton<HusnChapterProvider>(HusnChapterProvider());
    _registrar.registerSingleton<Preference>(
        Preference(sharePreference, readersProvider));
  }

  static T provide<T>() {
    return _registrar.get<T>();
  }
}
