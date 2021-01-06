import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quran/data/local/bookmark_repository.dart';
import 'package:quran/data/model/bookmark.dart';

part 'bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  final BookmarkRepository _repository;

  BookmarkCubit(this._repository) : super(BookmarkSavedLoading());

  Future<void> saveBookMark(String name, int surah) async {
    try {
      emit(BookmarkSavedLoading());
      var result =
          await _repository.addBookmark(Bookmark(name: name, surah: surah));
      await Future.delayed(Duration(seconds: 1));

      emit(BookmarkSavedSuccess());
    } catch (error) {
      emit(BookmarkSavedFailed());
    }
  }
}
