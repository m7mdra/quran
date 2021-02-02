abstract class DownloadDatabaseState {}

class DownloadDatabaseFoundState extends DownloadDatabaseState {
  final String filePath;

  DownloadDatabaseFoundState(this.filePath);
}

class DownloadDatabaseNotFoundState extends DownloadDatabaseState {}


class DownloadDatabaseErrorState extends DownloadDatabaseState {}

class DownloadDatabaseIdleState extends DownloadDatabaseState {}

class DatabaseDownloadingState extends DownloadDatabaseState {}
class ProcessingDatabaseLoadingState extends DownloadDatabaseState{}
class ProcessingDatabaseNotState extends DownloadDatabaseState{}
class ProcessingDatabaseFailedState extends DownloadDatabaseState{}

class DownloadDatabaseSuccessState extends DownloadDatabaseState {
  final String filePath;

  DownloadDatabaseSuccessState(this.filePath);
}
