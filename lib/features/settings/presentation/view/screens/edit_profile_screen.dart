import 'package:arabic/core/helpers/show_snake_bar.dart';
import 'package:arabic/core/network/api_url/api_endpoints.dart';
import 'package:arabic/features/settings/presentation/manager/get%20profile/get_profile_cubit.dart';
import 'package:arabic/features/settings/presentation/manager/update%20profile/update_profile_cubit.dart';
import 'package:arabic/features/settings/data/model/edit_profile_request_body.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:io';
import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/utils/local_storage.dart';
import 'package:arabic/core/widgets/glass_container.dart';
import 'package:arabic/core/widgets/premium_btn.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  late TextEditingController _countryController;
  late TextEditingController _goalController;

  File? _imageFile;
  String? _imagePath;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  int _nativeLanguageId = 1; // Default

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _ageController = TextEditingController();
    _countryController = TextEditingController();
    _goalController = TextEditingController();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final cubit = context.read<GetProfileCubit>();
    final userId = await LocalStorage.getEmailId();

    // Proactively fetch from API - Form will be populated via BlocListener
    if (userId != null && userId != 0) {
      cubit.getProfile(userId);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _countryController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _imagePath = pickedFile.path;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = await LocalStorage.getEmailId();
    if (userId == null || userId == 0) return;

    final requestBody = EditProfileRequestBody(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      nativeLanguageId: _nativeLanguageId,
      learningGoal: _goalController.text.trim(),
      country: _countryController.text.trim(),
      age: int.tryParse(_ageController.text.trim()) ?? 0,
      imageFile: _imageFile,
    );

    if (mounted) {
      context.read<UpdateProfileCubit>().updateProfile(
        requestBody: requestBody,
        emailId: userId,
      );
    }
    await LocalStorage.saveUserFullName(_nameController.text.trim());
    await LocalStorage.saveUserAge(
      int.tryParse(_ageController.text.trim()) ?? 0,
    );
    await LocalStorage.saveUserCountry(_countryController.text.trim());
    await LocalStorage.saveUserLearningGoal(_goalController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetProfileCubit, GetProfileState>(
      listener: (context, state) {
        if (state is GetProfileSuccess) {
          _nameController.text = state.profile.fullName;
          _emailController.text = state.profile.email;
          _ageController.text = state.profile.age.toString();
          _countryController.text = state.profile.country;
          _goalController.text = state.profile.learningGoal;
          _nativeLanguageId = state.profile.nativeLanguageId;
          _imagePath =
              state.profile.image != null && state.profile.image!.isNotEmpty
              ? '${AppURL.imagePath}${state.profile.image}'
              : state.profile.imageFile;
          if (_imagePath != null &&
              _imagePath!.isNotEmpty &&
              !_imagePath!.startsWith('http')) {
            setState(() {
              _imageFile = File(_imagePath!);
            });
          }
        }
      },
      child: BlocListener<UpdateProfileCubit, UpdateProfileState>(
        listener: (context, state) {
          if (state is UpdateProfileLoading) {
            setState(() => _isLoading = true);
          } else if (state is UpdateProfileSuccess) {
            setState(() => _isLoading = false);
            AppSnakeBar.showSuccessMessage(context, 'profile_updated'.tr());

            // Refresh GetProfileCubit to update Home screen and other listeners
            LocalStorage.getEmailId().then((userId) {
              if (userId != null && userId != 0 && context.mounted) {
                context.read<GetProfileCubit>().clearProfile();
                context.read<GetProfileCubit>().getProfile(userId);
              }
            });

            context.pop();
          } else if (state is UpdateProfileFailure) {
            setState(() => _isLoading = false);

            AppSnakeBar.showErrorMessage(context, state.message);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.primaryDark,
          body: Stack(
            children: [
              // Background Orbs
              _buildBackgroundOrb(
                top: -100,
                left: -50,
                color: AppColors.accentGold,
                size: 350,
                delay: 0,
                right: null,
                bottom: null,
              ),
              _buildBackgroundOrb(
                bottom: -150,
                right: -100,
                color: AppColors.primaryDeep,
                size: 400,
                delay: 400,
                left: null,
                top: null,
              ),
              _buildBackgroundOrb(
                top: MediaQuery.of(context).size.height * 0.4,
                left: -80,
                color: AppColors.accentGold.withValues(alpha: 0.3),
                size: 200,
                delay: 800,
                right: null,
                bottom: null,
              ),
              SafeArea(
                child: BlocBuilder<GetProfileCubit, GetProfileState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        // AppBar
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 16.h,
                          ),
                          child: Row(
                            children: [
                              BackButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    AppColors.accentGold.withValues(alpha: 0.1),
                                  ),
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  padding: WidgetStatePropertyAll(
                                    EdgeInsets.all(12.w),
                                  ),
                                ),
                                color: AppColors.accentGold,
                                onPressed: () => context.pop(),
                              ).animate().fadeIn().slideX(begin: -0.2, end: 0),
                              SizedBox(width: 16.w),
                              Text(
                                    'edit_profile'.tr(),
                                    style: AppTextStyles.h2.copyWith(
                                      color: Colors.white,
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(delay: 100.ms)
                                  .slideX(begin: 0.2, end: 0),
                              const Spacer(),
                              if (state is GetProfileLoading)
                                SizedBox(
                                  width: 20.w,
                                  height: 20.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.accentGold,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.all(24.w),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  // Avatar Edit Section
                                  Center(
                                    child: GestureDetector(
                                      onTap: _pickImage,
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
                                                  color: AppColors.accentGold
                                                      .withValues(alpha: 0.2),
                                                  blurRadius: 20,
                                                  spreadRadius: 5,
                                                ),
                                              ],
                                              image: _imageFile != null
                                                  ? DecorationImage(
                                                      image: FileImage(
                                                        _imageFile!,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : (_imagePath != null &&
                                                            _imagePath!
                                                                .startsWith(
                                                                  'http',
                                                                )
                                                        ? DecorationImage(
                                                            image: NetworkImage(
                                                              _imagePath!,
                                                            ),
                                                            fit: BoxFit.cover,
                                                          )
                                                        : null),
                                              color: AppColors.primaryDeep,
                                            ),
                                            child:
                                                (_imageFile == null &&
                                                    (_imagePath == null ||
                                                        !_imagePath!.startsWith(
                                                          'http',
                                                        )))
                                                ? Center(
                                                    child: Icon(
                                                      Icons.person_rounded,
                                                      size: 60.w,
                                                      color: AppColors
                                                          .accentGold
                                                          .withValues(
                                                            alpha: 0.5,
                                                          ),
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
                                  ).animate().fadeIn().scale(),

                                  SizedBox(height: 40.h),

                                  // Fields
                                  _buildTextField(
                                    controller: _nameController,
                                    label: 'full_name'.tr(),
                                    icon: Icons.person_outline_rounded,
                                    validator: (v) => v!.isEmpty
                                        ? 'name_required'.tr()
                                        : null,
                                    delay: 200,
                                  ),
                                  SizedBox(height: 16.h),

                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: _buildTextField(
                                          controller: _ageController,
                                          label: 'age'.tr(),
                                          icon: Icons.calendar_today_outlined,
                                          keyboardType: TextInputType.number,
                                          delay: 400,
                                        ),
                                      ),
                                      SizedBox(width: 16.w),
                                      Expanded(
                                        flex: 3,
                                        child: _buildTextField(
                                          controller: _countryController,
                                          label: 'country'.tr(),
                                          icon: Icons.public_rounded,
                                          delay: 500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  _buildTextField(
                                    controller: _goalController,
                                    label: 'learning_goal'.tr(),
                                    icon: Icons.flag_outlined,
                                    maxLines: 2,
                                    delay: 600,
                                  ),

                                  SizedBox(height: 48.h),

                                  PremiumButton(
                                        text: 'save_changes'.tr(),
                                        isLoading: _isLoading,
                                        onPressed: _saveChanges,
                                      )
                                      .animate()
                                      .fadeIn(delay: 800.ms)
                                      .slideY(begin: 0.2, end: 0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
    required int delay,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            label,
            style: AppTextStyles.overline.copyWith(
              color: AppColors.accentGold.withValues(alpha: 0.8),
              letterSpacing: 1.5,
            ),
          ),
        ),
        GlassContainer(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
          child: TextFormField(
            controller: controller,
            cursorColor: AppColors.accentGold,
            keyboardType: keyboardType,
            validator: validator,
            maxLines: maxLines,
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white,
              fontSize: 15.sp,
            ),
            decoration: InputDecoration(
              icon: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.accentGold, size: 20.w),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorStyle: TextStyle(
                color: Colors.redAccent.withValues(alpha: 0.8),
                fontSize: 12.sp,
              ),
              hintText: label,
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: delay.ms).slideX(begin: -0.05, end: 0);
  }

  Widget _buildBackgroundOrb({
    required double? top,
    required double? left,
    required double? right,
    required double? bottom,
    required Color color,
    required double size,
    required int delay,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child:
          Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.1),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.2),
                      blurRadius: size / 2,
                      spreadRadius: size / 4,
                    ),
                  ],
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .fadeIn(delay: delay.ms, duration: 2.seconds)
              .scale()
              .moveY(
                begin: 0,
                end: 20,
                duration: 4.seconds,
                curve: Curves.easeInOutSine,
              ),
    );
  }
}
