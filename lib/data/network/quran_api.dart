import 'package:dio/dio.dart';

class QuranApi {
  final Dio _client;
  var bookUrl =
      "https://github.com/m7mdra/quran-project-files/blob/master/رياض-الصالحين-من-كلام-سيد-المرسلين-kutub-pdf.net.pdf?raw=true";
  var dbUrl =
      "https://github.com/m7mdra/quran-project-files/blob/master/quran.db.zip?raw=true";

  QuranApi(this._client);

  Future<bool> downloadRiyadhBook(
      String path, ProgressCallback progressCallback) async {
    try {
      var fileResponse = await _client.download(bookUrl, path,
          onReceiveProgress: progressCallback);

      return fileResponse.statusCode == 200;
    } catch (error) {
      throw error;
    }
  }

  Future<bool> downloadDatabase(String path, ProgressCallback progressCallback,
      CancelToken cancelToken) async {
    try {
      var fileResponse = await _client.download(dbUrl, path,
          onReceiveProgress: progressCallback, cancelToken: cancelToken);

      return fileResponse.statusCode == 200;
    } catch (error) {
      throw error;
    }
  }
}
