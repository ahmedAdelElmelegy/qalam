part of 'level_cubit.dart';

sealed class LevelState extends Equatable {
  const LevelState();

  @override
  List<Object> get props => [];
}

final class LevelInitial extends LevelState {}

final class LevelLoading extends LevelState {}

final class LevelSucess extends LevelState {}

final class LevelFailed extends LevelState {
  final AppException exception;
  const LevelFailed(this.exception);
}
