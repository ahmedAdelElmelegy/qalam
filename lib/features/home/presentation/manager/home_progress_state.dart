part of 'home_progress_cubit.dart';

sealed class HomeProgressState extends Equatable {
  const HomeProgressState();

  @override
  List<Object?> get props => [];
}

final class HomeProgressInitial extends HomeProgressState {}

final class HomeProgressLoading extends HomeProgressState {}

final class HomeProgressSuccess extends HomeProgressState {
  final ProgressData progress;

  const HomeProgressSuccess(this.progress);

  @override
  List<Object?> get props => [progress];
}

final class HomeProgressFailure extends HomeProgressState {
  final String message;

  const HomeProgressFailure(this.message);

  @override
  List<Object?> get props => [message];
}
