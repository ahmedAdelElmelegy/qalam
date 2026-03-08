import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/features/museum/data/models/virtual%20gallery/ai%20generated/request_body/virual_gallary_ai_sentance_request.dart';
import 'package:arabic/features/museum/data/repo/virtual_gallary_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'virsual_gallery_add_sentances_state.dart';

class VirsualGalleryAddSentancesCubit
    extends Cubit<VirsualGalleryAddSentancesState> {
  VirsualGalleryAddSentancesCubit(this._repository)
    : super(VirsualGalleryAddSentancesInitial());
  final VirtualGallaryRepo _repository;

  Future<void> addSentance(
    VirtualGallerySentenceRequest request,
    String placeCode,
  ) async {
    emit(VirsualGalleryAddSentancesLoading());
    final result = await _repository.addVirtualGallarySentance(
      virtualGallerySentenceRequest: request,
      placeCode: placeCode,
    );
    result.fold(
      (l) => emit(
        VirsualGalleryAddSentancesError(
          message: ApiErrorHandler.getUserMessage(l),
        ),
      ),
      (r) => emit(VirsualGalleryAddSentancesSuccess()),
    );
  }
}
