part of 'virtual_gallery_add_places_cubit.dart';

sealed class VirtualGalleryAddPlacesState extends Equatable {
  const VirtualGalleryAddPlacesState();

  @override
  List<Object> get props => [];
}

final class VirtualGalleryAddPlacesInitial
    extends VirtualGalleryAddPlacesState {}

// add loading, success, error states
final class VirtualGalleryAddPlacesLoading
    extends VirtualGalleryAddPlacesState {}

final class VirtualGalleryAddPlacesSuccess
    extends VirtualGalleryAddPlacesState {}

final class VirtualGalleryAddPlacesError extends VirtualGalleryAddPlacesState {
  final String message;
  const VirtualGalleryAddPlacesError(this.message);

  @override
  List<Object> get props => [message];
}
