import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LessonSkeleton extends StatelessWidget {
  const LessonSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      itemCount: 6,
      itemBuilder: (context, i) {
        return Padding(
          padding: EdgeInsets.only(bottom: 60.h),
          child:
              Row(
                    mainAxisAlignment: i % 2 == 0
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      if (i % 2 != 0) const Spacer(),
                      Column(
                        children: [
                          Container(
                            width: 50.w,
                            height: 50.w,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            width: 140.w,
                            height: 64.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                        ],
                      ),
                      if (i % 2 == 0) const Spacer(),
                    ],
                  )
                  .animate(onPlay: (c) => c.repeat())
                  .shimmer(
                    duration: 1200.ms,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
        );
      },
    );
  }
}
