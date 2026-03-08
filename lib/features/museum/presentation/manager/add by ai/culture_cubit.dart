import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/culture_zone_model.dart';
import '../../../data/data_sources/culture_dummy_data.dart';
import 'culture_state.dart';

/// Culture Cubit
/// Manages state for the Arabic Culture Island feature
class CultureCubit extends Cubit<CultureState> {
  CultureCubit() : super(const CultureInitial()) {
    loadCultureIsland();
  }

  /// Load all cultural zones for the island hub
  Future<void> loadCultureIsland() async {
    emit(const CultureLoading());
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 800));

      final zones = CultureDummyData.getZones();
      emit(CultureLoaded(zones: zones));
    } catch (e) {
      emit(CultureError('Failed to load culture island: ${e.toString()}'));
    }
  }

  /// Select a cultural zone to explore
  Future<void> selectZone(CultureZone zone) async {
    if (state is CultureLoaded) {
      final currentState = state as CultureLoaded;
      emit(currentState.copyWith(selectedZone: zone, error: null));

      try {
        // Load pages for the selected zone
        final pages = CultureDummyData.getPagesByZone(zone.id);
        emit(
          currentState.copyWith(
            selectedZone: zone,
            zonePages: pages,
            currentPageIndex: 0,
          ),
        );
      } catch (e) {
        emit(currentState.copyWith(error: 'Failed to load zone details'));
      }
    }
  }

  /// Update current page index in PageView
  void updatePageIndex(int index) {
    if (state is CultureLoaded) {
      final currentState = state as CultureLoaded;
      emit(currentState.copyWith(currentPageIndex: index));
    }
  }

  /// Clear zone selection (back to island)
  void clearSelection() {
    if (state is CultureLoaded) {
      final currentState = state as CultureLoaded;
      emit(
        currentState.copyWith(
          selectedZone: null,
          zonePages: [],
          currentPageIndex: 0,
        ),
      );
    }
  }
}
