import 'package:flutter/material.dart';
import 'package:arabic/features/curriculum/data/models/culture_model.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/level_header.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/lesson_skeleton.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:arabic/features/home/presentation/view/widgets/home_bg.dart';

class LessonListLoadingView extends StatelessWidget {
  final CurriculumLevel activeLevel;

  const LessonListLoadingView({super.key, required this.activeLevel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080818),
      body: Stack(
        children: [
          const Positioned.fill(child: Background3D()),
          HomeBackground(
            child: SafeArea(
              child: Column(
                children: [
                  LevelHeader(activeLevel: activeLevel),
                  const Expanded(child: LessonSkeleton()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
