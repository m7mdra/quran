import 'package:dio/dio.dart';

class QuranApi {
  final Dio _client;
  var bookUrl =
      "https://rawcdn.githack.com/m7mdra/quran-project-files/63cb82423aad37b68ccc861ea21d962a5dee6003/رياض-الصالحين-من-كلام-سيد-المرسلين-kutub-pdf.net.pdf";

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
}
