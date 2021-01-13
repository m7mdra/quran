part of 'get_bookmarks_cubit.dart';

@immutable
abstract class BookmarkState {}

class GetBookmarksInitial extends BookmarkState {}

class GetBookmarksLoading extends BookmarkState {}

class GetBookmarksEmpty extends BookmarkState {}

class GetBookmarksSuccess extends BookmarkState {
  final List<Bookmark> list;

  GetBookmarksSuccess(this.list);
}

class GetBookmarksError extends BookmarkState {}
