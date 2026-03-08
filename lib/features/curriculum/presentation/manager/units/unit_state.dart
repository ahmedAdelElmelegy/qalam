part of 'unit_cubit.dart';

sealed class UnitState extends Equatable {
  const UnitState();

  @override
  List<Object> get props => [];
}

final class UnitInitial extends UnitState {}

final class UnitLoading extends UnitState {}

final class UnitSucess extends UnitState {
  final int timestamp;
  const UnitSucess({required this.timestamp});

  @override
  List<Object> get props => [timestamp];
}

final class UnitFailed extends UnitState {
  final AppException exception;
  const UnitFailed(this.exception);

  @override
  List<Object> get props => [exception];
}
