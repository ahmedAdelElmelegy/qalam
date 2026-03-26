import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/utils/local_storage.dart';
import 'package:arabic/features/city/presentation/cubit/city_cubit.dart';
import 'package:arabic/features/city/presentation/cubit/city_state.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/city_story_view.dart';
import 'package:arabic/core/widgets/journy_app_bar.dart';
import '../widgets/city_error.dart';
import '../widgets/journey_content.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:arabic/core/widgets/custom_loading_widget.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _avatarController;
  String lang = 'en';

  @override
  void initState() {
    super.initState();
    _avatarController = AnimationController(vsync: this, duration: 2.seconds);
    context.read<CityCubit>().loadCities();
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
    return BlocConsumer<CityCubit, CityState>(
      listener: (context, state) {
        if (state.status == CityStatus.loaded && _avatarController.value == 0) {
          final height = (350 * state.cities.length).h.clamp(1600.h, 6000.h);

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
              : JournyAppBar(title: 'culture_cities_title'.tr()),
          body: Stack(
            children: [
              const Background3D(),
              if (state.status == CityStatus.loading)
                const CustomLoadingWidget()
              else if (state.status == CityStatus.error)
                CityError(
                  errorMessage: state.errorMessage ?? 'Unknown error',
                  cityState: state,
                )
              else
                CityJourneyContent(
                  state: state,
                  avatarController: _avatarController,
                  lang: lang,
                ),

              if (state.isStoryMode && state.currentCity != null)
                CityStoryView(
                  city: state.currentCity!,
                  languageCode: lang,
                  onClose: () => context.read<CityCubit>().toggleViewMode(),
                ).animate().fadeIn(),
            ],
          ),
        );
      },
    );
  }
}
