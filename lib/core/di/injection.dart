import 'package:arabic/core/network/data_source/remote/dio/api_services.dart';
import 'package:arabic/core/utils/dio_factory.dart';
import 'package:arabic/features/auth/data/repo/auth_repo.dart';
import 'package:arabic/features/auth/presentation/manager/auth/auth_cubit.dart';
import 'package:arabic/features/auth/presentation/manager/language/language_cubit.dart';
import 'package:arabic/features/home/data/repo/progress_repo.dart';
import 'package:arabic/features/home/presentation/manager/home_progress_cubit.dart';
import 'package:arabic/features/chat/presentation/manager/chat_cubit.dart';
import 'package:arabic/features/clothing/presentation/cubit/clothing_cubit.dart';
import 'package:arabic/features/curriculum/data/repo/level_repo.dart';
import 'package:arabic/features/curriculum/data/repo/sync_request_repo.dart';
import 'package:arabic/features/curriculum/data/repo/unit_repo.dart';
import 'package:arabic/features/curriculum/data/repo/lesson_repo.dart';
import 'package:arabic/features/curriculum/presentation/manager/cubit/sync_quiz_cubit.dart';
import 'package:arabic/features/curriculum/presentation/manager/level/level_cubit.dart';
import 'package:arabic/features/curriculum/presentation/manager/units/unit_cubit.dart';
import 'package:arabic/features/curriculum/presentation/manager/lessons/lesson_cubit.dart';
import 'package:arabic/features/curriculum/data/repo/quiz_repo.dart';
import 'package:arabic/features/curriculum/presentation/manager/quiz/quiz_cubit.dart';
import 'package:arabic/features/food/data/repositories/food_repository.dart';
import 'package:arabic/features/food/presentation/cubit/food_cubit.dart';
import 'package:arabic/features/history/presentation/cubit/history_cubit.dart';
import 'package:arabic/features/history/data/repositories/history_repository.dart';
import 'package:arabic/features/museum/data/repo/virtual_gallary_repo.dart';
import 'package:arabic/features/museum/presentation/manager/add%20by%20ai/culture_cubit.dart';
import 'package:arabic/features/museum/presentation/manager/add%20by%20ai/museum_cubit.dart';
import 'package:arabic/features/city/presentation/cubit/city_cubit.dart';
import 'package:arabic/features/city/data/repositories/city_repository.dart';
import 'package:arabic/features/clothing/data/repositories/clothing_repository.dart';
import 'package:arabic/features/settings/data/repo/profile_repo.dart';
import 'package:arabic/features/settings/presentation/manager/get%20profile/get_profile_cubit.dart';
import 'package:arabic/features/settings/presentation/manager/update%20profile/update_profile_cubit.dart';
import 'package:arabic/features/traditions/cubit/tradition_cubit.dart';
import 'package:arabic/features/traditions/data/repositories/tradition_repository.dart';
import 'package:arabic/features/curriculum/presentation/manager/curriculum_cubit.dart';
import 'package:arabic/features/speaking_game/data/services/speaking_challenge_prefs_service.dart';
import 'package:arabic/features/speaking_game/presentation/manager/speaking_challenge_levels_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;
Future<void> initializeDependencies() async {
  final dio = DioFactory.getDio();
  getIt.registerLazySingleton(() => dio);
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => ApiService(getIt(), getIt()));

  // repo
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(getIt()));
  getIt.registerLazySingleton<HistoryRepository>(
    () => HistoryRepository(getIt()),
  );
  getIt.registerLazySingleton<TraditionRepository>(
    () => TraditionRepository(getIt()),
  );
  getIt.registerLazySingleton<CityRepository>(() => CityRepository(getIt()));
  getIt.registerLazySingleton<ClothingRepository>(
    () => ClothingRepository(getIt()),
  );
  getIt.registerLazySingleton<FoodRepository>(() => FoodRepository(getIt()));
  getIt.registerLazySingleton<VirtualGallaryRepo>(
    () => VirtualGallaryRepoImpl(getIt()),
  );
  getIt.registerLazySingleton<ProfileRepo>(
    () => ProfileRepo(apiService: getIt()),
  );
  getIt.registerLazySingleton(() => LevelRepo(getIt()));
  getIt.registerLazySingleton(() => UnitRepo(getIt()));
  getIt.registerLazySingleton(() => LessonRepo(getIt()));
  getIt.registerLazySingleton(() => QuizRepo(getIt()));
  getIt.registerLazySingleton(() => SyncRequestRepo(apiService: getIt()));
  getIt.registerLazySingleton(() => ProgressRepo(getIt()));

  // cubit
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt()));

  getIt.registerLazySingleton(() => LanguageCubit(getIt()));
  getIt.registerLazySingleton(() => CultureCubit());
  getIt.registerLazySingleton(() => MuseumCubit(repo: getIt()));

  getIt.registerLazySingleton(() => HistoryCubit(getIt()));
  getIt.registerLazySingleton(() => TraditionCubit(getIt()));
  getIt.registerLazySingleton(() => CityCubit(getIt()));
  getIt.registerLazySingleton(() => ClothingCubit(getIt()));
  getIt.registerLazySingleton(() => FoodCubit(getIt()));
  getIt.registerLazySingleton(() => ChatCubit());
  getIt.registerLazySingleton(() => GetProfileCubit(getIt()));
  getIt.registerFactory(() => UpdateProfileCubit(getIt()));

  // Speaking Challenge
  getIt.registerLazySingleton(() => SpeakingChallengePrefsService(getIt()));
  getIt.registerLazySingleton(() => SpeakingChallengeLevelsCubit(getIt()));
  // levels
  getIt.registerLazySingleton(() => LevelCubit(getIt()));
  // units
  getIt.registerLazySingleton(() => UnitCubit(getIt()));
  // lessons
  getIt.registerLazySingleton(() => LessonCubit(getIt()));
  getIt.registerLazySingleton(() => QuizCubit(getIt()));

  // Add CurriculumCubit after the API cubits it depends on
  getIt.registerLazySingleton(
    () => CurriculumCubit(
      levelCubit: getIt(),
      unitCubit: getIt(),
      lessonCubit: getIt(),
      quizCubit: getIt(),
    ),
  );
  getIt.registerLazySingleton(() => SyncQuizCubit(getIt(), getIt()));
  getIt.registerLazySingleton(() => HomeProgressCubit(getIt()));
}
