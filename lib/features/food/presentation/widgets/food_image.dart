import 'package:arabic/core/theme/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class FoodImage extends StatelessWidget {
  final String imagePath;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const FoodImage({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the image path is a URL
    final bool isNetworkImage =
        imagePath.startsWith('http') || imagePath.startsWith('https');

    Widget imageWidget;

    if (isNetworkImage) {
      imageWidget = CachedNetworkImage(
        imageUrl: imagePath,
        fit: fit,
        width: width,
        height: height,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: AppColors.primaryNavy,
          highlightColor: AppColors.primaryNavy.withValues(alpha: 0.5),
          child: Container(width: width, height: height, color: Colors.black),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: AppColors.primaryNavy,
          child: Center(
            child: Icon(
              Icons.broken_image_rounded,
              color: AppColors.accentGold,
              size: 24.w,
            ),
          ),
        ),
      );
    } else {
      imageWidget = Image.asset(
        imagePath,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: AppColors.primaryNavy,
          child: Center(
            child: Icon(
              Icons.image_not_supported_rounded,
              color: AppColors.accentGold,
              size: 24.w,
            ),
          ),
        ),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    return imageWidget;
  }
}
