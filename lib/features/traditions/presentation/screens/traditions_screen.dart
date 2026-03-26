import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/utils/local_storage.dart';
import 'package:arabic/core/widgets/custom_loading_widget.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:arabic/core/widgets/journy_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cubit/tradition_cubit.dart';
import '../../cubit/tradition_state.dart';
import '../widgets/tradition_story_view.dart';
import '../widgets/traditions_error.dart';
import '../widgets/journey_content.dart';

class TraditionsScreen extends StatefulWidget {
  const TraditionsScreen({super.key});

  @override
  State<TraditionsScreen> createState() => _TraditionsScreenState();
}

class _TraditionsScreenState extends State<TraditionsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _avatarController;
  String lang = 'en';

  @override
  void initState() {
    super.initState();
    _avatarController = AnimationController(vsync: this, duration: 2.seconds);
    context.read<TraditionCubit>().loadTraditions('en');
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
    return BlocConsumer<TraditionCubit, TraditionState>(
      listener: (context, state) {
        if (state.status == TraditionStatus.loaded &&
            _avatarController.value == 0) {
          final height = (350 * state.traditions.length).h.clamp(
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
              : JournyAppBar(title: 'culture_traditions_title'.tr()),
          body: Stack(
            children: [
              const Background3D(),
              if (state.status == TraditionStatus.loading)
                const CustomLoadingWidget()
              else if (state.status == TraditionStatus.error)
                TraditionsError(
                  errorMessage: state.errorMessage ?? 'Unknown error',
                  traditionState: state,
                )
              else
                TraditionsJourneyContent(
                  state: state,
                  avatarController: _avatarController,
                  lang: lang,
                ),

              if (state.isStoryMode && state.currentTradition != null)
                TraditionStoryView(
                  tradition: state.currentTradition!,
                  languageCode: lang,
                  onClose: () =>
                      context.read<TraditionCubit>().toggleViewMode(),
                ).animate().fadeIn(),
            ],
          ),
        );
      },
    );
  }
}
