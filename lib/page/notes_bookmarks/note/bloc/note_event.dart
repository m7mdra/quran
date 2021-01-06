import 'package:quran/data/model/note.dart';

class NoteEvent {}

class LoadNotes extends NoteEvent {}

class AddNewNote extends NoteEvent {
  final Note note;

  AddNewNote(this.note);
}