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
    print(await _dbFile.databasePath());

    if (event is UserCanceledDbDownloadEvent) {
      _downloadCancelToken.cancel();
      await _dbFile.deleteFiles();
      yield DownloadDatabaseNotFoundState();
    }
    if (event is CheckDatabaseExistence) {
      if (await _dbFile.doseFileExists() &&
          _preference.didDatabaseDownloadSuccess()) {
        if (await _dbFile.isFileExtracted() &&
            _preference.didExtractDatabaseDownloadSuccess()) {
          var path = await _dbFile.databasePath();
          yield DownloadDatabaseFoundState(path);
        } else {
          yield ProcessingDatabaseNotState();
          await _dbFile.deleteExistingIncompleteFileIfFound();
          yield ProcessingDatabaseLoadingState();
          var file = await _dbFile.extractDatabaseFile();
          if (file) {
            await _preference.databaseDownloadExtracted();
            yield DownloadDatabaseSuccessState(await _dbFile.databasePath());
          } else {
            yield ProcessingDatabaseFailedState();
          }
        }
      } else {
        yield DownloadDatabaseNotFoundState();
      }
    }
    if (event is StartDownloadDatabaseEvent) {
      try {
        await _dbFile.deleteFiles();
        yield DatabaseDownloadingState();
        var path = await _dbFile.filePath();
        var success = await _quranApi.downloadDatabase(path, (count, total) {
          var progress = ((count / total) * 100).round();
          _progressCubit.update(progress);
        }, _downloadCancelToken);
        if (success) {
          await _dbFile.deleteExistingIncompleteFileIfFound();
          await _preference.databaseDownloaded();
          yield ProcessingDatabaseLoadingState();
          var fileExtractedSuccessfully = await _dbFile.extractDatabaseFile();
          if (fileExtractedSuccessfully) {
            await _preference.databaseDownloadExtracted();
            yield DownloadDatabaseSuccessState(await _dbFile.databasePath());
          } else {
            yield ProcessingDatabaseFailedState();
          }
        } else {
          yield DownloadDatabaseErrorState();
        }
      } catch (error) {
        print(error);
        yield DownloadDatabaseErrorState();
      }
    }
  }
}
