part of 'bookmark_cubit.dart';

@immutable
abstract class BookmarkState {}

class BookmarkInitial extends BookmarkState {}
class BookmarkSavedSuccess extends BookmarkState {}
class BookmarkSavedLoading extends BookmarkState {}
class BookmarkSavedFailed extends BookmarkState {}
