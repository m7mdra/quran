abstract class RiyadhBookState {}

class RiyadhBookFoundState extends RiyadhBookState {
  final String filePath;

  RiyadhBookFoundState(this.filePath);
}

class RiyadhBookNotFoundState extends RiyadhBookState {}

class RiyadhBookErrorState extends RiyadhBookState {}

class RiyadhBookIdleState extends RiyadhBookState {}

class RiyadhBookDownloadingState extends RiyadhBookState {}

class RiyadhBookSuccessState extends RiyadhBookState {
  final String filePath;

  RiyadhBookSuccessState(this.filePath);
}
