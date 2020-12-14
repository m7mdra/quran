import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:quran/data/local/preference.dart';
import 'package:quran/data/local/riyadh_file.dart';
import 'package:quran/data/network/quran_api.dart';
import 'package:quran/page/riyadh/bloc/riyadh_book_event.dart';
import 'package:quran/page/riyadh/bloc/riyadh_book_state.dart';

class RiyadhBookBloc extends Bloc<RiyadhBookEvent, RiyadhBookState> {
  final RiyadhFile _riyadhFile;
  final QuranApi _quranApi;
  final ProgressCubit _progressCubit;
  final Preference _preference;

  RiyadhBookBloc(
      this._riyadhFile, this._quranApi, this._progressCubit, this._preference)
      : super(RiyadhBookIdleState());

  @override
  Stream<RiyadhBookState> mapEventToState(RiyadhBookEvent event) async* {
    if (event is UserCanceledDownloadEvent) {
      await _riyadhFile.deleteFile();
    }
    if (event is CheckBookExistence) {
      if (await _riyadhFile.doseFileExists() &&
          !_preference.didFileDownloadSuccess()) {
        var path = await _riyadhFile.filePath();
        yield RiyadhBookFoundState(path);
      } else {
        yield RiyadhBookNotFoundState();
      }
    }
    if (event is DownloadBookEvent) {
      try {
        yield RiyadhBookDownloadingState();
        var path = await _riyadhFile.filePath();
        var success = await _quranApi.downloadRiyadhBook(path, (count, total) {
          var progress = ((count / total) * 100).round();
          _progressCubit.update(progress);
        });

        if (success) {
          print(await File(await _riyadhFile.filePath()).length());
          await _preference.riyadhBookDownloaded();
          yield RiyadhBookSuccessState(path);
        } else {
          yield RiyadhBookErrorState();
        }
      } catch (error) {
        yield RiyadhBookErrorState();
      }
    }
  }
}

class ProgressCubit extends Cubit<int> {
  ProgressCubit(int state) : super(state);

  void update(int progress) {
    emit(progress);
  }
}
