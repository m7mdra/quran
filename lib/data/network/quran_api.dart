import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:quran/data/model/juz_response.dart';
import 'package:quran/data/model/surah_response.dart';

class QuranApi {
  final Dio _client;
  var bookUrl =
      "https://rawcdn.githack.com/m7mdra/quran-project-files/63cb82423aad37b68ccc861ea21d962a5dee6003/رياض-الصالحين-من-كلام-سيد-المرسلين-kutub-pdf.net.pdf";

  QuranApi(this._client);

  /// Fetches Surah from api and cache it forever or al teast
  /// return a [SurahResponse] by index starting from 1 to 114
  /// [index] index of the [SurahResponse]
  Future<SurahResponse> surahByIndex(int index) async {
    try {
      var response = await _client.get('surah/$index',
          options: buildCacheOptions(Duration(days: 356), forceRefresh: false));
      return SurahResponse.fromJson(response.data);
    } catch (error) {
      throw error;
    }
  }

  /// return a [JuzResponse] by index starting from 1 to 30
  /// [index] index of the [JuzResponse]
  Future<JuzResponse> juzByIndex(int index) async {
    try {
      var response = await _client.get('juz/$index',
          options: buildCacheOptions(Duration(days: 356), forceRefresh: false));
      return JuzResponse.fromJson(response.data);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> downloadRiyadhBook(
      String path, ProgressCallback progressCallback) async {
    try {
      var fileResponse = await _client.download(bookUrl, path,
          onReceiveProgress: progressCallback);

      return fileResponse.statusCode==200;
    } catch (error) {
      throw error;
    }
  }
}
