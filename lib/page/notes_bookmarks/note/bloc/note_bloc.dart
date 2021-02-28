import 'package:bloc/bloc.dart';
import 'package:quran/data/local/note_repository.dart';

import 'note_event.dart';
import 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository _repository;

  NoteBloc(this._repository) : super(NoteLoadingState());

  @override
  Stream<NoteState> mapEventToState(NoteEvent event) async* {
    if (event is LoadNotes) {
      try {
        yield NoteLoadingState();
        var notes = await _repository.getAll();
        if (notes.isNotEmpty) {
          yield NoteLoadedState(notes
            ..sort((first, second) {
              return second.dateTime.compareTo(first.dateTime);
            }));
        } else {
          yield NoteEmptyState();
        }
      } catch (error) {
        yield NoteErrorState();
      }
    }
    if (event is AddNewNote) {
      try {
        // ignore: unused_local_variable
        var notes = await _repository.add(event.note);
        add(LoadNotes());
      } catch (error) {
        print(error);
        yield NoteErrorState();
      }
    }
  }
}
