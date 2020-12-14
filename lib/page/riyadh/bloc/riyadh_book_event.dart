abstract class RiyadhBookEvent {}

class CheckBookExistence extends RiyadhBookEvent {}

class DownloadBookEvent extends RiyadhBookEvent {}

class UserCanceledDownloadEvent extends RiyadhBookEvent {}
