abstract class DownloadDatabaseEvent {}

class CheckDatabaseExistence extends DownloadDatabaseEvent {}

class StartDownloadDatabaseEvent extends DownloadDatabaseEvent {}

class UserCanceledDbDownloadEvent extends DownloadDatabaseEvent {}
