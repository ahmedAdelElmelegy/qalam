import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/features/clothing/data/models/clothing_model.dart';
import 'package:arabic/features/clothing/data/repositories/clothing_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'clothing_state.dart';

class ClothingCubit extends Cubit<ClothingState> {
  final ClothingRepository _repository;

  ClothingCubit(this._repository) : super(const ClothingState());

  List<ClothingModel> clothingItems = [];
  Future<void> loadClothingData() async {
    emit(state.copyWith(status: ClothingStatus.loading));

    final result = await _repository.loadClothing();
    result.fold(
      (l) => emit(
        state.copyWith(
          status: ClothingStatus.error,
          errorMessage: ApiErrorHandler.getUserMessage(l),
        ),
      ),
      (r) {
        clothingItems = r.clothing;
        emit(
          state.copyWith(
            status: ClothingStatus.loaded,
            clothingItems: r.clothing,
          ),
        );
      },
    );
  }

  void selectClothing(int index) {
    emit(state.copyWith(selectedClothingIndex: index));
  }

  void changeLanguage(String languageCode) {
    emit(state.copyWith(currentLanguageCode: languageCode));
  }

  void toggleViewMode() {
    emit(state.copyWith(isStoryMode: !state.isStoryMode));
  }
}
