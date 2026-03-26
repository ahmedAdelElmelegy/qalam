import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/utils/local_storage.dart';
import 'package:arabic/core/widgets/custom_loading_widget.dart';
import 'package:arabic/features/clothing/presentation/cubit/clothing_cubit.dart';
import 'package:arabic/features/clothing/presentation/cubit/clothing_state.dart';
import 'package:arabic/features/clothing/presentation/widgets/clothing_story_view.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arabic/core/widgets/journy_app_bar.dart';
import '../widgets/clothing_error.dart';
import '../widgets/journey_content.dart';

class ClothingScreen extends StatefulWidget {
  const ClothingScreen({super.key});

  @override
  State<ClothingScreen> createState() => _ClothingScreenState();
}

class _ClothingScreenState extends State<ClothingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _avatarController;
  bool hasAutoOpened = false;
  String lang = 'en';

  @override
  void initState() {
    super.initState();
    _avatarController = AnimationController(vsync: this, duration: 2.seconds);
    context.read<ClothingCubit>().loadClothingData();
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
    return BlocConsumer<ClothingCubit, ClothingState>(
      listener: (context, state) {
        if (state.status == ClothingStatus.loaded &&
            _avatarController.value == 0) {
          final height = (350 * state.clothingItems.length).h.clamp(
            1600.h,
            5000.h,
          );
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
              : JournyAppBar(title: 'culture_clothing_title'.tr()),
          body: Stack(
            children: [
              const Background3D(),
              if (state.status == ClothingStatus.loading)
                const CustomLoadingWidget()
              else if (state.status == ClothingStatus.error)
                ClothingError(
                  errorMessage: state.errorMessage ?? 'Unknown error',
                  clothingState: state,
                )
              else
                ClothingJourneyContent(
                  state: state,
                  avatarController: _avatarController,
                  lang: lang,
                ),

              if (state.isStoryMode && state.selectedClothing != null)
                ClothingStoryView(
                  clothing: state.selectedClothing!,
                  languageCode: lang,
                  onClose: () => context.read<ClothingCubit>().toggleViewMode(),
                ).animate().fadeIn(),
            ],
          ),
        );
      },
    );
  }
}
