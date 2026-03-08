import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/museum/data/models/culture_content_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CultureDetailScreen extends StatelessWidget {
  final CultureContent content;

  const CultureDetailScreen({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final section = content.sections[index];
                return _buildSectionCard(section, index);
              }, childCount: content.sections.length),
            ),
          ),
          SliverPadding(padding: EdgeInsets.only(bottom: 40.h)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280.h,
      pinned: true,
      backgroundColor: AppColors.primaryNavy,
      leading: Padding(
        padding: EdgeInsets.all(8.w),
        child: CircleAvatar(
          backgroundColor: Colors.black26,
          child: BackButton(color: Colors.white),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image (Placeholder)
            Container(color: content.baseColor.withValues(alpha: 0.2)),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.primaryNavy.withValues(alpha: 0.8),
                    AppColors.primaryNavy,
                  ],
                ),
              ),
            ),
            // Title Content
            Positioned(
              bottom: 40.h,
              left: 20.w,
              right: 20.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: content.baseColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: content.baseColor.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      content.id.toUpperCase(),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: content.baseColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    content.title,
                    style: AppTextStyles.h2.copyWith(
                      color: Colors.white,
                      fontSize: 28.sp,
                      height: 1.1,
                    ),
                  ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                  SizedBox(height: 8.h),
                  Text(
                    content.description,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(CultureSection section, int index) {
    return Container(
          margin: EdgeInsets.only(bottom: 20.h),
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 4.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: content.baseColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      section.title,
                      style: AppTextStyles.h3.copyWith(
                        fontSize: 18.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                section.content,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white70,
                  height: 1.6,
                ),
              ),
              if (section.bulletPoints.isNotEmpty) ...[
                SizedBox(height: 16.h),
                ...section.bulletPoints.map(
                  (point) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 6.h),
                          child: Icon(
                            Icons.circle,
                            size: 6.w,
                            color: content.baseColor.withValues(alpha: 0.7),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            point,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white60,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        )
        .animate()
        .fadeIn(delay: (300 + index * 100).ms)
        .slideY(begin: 0.1, end: 0);
  }
}
