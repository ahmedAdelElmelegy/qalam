import 'package:arabic/core/utils/local_storage.dart';
import 'package:arabic/features/home/presentation/manager/home_progress_cubit.dart';
import 'package:arabic/features/settings/presentation/manager/get%20profile/get_profile_cubit.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:arabic/features/home/presentation/view/widgets/home_bg.dart';
import 'package:arabic/features/home/presentation/view/widgets/home_feature_grid.dart';
import 'package:arabic/features/home/presentation/view/widgets/home_header_section.dart';
import 'package:arabic/features/home/presentation/view/widgets/home_progress_card.dart';
import 'package:arabic/features/home/presentation/view/widgets/home_section_header.dart';
import 'package:arabic/features/home/presentation/view/widgets/floating_orbs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arabic/core/utils/network_checker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late AnimationController _heroController;
  late ScrollController _scrollController;
  double _scrollOffset = 0.0;
  int? userId;

  // ============================================================================
  // LIFECYCLE METHODS
  // ============================================================================

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
        });
      });

    // Refresh progress data and profile on init
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userId = await LocalStorage.getEmailId();

      if (mounted) {
        context.read<HomeProgressCubit>().getProgress(userId ?? 0);
        context.read<GetProfileCubit>().getProfile(userId ?? 0);
      }
    });
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _heroController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Resolve user's first name from profile (first word of fullName)
    return Scaffold(
      body: Stack(
        children: [
          // 3D Background Layer with parallax
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(0, _scrollOffset * 0.5),
              child: const Background3D(),
            ),
          ),

          // Floating orbs with depth
          FloatingOrbs(scrollOffset: _scrollOffset),

          // Main content with gradient overlay
          HomeBackground(
            child: SafeArea(
              child: BlocListener<HomeProgressCubit, HomeProgressState>(
                listener: (context, state) async {
                  if (state is HomeProgressFailure) {
                    if (!await NetworkChecker.hasConnection()) {
                      if (context.mounted) {
                        NetworkChecker.showNoNetworkDialog(context);
                      }
                    }
                    // } else {
                    //   if (context.mounted) {
                    //     AppSnakeBar.showErrorMessage(context, state.message);
                    //   }
                    // }
                  }
                },
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    HomeHeaderSection(scrollOffset: _scrollOffset),
                    HomeProgressCard(userId: userId ?? 0),
                    HomeSectionHeader(
                      title: 'start_learning'.tr(context: context),
                      subtitle: 'choose_path'.tr(context: context),
                    ),
                    const HomeFeatureGrid(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
