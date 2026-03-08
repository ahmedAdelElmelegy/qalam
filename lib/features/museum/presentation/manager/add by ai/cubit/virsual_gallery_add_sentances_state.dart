part of 'virsual_gallery_add_sentances_cubit.dart';

sealed class VirsualGalleryAddSentancesState extends Equatable {
  const VirsualGalleryAddSentancesState();

  @override
  List<Object> get props => [];
}

final class VirsualGalleryAddSentancesInitial
    extends VirsualGalleryAddSentancesState {}

// add loading, success, error states
final class VirsualGalleryAddSentancesLoading
    extends VirsualGalleryAddSentancesState {}

final class VirsualGalleryAddSentancesSuccess
    extends VirsualGalleryAddSentancesState {}

final class VirsualGalleryAddSentancesError
    extends VirsualGalleryAddSentancesState {
  final String message;
  const VirsualGalleryAddSentancesError({required this.message});
}
