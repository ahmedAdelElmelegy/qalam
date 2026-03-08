import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/widgets/glass_container.dart';
import 'package:arabic/features/auth/presentation/sign_in/view/screens/sign_in.dart';
import 'package:arabic/features/onboarding/presentation/view/widgets/onboarding_indicators.dart';
import 'package:arabic/features/onboarding/presentation/view/widgets/onboarding_navigation_button.dart';
import 'package:arabic/features/onboarding/presentation/view/widgets/onboarding_page_content.dart';
import 'package:arabic/features/splash/presentation/view/widgets/animation_gradient_bg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:easy_localization/easy_localization.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _bgController;
  int _currentPage = 0;
  double _pageOffset = 0.0;

  final List<Map<String, dynamic>> _pages = [
    {
      'image': 'assets/images/onboarding_1.png',
      'title': 'onboarding_title_1',
      'subtitle': 'onboarding_subtitle_1',
    },
    {
      'image': 'assets/images/onboarding_2.png',
      'title': 'onboarding_title_2',
      'subtitle': 'onboarding_subtitle_2',
    },
    {
      'image': 'assets/images/onboarding_3.png',
      'title': 'onboarding_title_3',
      'subtitle': 'onboarding_subtitle_3',
    },
  ];

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _pageController.addListener(() {
      setState(() {
        _pageOffset = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedGradientBackground(controller: _bgController),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    // Main Content
                    Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() => _currentPage = index);
                            },
                            itemCount: _pages.length,
                            itemBuilder: (context, index) {
                              final pageOffset = _pageOffset - index;
                              final opacity = (1 - pageOffset.abs() * 1.2).clamp(
                                0.0,
                                1.0,
                              );

                              return OnboardingPageContent(
                                index: index,
                                pageOffset: pageOffset,
                                opacity: opacity,
                                constraints: constraints,
                                pageData: _pages[index],
                                isLandscape: isLandscape,
                              );
                            },
                          ),
                        ),

                        // Animated Page Indicators
                        OnboardingIndicators(
                          currentPage: _currentPage,
                          pageCount: _pages.length,
                        ),

                        SizedBox(height: 20.h),

                        // Navigation Button
                        OnboardingNavigationButton(
                          currentPage: _currentPage,
                          pageCount: _pages.length,
                          onPressed: () {
                            if (_currentPage == _pages.length - 1) {
                              context.pushReplacement(const SignInScreen());
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeOutCubic,
                              );
                            }
                          },
                        ),

                        SizedBox(height: 40.h),
                      ],
                    ),

                    // Floating Skip Button
                    Positioned(
                      top: 16.h,
                      right: 24.w,
                      child:
                          GlassContainer(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 8.h,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                blur: 10,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    context.pushReplacement(
                                      const SignInScreen(),
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'skip'.tr(),
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              color: Colors.white.withValues(
                                                alpha: 0.8,
                                              ),
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Icon(
                                        Icons.chevron_right,
                                        color: AppColors.accentGold,
                                        size: 20.sp,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .animate()
                              .fadeIn(delay: 500.ms)
                              .slideX(begin: 0.5, end: 0),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
