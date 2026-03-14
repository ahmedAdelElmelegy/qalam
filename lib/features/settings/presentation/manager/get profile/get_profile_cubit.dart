import 'package:arabic/core/utils/local_storage.dart';
import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/features/settings/data/model/profile_model.dart';
import 'package:arabic/features/settings/data/repo/profile_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'get_profile_state.dart';

class GetProfileCubit extends Cubit<GetProfileState> {
  GetProfileCubit(this.profileRepo) : super(GetProfileInitial());
  final ProfileRepo profileRepo;
  ProfileModel? profile;

  void clearProfile() {
    profile = null;
    emit(GetProfileInitial());
  }

  Future<void> getProfile(int userId) async {
    emit(GetProfileLoading());
    final result = await profileRepo.getProfile(userId);
    result.fold(
      (l) => emit(GetProfileError(ApiErrorHandler.getUserMessage(l))),
      (r) async {
        profile = r.data;
        if (r.data != null) {
          await LocalStorage.saveUserFullName(r.data!.fullName);
          emit(GetProfileSuccess(r.data!));
        } else {
          emit(const GetProfileError('Failed to fetch profile data'));
        }
      },
    );
  }
}
