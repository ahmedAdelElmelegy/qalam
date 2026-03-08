import 'package:equatable/equatable.dart';
import '../../data/models/city_model.dart';

enum CityStatus { initial, loading, loaded, error }

class CityState extends Equatable {
  final CityStatus status;
  final List<CityModel> cities;
  final int selectedCityIndex;
  final bool isStoryMode;
  final String currentLanguageCode;
  final String? errorMessage;

  const CityState({
    this.status = CityStatus.initial,
    this.cities = const [],
    this.selectedCityIndex = 0,
    this.isStoryMode = false,
    this.currentLanguageCode = 'en',
    this.errorMessage,
  });

  CityState copyWith({
    CityStatus? status,
    List<CityModel>? cities,
    int? selectedCityIndex,
    bool? isStoryMode,
    String? currentLanguageCode,
    String? errorMessage,
  }) {
    return CityState(
      status: status ?? this.status,
      cities: cities ?? this.cities,
      selectedCityIndex: selectedCityIndex ?? this.selectedCityIndex,
      isStoryMode: isStoryMode ?? this.isStoryMode,
      currentLanguageCode: currentLanguageCode ?? this.currentLanguageCode,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  CityModel? get currentCity =>
      cities.isNotEmpty &&
          selectedCityIndex >= 0 &&
          selectedCityIndex < cities.length
      ? cities[selectedCityIndex]
      : null;

  @override
  List<Object?> get props => [
    status,
    cities,
    selectedCityIndex,
    isStoryMode,
    currentLanguageCode,
    errorMessage,
  ];
}
