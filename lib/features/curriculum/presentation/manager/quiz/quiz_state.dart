part of 'quiz_cubit.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizSucess extends QuizState {
  final LessonQuizModel quiz;
  const QuizSucess(this.quiz);

  @override
  List<Object?> get props => [quiz];
}

class QuizFailed extends QuizState {
  final AppException exception;
  const QuizFailed(this.exception);

  @override
  List<Object?> get props => [exception];
}
