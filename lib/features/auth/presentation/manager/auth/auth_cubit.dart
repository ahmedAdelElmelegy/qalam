import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';
import 'package:arabic/core/utils/local_storage.dart';
import 'package:arabic/features/auth/data/model/body/sign_in_request_body.dart';
import 'package:arabic/features/auth/data/model/body/sign_up_request_body.dart';
import 'package:arabic/features/auth/data/repo/auth_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authRepo) : super(AuthInitial());
  AuthRepo authRepo;

  void login({required SignInRequestBody requestBody}) async {
    emit(AuthLoading());
    final result = await authRepo.signIn(requestBody: requestBody);
    result.fold((l) => emit(AuthError(l)), (r) {
      LocalStorage.saveToken(r.data.token);
      LocalStorage.saveLanguage(r.data.nativeLanguageCode);
      LocalStorage.saveUserFullName(r.data.fullName);
      LocalStorage.saveUserEmail(r.data.email);
      LocalStorage.saveEmailId(r.data.id);
      emit(AuthAuthenticated());
    });
  }

  // sign up
  void register({required SignUpRequestBody requestBody}) async {
    emit(SignUpLoading());
    final result = await authRepo.signUp(requestBody: requestBody);
    result.fold((l) => emit(SignUpError(l)), (r) {
      emit(SignUpSuccess(r.message));
    });
  }
}
