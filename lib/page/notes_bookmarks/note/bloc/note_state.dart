import 'package:quran/data/model/note.dart';

class NoteState {}

class NoteLoadingState extends NoteState {}

class NoteLoadedState extends NoteState {
  final List<Note> list;

  NoteLoadedState(this.list);
}

class NoteErrorState extends NoteState {}

class NoteEmptyState extends NoteState {}
