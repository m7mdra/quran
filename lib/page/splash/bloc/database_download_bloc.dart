import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:quran/data/local/database_file.dart';
import 'package:quran/data/local/preference.dart';
import 'package:quran/data/network/quran_api.dart';
import 'package:quran/page/riyadh/bloc/riyadh_book_bloc.dart';
import 'package:quran/page/splash/bloc/bloc.dart';

class DownloadDatabaseBloc
    extends Bloc<DownloadDatabaseEvent, DownloadDatabaseState> {
  final DatabaseFile _dbFile;
  final QuranApi _quranApi;
  final ProgressCubit _progressCubit;
  final Preference _preference;
  CancelToken _downloadCancelToken = CancelToken();

  DownloadDatabaseBloc(
      this._dbFile, this._quranApi, this._progressCubit, this._preference)
      : super(DownloadDatabaseIdleState());

  @override
  Stream<DownloadDatabaseState> mapEventToState(
      DownloadDatabaseEvent event) async* {
    if (event is UserCanceledDbDownloadEvent) {
      _downloadCancelToken.cancel();
      await _dbFile.deleteFile();
      yield DownloadDatabaseNotFoundState();
    }
    if (event is CheckDatabaseExistence) {
      await Future.delayed(Duration(seconds: 1));
      if (await _dbFile.doseFileExists() &&
          _preference.didDatabaseDownloadSuccess()) {
        var path = await _dbFile.filePath();
        yield DownloadDatabaseFoundState(path);
      } else {
        yield DownloadDatabaseNotFoundState();
      }
    }
    if (event is StartDownloadDatabaseEvent) {
      try {
        yield DatabaseDownloadingState();
        var path = await _dbFile.filePath();
        var success = await _quranApi.downloadDatabase(path, (count, total) {
          var progress = ((count / total) * 100).round();
          _progressCubit.update(progress);
        }, _downloadCancelToken);

        if (success) {
          print(await File(await _dbFile.filePath()).length());
          await _preference.databaseDownloaded();
          yield DownloadDatabaseSuccessState(path);
        } else {
          yield DownloadDatabaseBookErrorState();
        }
      } catch (error) {
        yield DownloadDatabaseBookErrorState();
      }
    }
  }
}
