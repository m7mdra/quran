import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quran/data/local/bookmark_repository.dart';
import 'package:quran/data/model/bookmark.dart';

part 'get_bookmarks_state.dart';

class GetBookmarkCubit extends Cubit<BookmarkState> {
  final BookmarkRepository _repository;

  GetBookmarkCubit(this._repository) : super(GetBookmarksInitial());

  void loadBookmarks() async {
    try {
      emit(GetBookmarksLoading());
      var bookmarks = await _repository.getBookmarks();
      if (bookmarks.isNotEmpty) {
        bookmarks.sort((first,second)=>second.dateTime.compareTo(first.dateTime));
        emit(GetBookmarksSuccess(bookmarks));
      } else {
        emit(GetBookmarksEmpty());
      }
    } catch (error) {
      emit(GetBookmarksError());
    }
  }
}
