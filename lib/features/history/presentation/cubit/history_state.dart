import 'package:arabic/features/history/data/models/history_period_model.dart';
import 'package:equatable/equatable.dart';

enum HistoryStatus { initial, loading, loaded, error }

class HistoryState extends Equatable {
  final HistoryStatus status;
  final List<HistoryPeriodModel> periods;
  final int selectedPeriodIndex;
  final bool isStoryMode;
  final String currentLanguageCode;
  final String? errorMessage;

  const HistoryState({
    this.status = HistoryStatus.initial,
    this.periods = const [],
    this.selectedPeriodIndex = 0,
    this.isStoryMode = false,
    this.currentLanguageCode = 'ar',
    this.errorMessage,
  });

  HistoryState copyWith({
    HistoryStatus? status,
    List<HistoryPeriodModel>? periods,
    int? selectedPeriodIndex,
    bool? isStoryMode,
    String? currentLanguageCode,
    String? errorMessage,
  }) {
    return HistoryState(
      status: status ?? this.status,
      periods: periods ?? this.periods,
      selectedPeriodIndex: selectedPeriodIndex ?? this.selectedPeriodIndex,
      isStoryMode: isStoryMode ?? this.isStoryMode,
      currentLanguageCode: currentLanguageCode ?? this.currentLanguageCode,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  HistoryPeriodModel? get currentPeriod =>
      periods.isNotEmpty &&
          selectedPeriodIndex >= 0 &&
          selectedPeriodIndex < periods.length
      ? periods[selectedPeriodIndex]
      : null;

  @override
  List<Object?> get props => [
    status,
    periods,
    selectedPeriodIndex,
    isStoryMode,
    currentLanguageCode,
    errorMessage,
  ];
}
