abstract class JuzEvent {}

class LoadJuzListEvent extends JuzEvent {
  final int index;

  LoadJuzListEvent(this.index);
}

