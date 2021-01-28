import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathProvider;

class DatabaseFile {
  Future<bool> doseFileExists() async {
    var path = await filePath();
    return File(path).exists();
  }


  Future<String> filePath() async {
    var directory = await pathProvider.getApplicationSupportDirectory();
    return path.join(directory.path, "quran.db");
  }

  Future<void> deleteFile() async {
    var file = File(await filePath());
    if (file.existsSync()) file.deleteSync();
  }
}
