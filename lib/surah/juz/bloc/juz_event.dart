abstract class JuzEvent {}

class LoadJuzByIndex extends JuzEvent {
  final int index;

  LoadJuzByIndex(this.index);
}

