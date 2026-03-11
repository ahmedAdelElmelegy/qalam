import 'package:arabic/core/utils/local_storage.dart';
import 'package:arabic/features/home/presentation/manager/home_progress_cubit.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:arabic/features/home/presentation/view/widgets/home_bg.dart';
import 'package:arabic/features/home/presentation/view/widgets/home_feature_grid.dart';
import 'package:arabic/features/home/presentation/view/widgets/home_header_section.dart';
import 'package:arabic/features/home/presentation/view/widgets/home_progress_card.dart';
import 'package:arabic/features/home/presentation/view/widgets/home_section_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    // Refresh progress data on init
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userId = await LocalStorage.getEmailId();

      if (mounted) {
        context.read<HomeProgressCubit>().getProgress(userId ?? 0);
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
          ..._buildFloatingOrbs(),

          // Main content with gradient overlay
          HomeBackground(
            child: SafeArea(
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  HomeHeaderSection(scrollOffset: _scrollOffset),
                  HomeProgressCard(userId: userId ?? 0),
                  HomeSectionHeader(
                    title: 'start_learning'.tr(),
                    subtitle: 'choose_path'.tr(),
                  ),
                  const HomeFeatureGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFloatingOrbs() {
    return List.generate(3, (index) {
      final positions = [
        {
          'top': 150.0,
          'left': 30.0,
          'size': 100.0,
          'color': const Color(0xFFD4AF37),
        },
        {
          'top': 400.0,
          'right': 40.0,
          'size': 90.0,
          'color': const Color(0xFF6366F1),
        },
        {
          'top': 650.0,
          'left': 50.0,
          'size': 95.0,
          'color': const Color(0xFF8B5CF6),
        },
      ];

      final pos = positions[index];
      final parallaxFactor = 0.3 + (index * 0.1);

      return Positioned(
        top: (pos['top'] as double) - (_scrollOffset * parallaxFactor),
        left: pos.containsKey('left') ? pos['left'] as double : null,
        right: pos.containsKey('right') ? pos['right'] as double : null,
        child: IgnorePointer(
          child:
              Container(
                    width: pos['size'] as double,
                    height: pos['size'] as double,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          (pos['color'] as Color).withValues(alpha: 0.15),
                          (pos['color'] as Color).withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.2, 1.2),
                    duration: Duration(milliseconds: 3000 + (index * 500)),
                    curve: Curves.easeInOut,
                  ),
        ),
      );
    });
  }
}
