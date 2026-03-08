import 'package:arabic/features/food/data/models/food_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/food_repository.dart';
import 'food_state.dart';

class FoodCubit extends Cubit<FoodState> {
  final FoodRepository _repository;

  FoodCubit(this._repository) : super(const FoodState());
  List<FoodModel> foodItems = [];
  Future<void> loadFoodData() async {
    emit(state.copyWith(status: FoodStatus.loading));
    final result = await _repository.loadFoodData();
    result.fold(
      (l) => emit(
        state.copyWith(status: FoodStatus.error, errorMessage: l.message),
      ),
      (r) {
        foodItems = r.foodItems;
        emit(state.copyWith(status: FoodStatus.loaded, foodItems: r.foodItems));
      },
    );
  }

  void selectFood(int index) {
    emit(state.copyWith(selectedFoodIndex: index));
  }

  void changeLanguage(String languageCode) {
    emit(state.copyWith(currentLanguageCode: languageCode));
  }

  void toggleViewMode() {
    emit(state.copyWith(isStoryMode: !state.isStoryMode));
  }
}
