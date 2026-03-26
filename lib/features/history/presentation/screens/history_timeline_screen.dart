import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/utils/local_storage.dart';
import 'package:arabic/core/widgets/custom_loading_widget.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:arabic/core/widgets/journy_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arabic/features/history/presentation/cubit/history_cubit.dart';
import 'package:arabic/features/history/presentation/cubit/history_state.dart';
import 'package:arabic/features/history/presentation/widgets/story_mode_view.dart';
import '../widgets/history_error.dart';
import '../widgets/journey_content.dart';

class HistoryTimelineScreen extends StatefulWidget {
  const HistoryTimelineScreen({super.key});

  @override
  State<HistoryTimelineScreen> createState() => _HistoryTimelineScreenState();
}

class _HistoryTimelineScreenState extends State<HistoryTimelineScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _avatarController;
  String lang = 'en';

  @override
  void initState() {
    super.initState();
    _avatarController = AnimationController(vsync: this, duration: 2.seconds);
    _avatarController.animateTo(0.1, duration: 1.seconds);
    context.read<HistoryCubit>().loadHistory();
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
    return BlocConsumer<HistoryCubit, HistoryState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.primaryNavy,
          extendBodyBehindAppBar: true,
          appBar: state.isStoryMode
              ? null
              : JournyAppBar(title: 'culture_history_title'.tr()),
          body: Stack(
            children: [
              const Background3D(),
              if (state.status == HistoryStatus.loading)
                const CustomLoadingWidget()
              else if (state.status == HistoryStatus.error)
                HistoryError(
                  errorMessage: state.errorMessage ?? 'Unknown error',
                  historyState: state,
                )
              else
                HistoryJourneyContent(
                  state: state,
                  avatarController: _avatarController,
                  lang: lang,
                ),

              // Overlay Story Mode
              if (state.isStoryMode && state.currentPeriod != null)
                StoryModeView(
                  period: state.currentPeriod!,
                  languageCode: lang,
                  onClose: () => context.read<HistoryCubit>().toggleViewMode(),
                ).animate().fadeIn(),
            ],
          ),
        );
      },
    );
  }
}
