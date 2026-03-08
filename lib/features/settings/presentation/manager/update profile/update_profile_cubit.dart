import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/features/settings/data/model/edit_profile_request_body.dart';
import 'package:arabic/features/settings/data/model/profile_model.dart';
import 'package:arabic/features/settings/data/repo/profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit(this.profileRepo) : super(UpdateProfileInitial());
  final ProfileRepo profileRepo;

  void updateProfile({
    required EditProfileRequestBody requestBody,
    required int emailId,
  }) async {
    emit(UpdateProfileLoading());
    final result = await profileRepo.updateProfile(requestBody, emailId);
    result.fold(
      (l) => emit(
        UpdateProfileFailure(message: ApiErrorHandler.getUserMessage(l)),
      ),
      (r) => emit(UpdateProfileSuccess()),
    );
  }

  void updateLanguage({
    required int languageId,
    required ProfileModel profile,
  }) async {
    emit(UpdateProfileLoading());
    final result = await profileRepo.updateLanguage(languageId, profile);
    result.fold(
      (l) => emit(
        UpdateProfileFailure(message: ApiErrorHandler.getUserMessage(l)),
      ),
      (r) => emit(UpdateProfileSuccess()),
    );
  }
}
