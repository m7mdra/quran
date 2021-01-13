import 'package:quran/data/model/bookmark.dart';

abstract class BookmarkRepository {
  Future<List<Bookmark>> getBookmarks();

  Future<int> addBookmark(Bookmark bookmark);

  Future<int> deleteBookmark(int id);
}
