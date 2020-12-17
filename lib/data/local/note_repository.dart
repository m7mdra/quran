import 'dart:async';

import 'package:quran/data/model/note.dart';

abstract class NoteRepository {
  Future<List<Note>> getAll();

  Future<int> add(Note note);

  Future<int> delete(int id);
}