import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/curriculum/data/models/culture_model.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/level_header.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:arabic/features/home/presentation/view/widgets/home_bg.dart';
import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';
import 'package:arabic/features/curriculum/presentation/manager/units/unit_cubit.dart';

class LessonListErrorView extends StatelessWidget {
  final CurriculumLevel activeLevel;
  final dynamic exception;

  const LessonListErrorView({
    super.key,
    required this.activeLevel,
    required this.exception,
  });

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
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              exception is NetworkException
                                  ? Icons.wifi_off_rounded
                                  : Icons.error_outline_rounded,
                              color: Colors.redAccent.withValues(alpha: 0.8),
                              size: 48.w,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              ApiErrorHandler.getUserMessage(exception),
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 24.h),
                            ElevatedButton(
                              onPressed: () {
                                if (activeLevel.dbId != null) {
                                  context.read<UnitCubit>().getUnits(
                                        levelId: activeLevel.dbId!,
                                        lang: context.locale.languageCode,
                                      );
                                }
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
