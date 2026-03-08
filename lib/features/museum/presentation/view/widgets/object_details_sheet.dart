import 'package:easy_localization/easy_localization.dart';
import 'dart:ui';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/museum_object_model.dart';

class ObjectDetailsSheet extends StatelessWidget {
  final MuseumObjectModel object;
  final VoidCallback onPlayArabic;
  final VoidCallback onPlayEnglish;

  const ObjectDetailsSheet({
    super.key,
    required this.object,
    required this.onPlayArabic,
    required this.onPlayEnglish,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.primaryNavy.withValues(alpha: 0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Thumbnail
                    Hero(
                      tag: 'obj_${object.id}',
                      child: Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.accentGold.withValues(alpha: 0.3),
                          ),
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                        child: object.imageUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: object.imageUrl.startsWith('http')
                                    ? CachedNetworkImage(
                                        imageUrl: object.imageUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.accentGold,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(
                                          Icons.broken_image,
                                          color: Colors.white24,
                                          size: 40.w,
                                        ),
                                      )
                                    : Image.asset(
                                        object.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(
                                          Icons.broken_image,
                                          color: Colors.white24,
                                          size: 40.w,
                                        ),
                                      ),
                              )
                            : Center(
                                child: Icon(
                                  _getIconData(object.icon),
                                  color: AppColors.accentGold,
                                  size: 50.w,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    // Names
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            object.arabicName,
                            style: AppTextStyles.h3.copyWith(
                              fontSize: 32.sp,
                              color: AppColors.accentGold,
                            ),
                          ),
                          Text(
                            object.pronunciation,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white54,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            object.localizedTranslations[context.locale.languageCode] ?? 
                            object.englishTranslation,
                            style: AppTextStyles.h3.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 32.h),

                // Sentences
                _buildSentenceCard(
                  title: 'arabic_label'.tr(),
                  content: object.arabicSentence,
                  isArabic: true,
                  onPlay: onPlayArabic,
                  color: AppColors.accentGold,
                ).animate().fadeIn(delay: 200.ms).slideX(),

                SizedBox(height: 16.h),

                _buildSentenceCard(
                  title: context.locale.languageCode.toUpperCase(),
                  content: object.localizedSentences[context.locale.languageCode] ?? 
                           object.englishSentence,
                  isArabic: false,
                  onPlay: onPlayEnglish,
                  color: Colors.white,
                ).animate().fadeIn(delay: 400.ms).slideX(),


                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSentenceCard({
    required String title,
    required String content,
    required bool isArabic,
    required VoidCallback onPlay,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.bodySmall.copyWith(
                  color: color.withValues(alpha: 0.6),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              IconButton(
                onPressed: onPlay,
                icon: Icon(Icons.volume_up_rounded, color: color, size: 24.w),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            content,
            style: AppTextStyles.bodyLarge.copyWith(
              color: color.withValues(alpha: 0.9),
              fontSize: isArabic ? 22.sp : 18.sp,
              height: 1.5,
            ),
            // textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'restaurant_menu':
        return Icons.restaurant_menu;
      case 'book':
        return Icons.book;
      case 'menu_book':
        return Icons.menu_book;
      case 'camera':
      case 'camera_alt':
        return Icons.camera_alt;
      case 'headphones':
        return Icons.headphones;
      case 'local_cafe':
      case 'coffee':
        return Icons.coffee;
      case 'restaurant':
        return Icons.restaurant;
      case 'local_library':
        return Icons.local_library;
      case 'store':
      case 'storefront':
        return Icons.storefront;
      case 'park':
        return Icons.park;
      case 'mosque':
        return Icons.mosque;
      case 'edit':
        return Icons.edit;
      case 'person':
        return Icons.person;
      case 'person_search':
        return Icons.person_search;
      case 'train':
        return Icons.train;
      case 'confirmation_number':
        return Icons.confirmation_number;
      case 'signpost':
        return Icons.signpost;
      case 'luggage':
        return Icons.luggage;
      case 'schedule':
        return Icons.schedule;
      case 'change_history':
        return Icons.change_history;
      case 'face':
        return Icons.face;
      case 'king_bed':
        return Icons.king_bed;
      case 'landscape':
        return Icons.landscape;
      case 'tv':
        return Icons.tv;
      case 'water_drop':
        return Icons.water_drop;
      case 'chair':
        return Icons.chair;
      case 'soup_kitchen':
        return Icons.soup_kitchen;
      case 'local_grocery_store':
        return Icons.local_grocery_store;
      case 'attach_money':
        return Icons.attach_money;
      case 'help_outline':
        return Icons.help_outline;
      default:
        return Icons.touch_app; // Default icon
    }
  }
}
