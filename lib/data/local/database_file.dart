import 'dart:io';

import 'package:flutter_archive/flutter_archive.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class DatabaseFile {
  Future<bool> doseFileExists() async {
    var path = await filePath();
    return File(path).exists();
  }

  Future<String> databasePath() async {
    var databasesPath = await getDatabasesPath();
    return path.join(databasesPath, "quran.db");
  }

  Future<bool> isFileExtracted() async {
    var path = await databasePath();
    return File(path).exists();
  }

  Future<void> deleteExistingIncompleteFileIfFound() async {
    var file = File(await databasePath());
    if (file.existsSync()) file.deleteSync();
  }

  Future<bool> extractDatabaseFile( ) async {
    var path = await filePath();
    var databasesPath = await getDatabasesPath();
    var databaseFile = File(path);

    await ZipFile.extractToDirectory(
        zipFile: databaseFile, destinationDir: Directory(databasesPath));
    return isFileExtracted();
  }

  Future<String> filePath() async {
    var directory = await getDatabasesPath();
    return path.join(directory, "quran.zip");
  }

  Future<void> deleteFiles() async {
    var file = File(await filePath());
    var extractedFile = File(await databasePath());
    if (file.existsSync()) await file.delete();
    if (extractedFile.existsSync()) await extractedFile.delete();
  }
}
