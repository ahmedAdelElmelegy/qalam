import 'package:equatable/equatable.dart';
import '../../../data/models/culture_zone_model.dart';
import '../../../data/models/culture_page_model.dart';

/// Culture States
abstract class CultureState extends Equatable {
  const CultureState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CultureInitial extends CultureState {
  const CultureInitial();
}

/// Loading state
class CultureLoading extends CultureState {
  const CultureLoading();
}

/// State when zones are loaded
class CultureLoaded extends CultureState {
  final List<CultureZone> zones;
  final CultureZone? selectedZone;
  final List<CulturePage> zonePages;
  final int currentPageIndex;
  final String? error;

  const CultureLoaded({
    required this.zones,
    this.selectedZone,
    this.zonePages = const [],
    this.currentPageIndex = 0,
    this.error,
  });

  CultureLoaded copyWith({
    List<CultureZone>? zones,
    CultureZone? selectedZone,
    List<CulturePage>? zonePages,
    int? currentPageIndex,
    String? error,
  }) {
    return CultureLoaded(
      zones: zones ?? this.zones,
      selectedZone: selectedZone, // Allow nulling out
      zonePages: zonePages ?? this.zonePages,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    zones,
    selectedZone,
    zonePages,
    currentPageIndex,
    error,
  ];
}

/// Error state
class CultureError extends CultureState {
  final String message;

  const CultureError(this.message);

  @override
  List<Object?> get props => [message];
}
