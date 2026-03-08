import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import '../../data/repositories/city_repository.dart';
import 'city_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CityCubit extends Cubit<CityState> {
  final CityRepository _repository;

  CityCubit(this._repository) : super(const CityState());

  Future<void> loadCities() async {
    emit(state.copyWith(status: CityStatus.loading));

    final result = await _repository.loadCities();

    result.fold(
      (f) => emit(
        state.copyWith(
          status: CityStatus.error,
          errorMessage: ApiErrorHandler.getUserMessage(f),
        ),
      ),
      (r) => emit(state.copyWith(status: CityStatus.loaded, cities: r.cities)),
    );
  }

  void selectCity(int index) {
    if (index >= 0 && index < state.cities.length) {
      emit(state.copyWith(selectedCityIndex: index));
    }
  }

  void toggleViewMode() {
    emit(state.copyWith(isStoryMode: !state.isStoryMode));
  }

  void changeLanguage(String languageCode) {
    emit(state.copyWith(currentLanguageCode: languageCode));
  }
}
