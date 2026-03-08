import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/features/history/data/repositories/history_repository.dart';
import 'package:arabic/features/history/presentation/cubit/history_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final HistoryRepository _repository;

  HistoryCubit(this._repository) : super(const HistoryState());

  Future<void> loadHistory() async {
    emit(state.copyWith(status: HistoryStatus.loading));

    final response = await _repository.loadHistoryData();
    response.fold(
      (l) => emit(
        state.copyWith(
          status: HistoryStatus.error,
          errorMessage: ApiErrorHandler.getUserMessage(l),
        ),
      ),
      (r) {
        emit(state.copyWith(status: HistoryStatus.loaded, periods: r.data));
      },
    );
  }

  void selectPeriod(int index) {
    if (index >= 0 && index < state.periods.length) {
      emit(state.copyWith(selectedPeriodIndex: index));
    }
  }

  void toggleViewMode() {
    emit(state.copyWith(isStoryMode: !state.isStoryMode));
  }

  void changeLanguage(String languageCode) {
    emit(state.copyWith(currentLanguageCode: languageCode));
  }
}
