import 'dart:io';

import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/network/api_url/api_endpoints.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/utils/local_storage.dart';
import 'package:arabic/core/widgets/glass_container.dart';
import 'package:arabic/features/settings/presentation/manager/get%20profile/get_profile_cubit.dart';
import 'package:arabic/features/settings/presentation/view/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({super.key});

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  String? userName;
  String? userEmail;
  String? userImagePath;
  int? userId;
  @override
  void initState() {
    super.initState();
    _loadAndFetchData();
  }

  Future<void> _loadAndFetchData() async {
    await _loadUserData();
    if (mounted && userId != null && userId != 0) {
      context.read<GetProfileCubit>().getProfile(userId!);
    }
  }

  Future<void> _loadUserData() async {
    final name = await LocalStorage.getUserFullName();
    final email = await LocalStorage.getUserEmail();
    final imgPath = await LocalStorage.getUserProfileImage();
    int? emailId = await LocalStorage.getEmailId();
    if (mounted) {
      setState(() {
        userName = name ?? 'User Name';
        userEmail = email ?? 'user@example.com';

        userImagePath = imgPath;
        userId = emailId ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetProfileCubit, GetProfileState>(
      builder: (context, state) {
        if (state is GetProfileSuccess) {
          userName = state.profile.fullName;
          userEmail = state.profile.email;
          // Optionally update local storage here if needed, or just use the data
        }

        return GlassContainer(
          padding: EdgeInsets.all(20.w),
          borderRadius: BorderRadius.circular(24),
          child: Row(
            children: [
              _buildAvatar(state),
              SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName ?? 'User Name',
                      style: AppTextStyles.h3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      userEmail ?? 'user@example.com',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              if (state is GetProfileLoading)
                SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.accentGold,
                  ),
                )
              else
                IconButton(
                  onPressed: () async {
                    await context.push(const EditProfileScreen());
                    _loadAndFetchData(); // Reload data after returning from edit screen
                  },
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.accentGold,
                  ),
                ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1, end: 0);
      },
    );
  }

  Widget _buildAvatar(GetProfileState state) {
    String? displayImage;
    if (state is GetProfileSuccess) {
      displayImage =
          state.profile.image != null && state.profile.image!.isNotEmpty
          ? '${AppURL.imagePath}${state.profile.image}'
          : state.profile.imageFile;
    }

    return Container(
      width: 70.w,
      height: 70.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.goldGradient,
        image: _getImageProvider(displayImage),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGold.withValues(alpha: 0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child:
          (displayImage == null || displayImage.isEmpty) &&
              (userImagePath == null || userImagePath!.isEmpty)
          ? Center(
              child: Text(
                userName != null && userName!.isNotEmpty
                    ? userName![0].toUpperCase()
                    : 'U',
                style: AppTextStyles.displayMedium.copyWith(
                  color: Colors.black,
                  fontSize: 32.sp,
                ),
              ),
            )
          : null,
    );
  }

  DecorationImage? _getImageProvider(String? apiImage) {
    if (apiImage != null && apiImage.isNotEmpty) {
      if (apiImage.startsWith('http')) {
        return DecorationImage(
          image: NetworkImage(apiImage),
          fit: BoxFit.cover,
        );
      } else {
        return DecorationImage(
          image: FileImage(File(apiImage)),
          fit: BoxFit.cover,
        );
      }
    } else if (userImagePath != null && userImagePath!.isNotEmpty) {
      return DecorationImage(
        image: FileImage(File(userImagePath!)),
        fit: BoxFit.cover,
      );
    }
    return null;
  }
}
