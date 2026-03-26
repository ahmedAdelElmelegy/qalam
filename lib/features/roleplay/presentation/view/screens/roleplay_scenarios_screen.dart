import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/features/roleplay/data/models/roleplay_scenario_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:arabic/features/home/presentation/view/widgets/home_bg.dart';
import 'package:arabic/features/roleplay/presentation/view/widgets/roleplay_app_bar.dart';
import 'package:arabic/features/roleplay/presentation/view/widgets/roleplay_scenario_card.dart';

class RoleplayScenariosScreen extends StatelessWidget {
  const RoleplayScenariosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scenarios = RoleplayScenarioModel.availableScenarios;

    return Scaffold(
      backgroundColor: const Color(0xFF080818),
      extendBodyBehindAppBar: true,
      appBar: RoleplayAppBar(
        onLeadingPressed: () => context.pop(),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: Background3D()),
          HomeBackground(
            child: SafeArea(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                itemCount: scenarios.length,
                itemBuilder: (context, index) {
                  final scenario = scenarios[index];
                  return RoleplayScenarioCard(scenario: scenario, index: index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


}
