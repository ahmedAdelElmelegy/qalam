part of 'lesson_cubit.dart';

abstract class LessonState extends Equatable {
  const LessonState();

  @override
  List<Object?> get props => [];
}

class LessonInitial extends LessonState {}

class LessonLoading extends LessonState {}

class LessonSucess extends LessonState {
  final int timestamp;
  const LessonSucess({required this.timestamp});

  @override
  List<Object?> get props => [timestamp];
}

class LessonFailed extends LessonState {
  final AppException exception;
  const LessonFailed(this.exception);

  @override
  List<Object?> get props => [exception];
}
