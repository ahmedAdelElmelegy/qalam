import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/utils/network_checker.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/features/city/presentation/view/screens/city_screen.dart';
import 'package:arabic/features/clothing/presentation/screens/clothing_screen.dart';
import 'package:arabic/features/food/presentation/screens/food_screen.dart';
import 'package:arabic/features/history/presentation/screens/history_timeline_screen.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:arabic/features/museum/presentation/manager/add%20by%20ai/culture_cubit.dart';
import 'package:arabic/features/museum/presentation/manager/add%20by%20ai/culture_state.dart';
import 'package:arabic/features/museum/presentation/view/widgets/culture_island_journy_content.dart';
import 'package:arabic/features/museum/presentation/view/widgets/culture_island/culture_app_bar.dart';
import 'package:arabic/features/museum/presentation/view/widgets/culture_island/culture_island_bottom_action.dart';
import 'package:arabic/features/traditions/presentation/view/screens/traditions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arabic/core/widgets/custom_loading_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CultureIslandScreen extends StatefulWidget {
  const CultureIslandScreen({super.key});

  @override
  State<CultureIslandScreen> createState() => _CultureIslandScreenState();
}

class _CultureIslandScreenState extends State<CultureIslandScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _avatarController;
  int _activeZoneIndex = 0;

  @override
  void initState() {
    super.initState();
    _avatarController = AnimationController(vsync: this, duration: 2.seconds);
    _avatarController.animateTo(0.1, duration: 1.seconds); // Initial position
  }

  @override
  void dispose() {
    _avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CultureCubit, CultureState>(
      listener: (context, state) async {
        if (state is CultureError) {
          if (!await NetworkChecker.hasConnection()) {
            if (context.mounted) {
              NetworkChecker.showNoNetworkDialog(context);
            }
          }
        }
        if (state is CultureLoaded && state.selectedZone != null) {
          final index = state.zones.indexWhere(
            (z) => z.id == state.selectedZone!.id,
          );
          if (index != -1) {
            setState(() => _activeZoneIndex = index);
            // Map index to path progress (0.1 start, 0.9 end)
            final targetProgress =
                0.1 + (index * 0.8 / (state.zones.length - 1));

            _avatarController
                .animateTo(
                  targetProgress,
                  duration: 1.5.seconds,
                  curve: Curves.easeInOutQuad,
                )
                .then((_) {
                  // Navigation upon arrival
                  final zoneId = state.selectedZone!.id.replaceAll('/', '');

                  context.push(_getLearningScreen(zoneId)).then((_) {
                    if (context.mounted) {
                      context.read<CultureCubit>().clearSelection();
                    }
                  });
                });
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.primaryNavy,
          extendBodyBehindAppBar: true,
          appBar: const CultureAppBar(),
          body: Stack(
            children: [
              const Background3D(),

              if (state is CultureLoaded)
                CultureIslandJourneyContent(
                  zones: state.zones,
                  activeZoneIndex: _activeZoneIndex,
                  avatarController: _avatarController,
                )
              else
                const CustomLoadingWidget(),

              // Floating Bottom Bar
              Positioned(
                bottom: 40.h,
                left: 0,
                right: 0,
                child: CultureIslandBottomAction(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getLearningScreen(String zoneId) {
    switch (zoneId) {
      case 'history':
        return const HistoryTimelineScreen();
      case 'traditions':
        return const TraditionsScreen();
      case 'clothing':
        return const ClothingScreen();
      case 'food':
        return const FoodScreen();
      case 'cities':
        return const CityScreen();
      default:
        return const Scaffold(body: Center(child: Text('No Screen Found')));
    }
  }
}
