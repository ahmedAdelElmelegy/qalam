import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/museum/data/models/museum_place_model.dart';

class PlaceDetailsAppBar extends StatelessWidget {
  final MuseumPlaceModel place;
  final VoidCallback onAddPressed;

  const PlaceDetailsAppBar({
    super.key,
    required this.place,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300.h,
      pinned: true,
      backgroundColor: AppColors.primaryNavy,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.all(8.w),
        child: CircleAvatar(
          backgroundColor: Colors.black.withValues(alpha: 0.4),
          child: const BackButton(color: AppColors.accentGold),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 12.w),
          child: CircleAvatar(
            backgroundColor: Colors.black.withValues(alpha: 0.4),
            child: IconButton(
              icon: const Icon(Icons.add, color: AppColors.accentGold),
              onPressed: onAddPressed,
              tooltip: 'add_custom_sentence'.tr(),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          place.localizedNames['ar'] ?? place.name,
          style: AppTextStyles.arabicTitle.copyWith(
            fontSize: 20.sp,
            shadows: [
              const Shadow(
                blurRadius: 15.0,
                color: Colors.black,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        centerTitle: true,
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'place_${place.id}',
              child: CachedNetworkImage(
                imageUrl: place.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: AppColors.primaryNavy,
                  highlightColor: AppColors.primaryDeep,
                  child: Container(color: AppColors.primaryNavy),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.primaryNavy,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.white24,
                    size: 50,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                    AppColors.primaryDark.withValues(alpha: 0.6),
                    AppColors.primaryDark,
                  ],
                  stops: const [0.0, 0.4, 0.8, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
