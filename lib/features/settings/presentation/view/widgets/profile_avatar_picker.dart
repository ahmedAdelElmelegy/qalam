import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:arabic/core/theme/colors.dart';

class ProfileAvatarPicker extends StatelessWidget {
  final File? imageFile;
  final String? imagePath;
  final VoidCallback onPickImage;

  const ProfileAvatarPicker({
    super.key,
    required this.imageFile,
    required this.imagePath,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onPickImage,
        child: Stack(
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accentGold,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentGold.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
                image: imageFile != null
                    ? DecorationImage(
                        image: FileImage(imageFile!),
                        fit: BoxFit.cover,
                      )
                    : (imagePath != null && imagePath!.startsWith('http')
                        ? DecorationImage(
                            image: NetworkImage(imagePath!),
                            fit: BoxFit.cover,
                          )
                        : null),
                color: AppColors.primaryDeep,
              ),
              child: (imageFile == null &&
                      (imagePath == null || !imagePath!.startsWith('http')))
                  ? Center(
                      child: Icon(
                        Icons.person_rounded,
                        size: 60.w,
                        color: AppColors.accentGold.withValues(alpha: 0.5),
                      ),
                    )
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.accentGold,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryDeep,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().scale();
  }
}
