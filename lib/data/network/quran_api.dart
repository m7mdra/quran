import 'package:dio/dio.dart';

class QuranApi {
  final Dio _client;
  var bookUrl =
      "https://rawcdn.githack.com/m7mdra/quran-project-files/63cb82423aad37b68ccc861ea21d962a5dee6003/رياض-الصالحين-من-كلام-سيد-المرسلين-kutub-pdf.net.pdf";
  var dbUrl =
      "https://rawcdn.githack.com/m7mdra/quran-project-files/5de5b8d4d004ed1d46c0fc12952c03494d0d8b78/quran.db.zip";

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

      var fileResponse = await _client.download('https://www.learningcontainer.com/download/sample-large-zip-file/?wpdmdl=1639&refresh=601853653c3591612206949', path,
          onReceiveProgress: progressCallback, cancelToken: cancelToken);

      return fileResponse.statusCode == 200;
    } catch (error) {
      throw error;
    }
  }
}
