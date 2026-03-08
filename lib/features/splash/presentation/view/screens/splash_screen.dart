import 'dart:async';
import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/utils/local_storage.dart';
import 'package:arabic/features/home/presentation/view/screens/home_screen.dart';
import 'package:arabic/features/onboarding/presentation/view/screens/onboarding_screen.dart';
import 'package:arabic/features/splash/presentation/view/widgets/animated_logo.dart';
import 'package:arabic/features/splash/presentation/view/widgets/animation_gradient_bg.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _bgController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _navigateAfterDelay();
  }

  void _initializeAnimations() {
    // Logo animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeIn));

    // Background animation (continuous)
    _bgController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 3000));

    if (!mounted) return;

    bool isLoggedIn = await LocalStorage.isLoggedIn();

    if (mounted) {
      context.pushReplacement(
        isLoggedIn ? const HomeScreen() : const OnboardingScreen(),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedGradientBackground(controller: _bgController),

          // Main content
          SafeArea(
            child: Center(
              child: AnimatedLogo(
                logoController: _logoController,
                logoScale: _logoScale,
                logoOpacity: _logoOpacity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
