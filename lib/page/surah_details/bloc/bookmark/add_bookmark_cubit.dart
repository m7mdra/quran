import 'package:bloc/bloc.dart';
import 'package:quran/data/local/bookmark_repository.dart';
import 'package:quran/data/model/bookmark.dart';
import 'add_bookmark_state.dart';


class BookmarkCubit extends Cubit<AddBookmarkState> {
  final BookmarkRepository _repository;

  BookmarkCubit(this._repository) : super(AddBookmarkInitial());

  Future<void> saveBookMark(String name, int surah) async {
    try {
      emit(AddBookmarkSavedLoading());
      var result =
          await _repository.addBookmark(Bookmark(name: name, surah: surah));
      await Future.delayed(Duration(seconds: 1));

      emit(AddBookmarkSavedSuccess());
    } catch (error) {
      emit(AddBookmarkSavedFailed());
    }
  }
}
