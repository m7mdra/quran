part of 'translations_cubit.dart';

@immutable
abstract class TranslationsState {}

class TranslationsInitial extends TranslationsState {}
class TranslationsLoading extends TranslationsState {}
class TranslationsError extends TranslationsState {}
class TranslationsSuccess extends TranslationsState {
  final List<Edition> list;

  TranslationsSuccess(this.list);

}

