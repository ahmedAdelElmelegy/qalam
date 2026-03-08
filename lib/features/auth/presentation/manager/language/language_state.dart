part of 'language_cubit.dart';

sealed class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object> get props => [];
}

final class LanguageInitial extends LanguageState {}

final class LanguageLoading extends LanguageState {}

final class LanguageLoaded extends LanguageState {}

final class LanguageError extends LanguageState {
  final AppException exception;
  const LanguageError(this.exception);
}
