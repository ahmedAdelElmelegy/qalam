part of 'sync_quiz_cubit.dart';

sealed class SyncQuizState extends Equatable {
  const SyncQuizState();

  @override
  List<Object> get props => [];
}

final class SyncQuizInitial extends SyncQuizState {}

final class SyncQuizLoading extends SyncQuizState {}

final class SyncQuizSuccess extends SyncQuizState {}

final class SyncQuizFailure extends SyncQuizState {
  final AppException message;

  const SyncQuizFailure(this.message);

  @override
  List<Object> get props => [message];
}
