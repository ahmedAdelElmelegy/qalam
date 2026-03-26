import 'dart:ui' as ui;

import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JournyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const JournyAppBar({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.all(8.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: BackButton(
                color: AppColors.accentGold,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
      ),
      title: Text(title, style: AppTextStyles.h2.copyWith(color: Colors.white)),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
