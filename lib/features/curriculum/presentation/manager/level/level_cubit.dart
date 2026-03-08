import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';
import 'package:arabic/features/curriculum/data/models/currecum/level_model.dart';
import 'package:arabic/features/curriculum/data/repo/level_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'level_state.dart';

class LevelCubit extends Cubit<LevelState> {
  LevelCubit(this.levelRepo) : super(LevelInitial());
  LevelRepo levelRepo;
  List<LevelModel> levelList = [];
  String? _currentLang;

  Future<void> getLevels(String lang) async {
    // If levels are already loaded for the current language, don't reload unless empty
    if (levelList.isNotEmpty && _currentLang == lang) {
      emit(LevelSucess());
      return;
    }

    emit(LevelLoading());
    try {
      final result = await levelRepo.getLevels();
      result.fold(
        (l) {
          emit(LevelFailed(l));
        },
        (r) {
          levelList = r;
          _currentLang = lang;
          emit(LevelSucess());
        },
      );
    } catch (e) {
      emit(LevelFailed(ApiErrorHandler.handleError(e)));
    }
  }

  void clearCache() {
    levelList = [];
    _currentLang = null;
    emit(LevelInitial());
  }
}
