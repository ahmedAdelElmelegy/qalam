import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';
import 'package:arabic/features/curriculum/data/models/progress/sync_quiz_request_body.dart';
import 'package:arabic/features/curriculum/data/repo/sync_request_repo.dart';
import 'package:arabic/features/home/presentation/manager/home_progress_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'sync_quiz_state.dart';

class SyncQuizCubit extends Cubit<SyncQuizState> {
  SyncQuizCubit(this.syncRequestRepo, this.homeProgressCubit)
    : super(SyncQuizInitial());
  final SyncRequestRepo syncRequestRepo;
  final HomeProgressCubit homeProgressCubit;

  void syncQuiz(SyncQuizRequestBody body, int userId) async {
    emit(SyncQuizLoading());
    final result = await syncRequestRepo.syncQuiz(body, userId);
    result.fold((l) => emit(SyncQuizFailure(l)), (r) {
      homeProgressCubit.getProgress(userId);
      emit(SyncQuizSuccess());
    });
  }
}
