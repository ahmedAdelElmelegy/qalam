import 'package:equatable/equatable.dart';

abstract class SpeakingChallengeLevelsState extends Equatable {
  const SpeakingChallengeLevelsState();

  @override
  List<Object?> get props => [];
}

class SpeakingChallengeLevelsInitial extends SpeakingChallengeLevelsState {}

class SpeakingChallengeLevelsLoaded extends SpeakingChallengeLevelsState {
  final List<bool> unlockedDays;
  final List<bool> completedDays;

  const SpeakingChallengeLevelsLoaded({
    required this.unlockedDays,
    required this.completedDays,
  });

  @override
  List<Object?> get props => [unlockedDays, completedDays];
}
