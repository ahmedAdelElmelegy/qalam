import 'package:arabic/core/helpers/show_snake_bar.dart';
import 'package:arabic/core/network/api_url/api_endpoints.dart';
import 'package:arabic/features/settings/presentation/manager/get%20profile/get_profile_cubit.dart';
import 'package:arabic/features/settings/presentation/manager/update%20profile/update_profile_cubit.dart';
import 'package:arabic/features/settings/data/model/edit_profile_request_body.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:io';
import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/utils/local_storage.dart';
import 'package:arabic/core/widgets/premium_btn.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/profile_text_field.dart';
import '../widgets/profile_background_orb.dart';
import '../widgets/profile_avatar_picker.dart';
import '../widgets/profile_header.dart';

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
              ProfileBackgroundOrb(
                top: -100,
                left: -50,
                color: AppColors.accentGold,
                size: 350,
                delay: 0,
              ),
              ProfileBackgroundOrb(
                bottom: -150,
                right: -100,
                color: AppColors.primaryDeep,
                size: 400,
                delay: 400,
              ),
              ProfileBackgroundOrb(
                top: MediaQuery.of(context).size.height * 0.4,
                left: -80,
                color: AppColors.accentGold.withValues(alpha: 0.3),
                size: 200,
                delay: 800,
              ),
              SafeArea(
                child: BlocBuilder<GetProfileCubit, GetProfileState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        // AppBar
                        ProfileHeader(isLoading: state is GetProfileLoading),

                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.all(24.w),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  // Avatar Edit Section
                                  ProfileAvatarPicker(
                                    imageFile: _imageFile,
                                    imagePath: _imagePath,
                                    onPickImage: _pickImage,
                                  ),

                                  SizedBox(height: 40.h),

                                  // Fields
                                  ProfileTextField(
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
                                        child: ProfileTextField(
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
                                        child: ProfileTextField(
                                          controller: _countryController,
                                          label: 'country'.tr(),
                                          icon: Icons.public_rounded,
                                          delay: 500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  ProfileTextField(
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
}
