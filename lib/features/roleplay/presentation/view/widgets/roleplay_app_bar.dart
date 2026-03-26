import 'package:arabic/core/theme/style.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoleplayAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onLeadingPressed;
  final Color shadowColor;

  const RoleplayAppBar({
    super.key,
    required this.onLeadingPressed,
    this.shadowColor = const Color(0xFF10B981),
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'voice_roleplay_title'.tr(),
        style: AppTextStyles.h3.copyWith(
          color: Colors.white,
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: shadowColor.withValues(alpha: 0.5),
              blurRadius: 10,
            ),
          ],
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        onPressed: onLeadingPressed,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
