import 'package:equatable/equatable.dart';
import '../../data/models/clothing_model.dart';

enum ClothingStatus { initial, loading, loaded, error }

class ClothingState extends Equatable {
  final ClothingStatus status;
  final List<ClothingModel> clothingItems;
  final int selectedClothingIndex;
  final String currentLanguageCode;
  final String? errorMessage;
  final bool isStoryMode;

  const ClothingState({
    this.status = ClothingStatus.initial,
    this.clothingItems = const [],
    this.selectedClothingIndex = 0,
    this.currentLanguageCode = 'en',
    this.errorMessage,
    this.isStoryMode = false,
  });

  ClothingState copyWith({
    ClothingStatus? status,
    List<ClothingModel>? clothingItems,
    int? selectedClothingIndex,
    String? currentLanguageCode,
    String? errorMessage,
    bool? isStoryMode,
  }) {
    return ClothingState(
      status: status ?? this.status,
      clothingItems: clothingItems ?? this.clothingItems,
      selectedClothingIndex:
          selectedClothingIndex ?? this.selectedClothingIndex,
      currentLanguageCode: currentLanguageCode ?? this.currentLanguageCode,
      errorMessage: errorMessage ?? this.errorMessage,
      isStoryMode: isStoryMode ?? this.isStoryMode,
    );
  }

  ClothingModel? get selectedClothing =>
      clothingItems.isNotEmpty ? clothingItems[selectedClothingIndex] : null;

  @override
  List<Object?> get props => [
    status,
    clothingItems,
    selectedClothingIndex,
    currentLanguageCode,
    errorMessage,
    isStoryMode,
  ];
}
