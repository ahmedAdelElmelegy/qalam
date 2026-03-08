import 'package:arabic/core/di/injection.dart';
import 'package:arabic/features/auth/presentation/manager/auth/auth_cubit.dart';
import 'package:arabic/features/auth/presentation/manager/language/language_cubit.dart';
import 'package:arabic/features/chat/presentation/manager/chat_cubit.dart';
import 'package:arabic/features/clothing/presentation/cubit/clothing_cubit.dart';
import 'package:arabic/features/curriculum/presentation/manager/cubit/sync_quiz_cubit.dart';
import 'package:arabic/features/curriculum/presentation/manager/level/level_cubit.dart';
import 'package:arabic/features/curriculum/presentation/manager/units/unit_cubit.dart';
import 'package:arabic/features/curriculum/presentation/manager/lessons/lesson_cubit.dart';
import 'package:arabic/features/curriculum/presentation/manager/quiz/quiz_cubit.dart';
import 'package:arabic/features/food/presentation/cubit/food_cubit.dart';
import 'package:arabic/features/history/presentation/cubit/history_cubit.dart';
import 'package:arabic/features/museum/presentation/manager/add%20by%20ai/culture_cubit.dart';
import 'package:arabic/features/museum/presentation/manager/add%20by%20ai/museum_cubit.dart';
import 'package:arabic/features/city/presentation/cubit/city_cubit.dart';
import 'package:arabic/features/home/presentation/manager/home_progress_cubit.dart';
import 'package:arabic/features/curriculum/presentation/manager/curriculum_cubit.dart';
import 'package:arabic/features/settings/presentation/manager/get%20profile/get_profile_cubit.dart';
import 'package:arabic/features/settings/presentation/manager/update%20profile/update_profile_cubit.dart';
import 'package:arabic/features/traditions/cubit/tradition_cubit.dart';
import 'package:arabic/features/speaking_game/presentation/manager/speaking_challenge_levels_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenerateMultiBloc extends StatelessWidget {
  final Widget child;
  const GenerateMultiBloc({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<ClothingCubit>()..loadClothingData(),
        ),
        BlocProvider(create: (context) => getIt<AuthCubit>()),
        BlocProvider(create: (context) => getIt<LanguageCubit>()),
        BlocProvider(create: (context) => getIt<MuseumCubit>()),
        BlocProvider(create: (context) => getIt<CultureCubit>()),
        BlocProvider(create: (context) => getIt<HistoryCubit>()..loadHistory()),
        BlocProvider(
          create: (context) => getIt<TraditionCubit>()..loadTraditions(),
        ),
        BlocProvider(create: (context) => getIt<CityCubit>()..loadCities()),
        BlocProvider(create: (context) => getIt<FoodCubit>()..loadFoodData()),
        BlocProvider(create: (context) => getIt<CurriculumCubit>()),
        BlocProvider(create: (context) => getIt<ChatCubit>()),
        BlocProvider(create: (context) => getIt<GetProfileCubit>()),
        BlocProvider(create: (context) => getIt<UpdateProfileCubit>()),
        BlocProvider(
          create: (context) => getIt<SpeakingChallengeLevelsCubit>(),
        ),
        BlocProvider(create: (context) => getIt<LevelCubit>()),
        BlocProvider(create: (context) => getIt<UnitCubit>()),
        BlocProvider(create: (context) => getIt<LessonCubit>()),
        BlocProvider(create: (context) => getIt<QuizCubit>()),
        BlocProvider(create: (context) => getIt<SyncQuizCubit>()),
        BlocProvider(
          create: (context) => getIt<HomeProgressCubit>()..getProgress(),
        ),
      ],
      child: child,
    );
  }
}
