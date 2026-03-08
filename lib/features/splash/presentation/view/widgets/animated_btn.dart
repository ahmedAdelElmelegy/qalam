import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/utils/local_storage.dart';
import 'package:arabic/core/widgets/premium_btn.dart';
import 'package:arabic/features/home/presentation/view/screens/home_screen.dart';
import 'package:arabic/features/onboarding/presentation/view/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';

class AnimatedButton extends StatelessWidget {
  final AnimationController buttonController;
  final Animation<double> buttonSlide;

  const AnimatedButton({
    super.key,
    required this.buttonController,
    required this.buttonSlide,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: buttonController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, buttonSlide.value),
          child: Opacity(
            opacity: buttonController.value,
            child: PremiumButton(
              text: 'Start Journey',
              onPressed: () async {
                String? token = await LocalStorage.getToken();
                if (token != null && context.mounted) {
                  context.pushReplacement(HomeScreen());
                } else if (context.mounted) {
                  context.pushReplacement(OnboardingScreen());
                }
              },
            ),
          ),
        );
      },
    );
  }
}
