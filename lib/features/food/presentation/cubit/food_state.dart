import 'package:equatable/equatable.dart';
import '../../data/models/food_model.dart';

enum FoodStatus { initial, loading, loaded, error }

class FoodState extends Equatable {
  final FoodStatus status;
  final List<FoodModel> foodItems;
  final int selectedFoodIndex;
  final String currentLanguageCode;
  final bool isStoryMode;
  final String? errorMessage;

  const FoodState({
    this.status = FoodStatus.initial,
    this.foodItems = const [],
    this.selectedFoodIndex = 0,
    this.currentLanguageCode = 'en',
    this.isStoryMode = false,
    this.errorMessage,
  });

  FoodModel? get currentFood =>
      foodItems.isNotEmpty ? foodItems[selectedFoodIndex] : null;

  FoodState copyWith({
    FoodStatus? status,
    List<FoodModel>? foodItems,
    int? selectedFoodIndex,
    String? currentLanguageCode,
    bool? isStoryMode,
    String? errorMessage,
  }) {
    return FoodState(
      status: status ?? this.status,
      foodItems: foodItems ?? this.foodItems,
      selectedFoodIndex: selectedFoodIndex ?? this.selectedFoodIndex,
      currentLanguageCode: currentLanguageCode ?? this.currentLanguageCode,
      isStoryMode: isStoryMode ?? this.isStoryMode,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    foodItems,
    selectedFoodIndex,
    currentLanguageCode,
    isStoryMode,
    errorMessage,
  ];
}
