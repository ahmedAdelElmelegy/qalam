import 'package:arabic/core/model/lang/language.dart';
import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';
import 'package:arabic/features/auth/data/repo/auth_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit(this.authRepo) : super(LanguageInitial());
  final AuthRepo authRepo;
  List<Language> languages = [];
  void getLanguages() async {
    emit(LanguageLoading());
    final result = await authRepo.getLanguages();
    result.fold((l) => emit(LanguageError(l)), (r) {
      languages = r.data;
      emit(LanguageLoaded());
    });
  }
}
