import 'package:equatable/equatable.dart';
import '../../../data/models/museum_place_model.dart';
import '../../../data/models/cultural_category_model.dart';
import '../../../data/models/cultural_content_model.dart';

/// Museum States
abstract class MuseumState extends Equatable {
  const MuseumState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class MuseumInitial extends MuseumState {
  const MuseumInitial();
}

/// Loading state
class MuseumLoading extends MuseumState {
  const MuseumLoading();
}

/// State when data is loaded
class MuseumLoaded extends MuseumState {
  final List<MuseumPlaceModel> places;
  final List<CulturalCategoryModel> categories;
  final MuseumPlaceModel? selectedPlace;
  final CulturalCategoryModel? selectedCategory;
  final List<CulturalContentModel> currentContent;
  final bool isContentLoading;
  final String? error;

  final List<MuseumPlaceModel> aiPlaces;
  final bool isAiLoading;
  final String? aiError;

  final bool isGeneratingSentences;
  final String? sentenceError;

  // Backend upload tracking
  final bool isUploadingToBackend;
  final String? backendUploadError;

  // API pagination — places
  final bool isLoadingFromApi;
  final String? apiError;
  final int apiTotalPages;
  final int currentApiPage;

  // API pagination — sentences for selected place
  final bool isLoadingSentencesFromApi;
  final int sentenceApiTotalPages;
  final int currentSentenceApiPage;

  const MuseumLoaded({
    required this.places,
    required this.categories,
    this.selectedPlace,
    this.selectedCategory,
    this.currentContent = const [],
    this.isContentLoading = false,
    this.error,
    this.aiPlaces = const [],
    this.isAiLoading = false,
    this.aiError,
    this.isGeneratingSentences = false,
    this.sentenceError,
    this.isUploadingToBackend = false,
    this.backendUploadError,
    this.isLoadingFromApi = false,
    this.apiError,
    this.apiTotalPages = 1,
    this.currentApiPage = 1,
    this.isLoadingSentencesFromApi = false,
    this.sentenceApiTotalPages = 1,
    this.currentSentenceApiPage = 1,
  });

  MuseumLoaded copyWith({
    List<MuseumPlaceModel>? places,
    List<CulturalCategoryModel>? categories,
    MuseumPlaceModel? selectedPlace,
    CulturalCategoryModel? selectedCategory,
    List<CulturalContentModel>? currentContent,
    bool? isContentLoading,
    String? error,
    List<MuseumPlaceModel>? aiPlaces,
    bool? isAiLoading,
    String? aiError,
    bool? isGeneratingSentences,
    String? sentenceError,
    bool? isUploadingToBackend,
    String? backendUploadError,
    bool? isLoadingFromApi,
    String? apiError,
    int? apiTotalPages,
    int? currentApiPage,
    bool? isLoadingSentencesFromApi,
    int? sentenceApiTotalPages,
    int? currentSentenceApiPage,
  }) {
    return MuseumLoaded(
      places: places ?? this.places,
      categories: categories ?? this.categories,
      selectedPlace: selectedPlace ?? this.selectedPlace,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      currentContent: currentContent ?? this.currentContent,
      isContentLoading: isContentLoading ?? this.isContentLoading,
      error: error ?? this.error,
      aiPlaces: aiPlaces ?? this.aiPlaces,
      isAiLoading: isAiLoading ?? this.isAiLoading,
      aiError: aiError ?? this.aiError,
      isGeneratingSentences:
          isGeneratingSentences ?? this.isGeneratingSentences,
      sentenceError: sentenceError ?? this.sentenceError,
      isUploadingToBackend: isUploadingToBackend ?? this.isUploadingToBackend,
      backendUploadError: backendUploadError ?? this.backendUploadError,
      isLoadingFromApi: isLoadingFromApi ?? this.isLoadingFromApi,
      apiError: apiError ?? this.apiError,
      apiTotalPages: apiTotalPages ?? this.apiTotalPages,
      currentApiPage: currentApiPage ?? this.currentApiPage,
      isLoadingSentencesFromApi:
          isLoadingSentencesFromApi ?? this.isLoadingSentencesFromApi,
      sentenceApiTotalPages:
          sentenceApiTotalPages ?? this.sentenceApiTotalPages,
      currentSentenceApiPage:
          currentSentenceApiPage ?? this.currentSentenceApiPage,
    );
  }

  @override
  List<Object?> get props => [
    places,
    categories,
    selectedPlace,
    selectedCategory,
    currentContent,
    isContentLoading,
    error,
    aiPlaces,
    isAiLoading,
    aiError,
    isGeneratingSentences,
    sentenceError,
    isUploadingToBackend,
    backendUploadError,
    isLoadingFromApi,
    apiError,
    apiTotalPages,
    currentApiPage,
    isLoadingSentencesFromApi,
    sentenceApiTotalPages,
    currentSentenceApiPage,
  ];
}

/// Error state
class MuseumError extends MuseumState {
  final String message;

  const MuseumError(this.message);

  @override
  List<Object?> get props => [message];
}
