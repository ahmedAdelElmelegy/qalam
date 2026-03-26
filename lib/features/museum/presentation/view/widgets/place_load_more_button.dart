import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/widgets/custom_loading_widget.dart';

class PlaceLoadMoreButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onLoadMore;

  const PlaceLoadMoreButton({
    super.key,
    required this.isLoading,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 30.h),
        child: isLoading
            ? const Center(child: CustomLoadingWidget())
            : OutlinedButton.icon(
                onPressed: onLoadMore,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.accentGold),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: AppColors.primaryNavy.withValues(alpha: 0.5),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.accentGold,
                ),
                label: Text(
                  "load_more".tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.accentGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }
}
