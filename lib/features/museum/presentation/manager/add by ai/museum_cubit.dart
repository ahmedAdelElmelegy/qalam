import 'package:arabic/core/services/groq_places_service.dart';
import 'package:arabic/features/museum/data/models/virtual%20gallery/ai%20generated/model/virtual_gallery_mappers.dart';
import 'package:arabic/features/museum/data/models/virtual%20gallery/ai%20generated/request_body/translation.dart';
import 'package:arabic/features/museum/data/models/virtual%20gallery/ai%20generated/request_body/virual_gallary_ai_request.dart';
import 'package:arabic/features/museum/data/models/virtual%20gallery/ai%20generated/request_body/virual_gallary_ai_sentance_request.dart';
import 'package:arabic/features/museum/data/repo/virtual_gallary_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arabic/features/museum/data/models/museum_place_model.dart';
import 'package:arabic/features/museum/data/models/cultural_category_model.dart';
import 'package:arabic/features/museum/data/data_sources/museum_places_dummy_data.dart';
import 'package:arabic/features/museum/data/data_sources/cultural_content_dummy_data.dart';
import 'package:arabic/features/museum/presentation/manager/add%20by%20ai/museum_state.dart';

/// Museum Cubit
///
/// Loading strategy for the AI Gallery:
///
/// **Places:**
/// 1. [initGallery] → fetches page 1 from backend API
/// 2. [loadMorePlaces] → if more API pages exist, fetches the next page;
///    otherwise falls back to Groq AI generation → persists to backend.
///
/// **Sentences (per place):**
/// 1. [loadSentencesForPlace] → fetches page 1 from backend API for that place
/// 2. [loadMoreSentences] → if more API pages exist, fetches the next page;
///    otherwise falls back to Groq AI generation → persists to backend.
class MuseumCubit extends Cubit<MuseumState> {
  final GroqPlacesService _groqPlacesService;
  final VirtualGallaryRepo? _repo;

  MuseumCubit({GroqPlacesService? groqPlacesService, VirtualGallaryRepo? repo})
    : _groqPlacesService = groqPlacesService ?? GroqPlacesService(),
      _repo = repo,
      super(const MuseumInitial()) {
    loadMuseumData();
  }

  List<MuseumPlaceModel> _places = [];
  List<CulturalCategoryModel> _categories = [];

  // ─────────────────────────────────────────────────────────
  //  Initial data load
  // ─────────────────────────────────────────────────────────

  Future<void> loadMuseumData() async {
    emit(const MuseumLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      _places = MuseumPlacesDummyData.getPlaces();
      _categories = CulturalContentDummyData.getCategories();
      emit(
        MuseumLoaded(
          places: List.from(_places),
          categories: List.from(_categories),
        ),
      );
    } catch (e) {
      emit(MuseumError('Failed to load museum data: ${e.toString()}'));
    }
  }

  // ─────────────────────────────────────────────────────────
  //  Place selection
  // ─────────────────────────────────────────────────────────

  Future<void> selectPlace(MuseumPlaceModel place) async {
    if (state is MuseumLoaded) {
      final currentState = state as MuseumLoaded;
      emit(currentState.copyWith(selectedPlace: place, selectedCategory: null));
    }
  }

  void clearPlaceSelection() {
    if (state is MuseumLoaded) {
      emit((state as MuseumLoaded).copyWith(selectedPlace: null));
    }
  }

  void clearCategorySelection() {
    if (state is MuseumLoaded) {
      emit(
        (state as MuseumLoaded).copyWith(
          selectedCategory: null,
          currentContent: [],
        ),
      );
    }
  }

  // ─────────────────────────────────────────────────────────
  //  Category loading
  // ─────────────────────────────────────────────────────────

  Future<void> selectCategory(CulturalCategoryModel category) async {
    if (state is MuseumLoaded) {
      final currentState = state as MuseumLoaded;
      emit(
        currentState.copyWith(
          selectedCategory: category,
          selectedPlace: null,
          isContentLoading: true,
        ),
      );

      try {
        await Future.delayed(const Duration(milliseconds: 400));
        final content = CulturalContentDummyData.getContentByCategory(
          category.id,
        );
        emit(
          currentState.copyWith(
            selectedCategory: category,
            currentContent: content,
            isContentLoading: false,
          ),
        );
      } catch (e) {
        emit(
          currentState.copyWith(
            error: 'Failed to load content: ${e.toString()}',
            isContentLoading: false,
          ),
        );
      }
    }
  }

  // ─────────────────────────────────────────────────────────
  //  AI Gallery — Places  (API-first, then Groq fallback)
  // ─────────────────────────────────────────────────────────

  /// Initial entry point for the AI Gallery screen.
  /// Loads page 1 from the backend API.
  Future<void> initGallery() async {
    if (state is! MuseumLoaded) return;
    final currentState = state as MuseumLoaded;

    // Don't re-load if we already have data
    if (currentState.aiPlaces.isNotEmpty) return;

    emit(currentState.copyWith(isLoadingFromApi: true, apiError: null));

    await _fetchApiPlacesPage(page: 1, replace: true);
  }

  /// Refreshes the gallery by clearing cached AI places and reloading from API/AI.
  /// Useful when the language changes.
  Future<void> refreshGallery() async {
    if (state is! MuseumLoaded) return;
    final currentState = state as MuseumLoaded;

    emit(
      currentState.copyWith(
        aiPlaces: [], // Clear cached places
        currentApiPage: 0,
        apiTotalPages: 1,
        isLoadingFromApi: true,
        apiError: null,
      ),
    );

    await _fetchApiPlacesPage(page: 1, replace: true);
  }

  /// Called at 70% scroll threshold.
  /// Fetches the next API page if available; otherwise generates via Groq AI.
  Future<void> loadMorePlaces() async {
    if (state is! MuseumLoaded) return;
    final currentState = state as MuseumLoaded;

    // Guard: don't trigger multiple concurrent loads
    if (currentState.isLoadingFromApi || currentState.isAiLoading) return;

    final nextPage = currentState.currentApiPage + 1;

    if (nextPage <= currentState.apiTotalPages) {
      // ── More API pages exist → fetch
      emit(currentState.copyWith(isLoadingFromApi: true, apiError: null));
      await _fetchApiPlacesPage(page: nextPage, replace: false);
    } else {
      // ── API exhausted → generate with Groq AI
      await _generateAiPlaces(currentState);
    }
  }

  Future<void> _fetchApiPlacesPage({
    required int page,
    required bool replace,
  }) async {
    if (state is! MuseumLoaded) return;
    final currentState = state as MuseumLoaded;
    final repo = _repo;
    if (repo == null) {
      emit(currentState.copyWith(isLoadingFromApi: false));
      return;
    }

    try {
      final result = await repo.getVirtualGallaryPlaces();
      result.fold(
        (error) {
          debugPrint('⚠️  API places fetch failed: $error');
          if (state is MuseumLoaded) {
            emit(
              (state as MuseumLoaded).copyWith(
                isLoadingFromApi: false,
                apiError: error.toString(),
              ),
            );
          }
        },
        (response) {
          final mapped = response.data
              .map((p) => p.toMuseumPlaceModel())
              .toList();
          if (state is MuseumLoaded) {
            final s = state as MuseumLoaded;
            emit(
              s.copyWith(
                aiPlaces: replace ? mapped : [...s.aiPlaces, ...mapped],
                isLoadingFromApi: false,
                // The places endpoint returns all results in one flat list.
                // Mark total pages = 1 so further triggers → AI generation.
                apiTotalPages: 1,
                currentApiPage: 1,
              ),
            );
          }
        },
      );
    } catch (e) {
      debugPrint('⚠️  Exception fetching API places: $e');
      if (state is MuseumLoaded) {
        emit(
          (state as MuseumLoaded).copyWith(
            isLoadingFromApi: false,
            apiError: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> _generateAiPlaces(MuseumLoaded currentState) async {
    emit(currentState.copyWith(isAiLoading: true, aiError: null));

    try {
      final Set<String> previousNames = currentState.aiPlaces
          .map((e) => e.localizedNames['en'] ?? e.name)
          .toSet();

      final newPlaces = await _groqPlacesService.generatePlaces(
        previousPlaceNames: previousNames,
        isFirstRequest: false,
      );

      if (state is MuseumLoaded) {
        final s = state as MuseumLoaded;
        emit(
          s.copyWith(
            aiPlaces: [...s.aiPlaces, ...newPlaces],
            isAiLoading: false,
          ),
        );
      }

      for (final place in newPlaces) {
        await _sendPlaceToBackend(place);
      }
    } catch (e) {
      if (state is MuseumLoaded) {
        emit(
          (state as MuseumLoaded).copyWith(
            aiError: 'Failed to generate places: ${e.toString()}',
            isAiLoading: false,
          ),
        );
      }
    }
  }

  /// Legacy method kept for compatibility; delegates to [_generateAiPlaces].
  Future<void> loadAiPlaces({bool isLoadMore = false}) async {
    if (state is! MuseumLoaded) return;
    
    if (!isLoadMore) {
      await _generateAiPlaces(state as MuseumLoaded);
    } else {
      await loadMorePlaces();
    }
  }

  /// Create a specific place by name (user-triggered).
  Future<void> createPlace(String placeName) async {
    if (state is! MuseumLoaded) return;
    final currentState = state as MuseumLoaded;
    if (currentState.isAiLoading) return;

    emit(currentState.copyWith(isAiLoading: true, aiError: null));

    try {
      final newPlace = await _groqPlacesService.generatePlaceByName(placeName);
      if (state is MuseumLoaded) {
        final s = state as MuseumLoaded;
        emit(
          s.copyWith(
            aiPlaces: [newPlace, ...s.aiPlaces],
            selectedPlace: newPlace,
            isAiLoading: false,
          ),
        );
      }
      await _sendPlaceToBackend(newPlace);
    } catch (e) {
      if (state is MuseumLoaded) {
        emit(
          (state as MuseumLoaded).copyWith(
            aiError: 'Failed to create place: ${e.toString()}',
            isAiLoading: false,
          ),
        );
      }
    }
  }

  // ─────────────────────────────────────────────────────────
  //  AI Gallery — Sentences  (API-first, then Groq fallback)
  // ─────────────────────────────────────────────────────────

  /// Called when a place card is opened.
  /// Loads page 1 of sentences from the backend API for that place.
  Future<void> loadSentencesForPlace(String placeId) async {
    if (state is! MuseumLoaded) return;
    final currentState = state as MuseumLoaded;
    if (currentState.isLoadingSentencesFromApi) return;

    emit(
      currentState.copyWith(
        isLoadingSentencesFromApi: true,
        sentenceApiTotalPages: 1,
        currentSentenceApiPage: 1,
      ),
    );

    await _fetchApiSentencesPage(placeId: placeId, page: 1, replace: true);
  }

  /// Called at 70% scroll threshold on the sentence list.
  /// Fetches the next API page if available; otherwise generates via Groq AI.
  Future<void> loadMoreSentences(MuseumPlaceModel place) async {
    if (state is! MuseumLoaded) return;
    final currentState = state as MuseumLoaded;

    if (currentState.isLoadingSentencesFromApi ||
        currentState.isGeneratingSentences) {
      return;
    }

    final nextPage = currentState.currentSentenceApiPage + 1;

    if (nextPage <= currentState.sentenceApiTotalPages) {
      // ── More API pages exist → fetch
      emit(currentState.copyWith(isLoadingSentencesFromApi: true));
      await _fetchApiSentencesPage(
        placeId: place.id,
        page: nextPage,
        replace: false,
      );
    } else {
      // ── API exhausted → generate with Groq AI
      await _generateAiSentences(place);
    }
  }

  Future<void> _fetchApiSentencesPage({
    required String placeId,
    required int page,
    required bool replace,
  }) async {
    if (state is! MuseumLoaded) return;
    final currentState = state as MuseumLoaded;
    final repo = _repo;
    if (repo == null) {
      emit(currentState.copyWith(isLoadingSentencesFromApi: false));
      return;
    }

    try {
      final result = await repo.getVirtualGallarySentances(
        placeCode: placeId,
        pageNumber: page,
      );
      result.fold(
        (error) {
          debugPrint('⚠️  API sentences fetch failed: $error');
          if (state is MuseumLoaded) {
            emit(
              (state as MuseumLoaded).copyWith(
                isLoadingSentencesFromApi: false,
                sentenceError: error.toString(),
              ),
            );
          }
        },
        (response) {
          final mapped = response.data.items
              .map((s) => s.toMuseumObjectModel())
              .toList();

          if (state is MuseumLoaded) {
            final s = state as MuseumLoaded;
            final currentPlace = s.selectedPlace;

            if (currentPlace != null && currentPlace.id == placeId) {
              final updatedObjects = replace
                  ? mapped
                  : [...currentPlace.objects, ...mapped];
              final updatedPlace = currentPlace.copyWith(
                objects: updatedObjects,
              );
              final updatedAiPlaces = s.aiPlaces
                  .map((p) => p.id == placeId ? updatedPlace : p)
                  .toList();

              emit(
                s.copyWith(
                  aiPlaces: updatedAiPlaces,
                  selectedPlace: updatedPlace,
                  isLoadingSentencesFromApi: false,
                  sentenceApiTotalPages: response.data.totalPages,
                  currentSentenceApiPage: response.data.pageNumber,
                ),
              );
            } else {
              emit(s.copyWith(isLoadingSentencesFromApi: false));
            }
          }
        },
      );
    } catch (e) {
      debugPrint('⚠️  Exception fetching API sentences: $e');
      if (state is MuseumLoaded) {
        emit(
          (state as MuseumLoaded).copyWith(
            isLoadingSentencesFromApi: false,
            sentenceError: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> _generateAiSentences(MuseumPlaceModel place) async {
    if (state is! MuseumLoaded) return;
    final currentState = state as MuseumLoaded;
    emit(
      currentState.copyWith(isGeneratingSentences: true, sentenceError: null),
    );

    try {
      final currentSentences = place.objects
          .map((e) => e.localizedNames['en'] ?? '')
          .toList();

      final newSentences = await _groqPlacesService.generateSentences(
        placeName: place.name,
        category: place.category,
        existingSentences: currentSentences,
        count: 3,
      );

      final updatedObjects = [...place.objects, ...newSentences];
      final updatedPlace = place.copyWith(objects: updatedObjects);

      if (state is MuseumLoaded) {
        final s = state as MuseumLoaded;
        final updatedAiPlaces = s.aiPlaces
            .map((p) => p.id == place.id ? updatedPlace : p)
            .toList();
        emit(
          s.copyWith(
            aiPlaces: updatedAiPlaces,
            selectedPlace: updatedPlace,
            isGeneratingSentences: false,
          ),
        );
      }

      for (final sentence in newSentences) {
        await _sendSentenceToBackend(
          sentence.id,
          sentence.imageUrl,
          place.id,
          sentence.localizedNames,
        );
      }
    } catch (e) {
      if (state is MuseumLoaded) {
        emit(
          (state as MuseumLoaded).copyWith(
            sentenceError: 'Failed to generate sentences: ${e.toString()}',
            isGeneratingSentences: false,
          ),
        );
      }
    }
  }

  /// Create a specific sentence from a user prompt and save to the backend.
  Future<void> createSentenceForPlace(
    MuseumPlaceModel place,
    String sentencePrompt,
  ) async {
    if (state is! MuseumLoaded) return;
    final currentState = state as MuseumLoaded;
    if (currentState.isGeneratingSentences) return;

    emit(
      currentState.copyWith(isGeneratingSentences: true, sentenceError: null),
    );

    try {
      final newSentence = await _groqPlacesService.generateSpecificSentence(
        placeName: place.name,
        promptSentence: sentencePrompt,
      );

      final updatedObjects = [...place.objects, newSentence];
      final updatedPlace = place.copyWith(objects: updatedObjects);

      if (state is MuseumLoaded) {
        final s = state as MuseumLoaded;
        final updatedAiPlaces = s.aiPlaces
            .map((p) => p.id == place.id ? updatedPlace : p)
            .toList();
        emit(
          s.copyWith(
            aiPlaces: updatedAiPlaces,
            selectedPlace: updatedPlace,
            isGeneratingSentences: false,
          ),
        );
      }

      await _sendSentenceToBackend(
        newSentence.id,
        newSentence.imageUrl,
        place.id,
        newSentence.localizedNames,
      );
    } catch (e) {
      if (state is MuseumLoaded) {
        emit(
          (state as MuseumLoaded).copyWith(
            sentenceError: 'Failed to create sentence: ${e.toString()}',
            isGeneratingSentences: false,
          ),
        );
      }
    }
  }

  // ─────────────────────────────────────────────────────────
  //  Private helpers — backend persistence
  // ─────────────────────────────────────────────────────────

  Future<void> _sendPlaceToBackend(MuseumPlaceModel place) async {
    final repo = _repo;
    if (repo == null) return;

    try {
      final translations = <TranslationPlace>[];
      final langs = ['ar', 'en', 'fr', 'de', 'zh', 'ru'];
      for (final lang in langs) {
        final name = place.localizedNames[lang];
        final desc = place.localizedDescriptions[lang];
        if (name != null && name.isNotEmpty) {
          translations.add(
            TranslationPlace(
              languageCode: lang,
              name: name,
              shortDescription: desc ?? '',
            ),
          );
        }
      }

      final request = VirtualGalleryPlaceAiRequest(
        code: place.id,
        category: place.category,
        city: place.location['city'] ?? '',
        country: place.location['country'] ?? '',
        imageUrl: place.imageUrl,
        translations: translations,
      );

      final result = await repo.addVirtualGallaryPlace(
        virtualGalleryPlaceAiRequest: request,
      );

      result.fold(
        (error) => debugPrint('⚠️  Backend place upload failed: $error'),
        (_) => debugPrint('✅  Place "${place.name}" saved to backend.'),
      );
    } catch (e) {
      debugPrint('⚠️  Exception sending place to backend: $e');
    }
  }

  Future<void> _sendSentenceToBackend(
    String sentenceCode,
    String imageUrl,
    String placeCode,
    Map<String, String> localizedNames,
  ) async {
    final repo = _repo;
    if (repo == null) return;

    try {
      final translations = localizedNames.entries
          .where((e) => e.value.isNotEmpty)
          .map(
            (e) => TranslationSentence(
              languageCode: e.key,
              text: e.value,
            ),
          )
          .toList();

      final request = VirtualGallerySentenceRequest(
        code: sentenceCode,
        imageUrl: imageUrl,
        translations: translations,
      );

      final result = await repo.addVirtualGallarySentance(
        virtualGallerySentenceRequest: request,
        placeCode: placeCode,
      );

      result.fold(
        (error) => debugPrint('⚠️  Backend sentence upload failed: $error'),
        (_) => debugPrint(
          '✅  Sentence "$sentenceCode" saved (${translations.length} translations).',
        ),
      );
    } catch (e) {
      debugPrint('⚠️  Exception sending sentence to backend: $e');
    }
  }
}
