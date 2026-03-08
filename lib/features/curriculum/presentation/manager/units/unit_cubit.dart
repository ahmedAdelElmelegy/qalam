import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';
import 'package:arabic/features/curriculum/data/models/currecum/unite_model.dart';
import 'package:arabic/features/curriculum/data/repo/unit_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'unit_state.dart';

class UnitCubit extends Cubit<UnitState> {
  final UnitRepo unitRepo;
  UnitCubit(this.unitRepo) : super(UnitInitial());

  List<UnitModel> unitList = [];
  String? _currentLang;
  int? _currentLevelId;

  Future<void> getUnits({required int levelId, required String lang}) async {
    // If units are already loaded for the current level AND same language, don't reload
    if (unitList.isNotEmpty && _currentLang == lang && _currentLevelId == levelId) {
      emit(UnitSucess(timestamp: DateTime.now().millisecondsSinceEpoch));
      return;
    }

    emit(UnitLoading());
    try {
      final result = await unitRepo.getUnits(levelId);
      result.fold(
        (l) {
          emit(UnitFailed(l));
        },
        (r) {
          unitList = r;
          _currentLang = lang;
          _currentLevelId = levelId;
          emit(UnitSucess(timestamp: DateTime.now().millisecondsSinceEpoch));
        },
      );
    } catch (e) {
      emit(UnitFailed(ApiErrorHandler.handleError(e)));
    }
  }

  void clearCache() {
    unitList = [];
    _currentLang = null;
    _currentLevelId = null;
    emit(UnitInitial());
  }
}
