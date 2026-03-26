import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/utils/local_storage.dart';
import 'package:arabic/core/widgets/journy_app_bar.dart';
import 'package:arabic/features/food/presentation/cubit/food_cubit.dart';
import 'package:arabic/features/food/presentation/cubit/food_state.dart';
import 'package:arabic/features/food/presentation/widgets/food_error.dart';
import 'package:arabic/features/food/presentation/widgets/journey_content.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/food_story_view.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:arabic/core/widgets/custom_loading_widget.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _avatarController;
  String lang = 'en';

  @override
  void initState() {
    super.initState();
    _avatarController = AnimationController(vsync: this, duration: 2.seconds);
    context.read<FoodCubit>().loadFoodData();
    LocalStorage.getLanguage().then((value) {
      if (!mounted) return;
      setState(() => lang = value ?? 'en');
    });
  }

  @override
  void dispose() {
    _avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FoodCubit, FoodState>(
      listener: (context, state) {
        if (state.status == FoodStatus.loaded && _avatarController.value == 0) {
          final height = (350 * state.foodItems.length).h.clamp(1600.h, 5000.h);
          final startT = 150.h / height;
          _avatarController.animateTo(startT, duration: 1.seconds);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.primaryNavy,
          extendBodyBehindAppBar: true,
          appBar: state.isStoryMode
              ? null
              : JournyAppBar(title: 'culture_food_title'.tr()),
          body: Stack(
            children: [
              const Background3D(),
              if (state.status == FoodStatus.loading)
                const CustomLoadingWidget()
              else if (state.status == FoodStatus.error)
                FoodError(
                  errorMessage: state.errorMessage ?? 'Unknown error',
                  foodState: state,
                )
              else
                FoodJourneyContent(
                  state: state,
                  avatarController: _avatarController,
                  lang: lang,
                ),

              if (state.isStoryMode && state.currentFood != null)
                FoodStoryView(
                  food: state.currentFood!,
                  languageCode: lang,
                  onClose: () => context.read<FoodCubit>().toggleViewMode(),
                ).animate().fadeIn(),
            ],
          ),
        );
      },
    );
  }
}
