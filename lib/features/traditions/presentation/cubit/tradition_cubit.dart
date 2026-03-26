import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import '../../data/repositories/tradition_repository.dart';
import 'tradition_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TraditionCubit extends Cubit<TraditionState> {
  final TraditionRepository _repository;

  TraditionCubit(this._repository) : super(const TraditionState());

  Future<void> loadTraditions([String? languageCode]) async {
    emit(state.copyWith(status: TraditionStatus.loading));

    final result = await _repository.loadTraditions();
    result.fold(
      (f) => emit(
        state.copyWith(
          status: TraditionStatus.error,
          errorMessage: ApiErrorHandler.getUserMessage(f),
        ),
      ),
      (r) => emit(
        state.copyWith(
          status: TraditionStatus.loaded,
          traditions: r.traditions,
          currentLanguageCode: languageCode ?? state.currentLanguageCode,
        ),
      ),
    );
  }

  void selectTradition(int index) {
    if (index >= 0 && index < state.traditions.length) {
      emit(state.copyWith(selectedTraditionIndex: index));
    }
  }

  void toggleViewMode() {
    emit(state.copyWith(isStoryMode: !state.isStoryMode));
  }

  void changeLanguage(String languageCode) {
    emit(state.copyWith(currentLanguageCode: languageCode));
  }
}
