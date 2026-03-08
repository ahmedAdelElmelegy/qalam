import 'package:arabic/features/speaking_game/data/services/speaking_challenge_prefs_service.dart';
import 'package:arabic/features/speaking_game/presentation/manager/speaking_challenge_levels_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpeakingChallengeLevelsCubit extends Cubit<SpeakingChallengeLevelsState> {
  final SpeakingChallengePrefsService _prefsService;

  SpeakingChallengeLevelsCubit(this._prefsService) : super(SpeakingChallengeLevelsInitial());

  void loadLevels() {
    List<bool> unlockedDays = [];
    List<bool> completedDays = [];

    // Up to day 50
    for (int i = 1; i <= 50; i++) {
      unlockedDays.add(_prefsService.isDayUnlocked(i));
      completedDays.add(_prefsService.isDayCompleted(i));
    }

    emit(SpeakingChallengeLevelsLoaded(
      unlockedDays: unlockedDays,
      completedDays: completedDays,
    ));
  }
}
