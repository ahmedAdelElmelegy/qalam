import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/features/museum/data/models/virtual%20gallery/ai%20generated/request_body/virual_gallary_ai_request.dart';
import 'package:arabic/features/museum/data/repo/virtual_gallary_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'virtual_gallery_add_places_state.dart';

class VirtualGalleryAddPlacesCubit extends Cubit<VirtualGalleryAddPlacesState> {
  VirtualGalleryAddPlacesCubit(this._virtualGallaryRepo)
    : super(VirtualGalleryAddPlacesInitial());
  final VirtualGallaryRepo _virtualGallaryRepo;

  Future<void> addPlace({
    required VirtualGalleryPlaceAiRequest virtualGalleryPlaceAiRequest,
  }) async {
    emit(VirtualGalleryAddPlacesLoading());
    final result = await _virtualGallaryRepo.addVirtualGallaryPlace(
      virtualGalleryPlaceAiRequest: virtualGalleryPlaceAiRequest,
    );
    result.fold(
      (l) =>
          emit(VirtualGalleryAddPlacesError(ApiErrorHandler.getUserMessage(l))),
      (r) => emit(VirtualGalleryAddPlacesSuccess()),
    );
  }
}
