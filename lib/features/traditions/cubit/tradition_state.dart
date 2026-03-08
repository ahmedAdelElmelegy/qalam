import 'package:equatable/equatable.dart';
import '../data/models/tradition_model.dart';

enum TraditionStatus { initial, loading, loaded, error }

class TraditionState extends Equatable {
  final TraditionStatus status;
  final List<TraditionModel> traditions;
  final int selectedTraditionIndex;
  final bool isStoryMode;
  final String currentLanguageCode;
  final String? errorMessage;

  const TraditionState({
    this.status = TraditionStatus.initial,
    this.traditions = const [],
    this.selectedTraditionIndex = 0,
    this.isStoryMode = false,
    this.currentLanguageCode = 'en',
    this.errorMessage,
  });

  TraditionState copyWith({
    TraditionStatus? status,
    List<TraditionModel>? traditions,
    int? selectedTraditionIndex,
    bool? isStoryMode,
    String? currentLanguageCode,
    String? errorMessage,
  }) {
    return TraditionState(
      status: status ?? this.status,
      traditions: traditions ?? this.traditions,
      selectedTraditionIndex: selectedTraditionIndex ?? this.selectedTraditionIndex,
      isStoryMode: isStoryMode ?? this.isStoryMode,
      currentLanguageCode: currentLanguageCode ?? this.currentLanguageCode,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  TraditionModel? get currentTradition =>
      traditions.isNotEmpty &&
              selectedTraditionIndex >= 0 &&
              selectedTraditionIndex < traditions.length
          ? traditions[selectedTraditionIndex]
          : null;

  @override
  List<Object?> get props => [
        status,
        traditions,
        selectedTraditionIndex,
        isStoryMode,
        currentLanguageCode,
        errorMessage,
      ];
}
