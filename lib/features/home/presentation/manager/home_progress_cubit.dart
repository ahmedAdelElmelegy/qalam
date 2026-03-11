import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/features/home/data/model/progress_model.dart';
import 'package:arabic/features/home/data/repo/progress_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_progress_state.dart';

class HomeProgressCubit extends Cubit<HomeProgressState> {
  final ProgressRepo progressRepo;

  HomeProgressCubit(this.progressRepo) : super(HomeProgressInitial());

  ProgressData? progressData;

  void clearProgress() {
    progressData = null;
    emit(HomeProgressInitial());
  }

  Future<void> getProgress(int userId) async {
    emit(HomeProgressLoading());
    final result = await progressRepo.getProgress(userId);
    result.fold(
      (l) => emit(HomeProgressFailure(ApiErrorHandler.getUserMessage(l))),
      (r) {
        progressData = r.data;
        emit(HomeProgressSuccess(r.data));
      },
    );
  }
}
