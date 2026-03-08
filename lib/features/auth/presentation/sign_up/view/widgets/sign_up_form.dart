import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/helpers/show_snake_bar.dart';
import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/core/validator/validator.dart';
import 'package:arabic/core/widgets/glass_container.dart';
import 'package:arabic/core/widgets/premium_btn.dart';
import 'package:arabic/features/auth/data/model/body/sign_up_request_body.dart';
import 'package:arabic/features/auth/presentation/manager/auth/auth_cubit.dart';
import 'package:arabic/features/auth/presentation/sign_in/view/screens/sign_in.dart';
import 'package:arabic/features/auth/presentation/sign_in/view/widgets/glass_text_field.dart';
import 'package:arabic/features/auth/presentation/sign_up/view/widgets/language_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:easy_localization/easy_localization.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();
  final countryController = TextEditingController();
  final goalController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int? selectedLanguageId;
  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    ageController.dispose();
    countryController.dispose();
    goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
          padding: EdgeInsets.all(24.w),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is SignUpSuccess) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  AppSnakeBar.showSuccessMessage(context, state.message);
                  context.push(const SignInScreen());
                });
              } else if (state is SignUpError) {
                AppSnakeBar.showErrorMessage(
                  context,
                  ApiErrorHandler.getUserMessage(state.exception),
                );
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Staggered field animations
                    ..._buildAnimatedFields(),

                    SizedBox(height: 24.h),

                    // Submit Button
                    PremiumButton(
                          text: 'create_account'.tr(),
                          isLoading: state is SignUpLoading,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthCubit>().register(
                                requestBody: SignUpRequestBody(
                                  fullName: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  nativeLanguageId: selectedLanguageId ?? 1,
                                  country: countryController.text,
                                  learningGoal: goalController.text,
                                  age: int.tryParse(ageController.text) ?? 0,
                                  imageFile: null, // Optional image file
                                ),
                              );
                            }
                          },
                        )
                        .animate()
                        .fadeIn(delay: 900.ms, duration: 400.ms)
                        .scale(
                          begin: const Offset(0.9, 0.9),
                          curve: Curves.easeOutBack,
                        ),
                  ],
                ),
              );
            },
          ),
        )
        .animate()
        .fadeIn(delay: 300.ms, duration: 500.ms)
        .slideY(begin: 0.2, end: 0);
  }

  List<Widget> _buildAnimatedFields() {
    final fields = [
      GlassTextField(
        controller: nameController,
        hintText: 'full_name'.tr(),
        prefixIcon: Icons.person_outline,
        validator: (value) =>
            Validation.requiredField(value, message: 'full_name'.tr()),
      ),
      GlassTextField(
        controller: emailController,
        hintText: 'email_address'.tr(),
        prefixIcon: Icons.email_outlined,
        keyboardType: TextInputType.emailAddress,
        validator: (value) =>
            Validation.emailField(value, message: 'email_address'.tr()),
      ),
      GlassTextField(
        controller: passwordController,
        hintText: 'password'.tr(),
        isPassword: true,
        prefixIcon: Icons.lock_outline,

        validator: (value) => Validation.passwordField(value),
      ),
      LanguageDropdown(
        onChanged: (langId) {
          setState(() {
            selectedLanguageId = langId;
          });
        },
      ),

      GlassTextField(
        controller: ageController,
        hintText: 'age'.tr(),
        prefixIcon: Icons.calendar_today_outlined,
        keyboardType: TextInputType.number,
        validator: (value) =>
            Validation.requiredField(value, message: 'age'.tr()),
      ),
      GlassTextField(
        controller: countryController,
        hintText: 'country'.tr(),
        prefixIcon: Icons.public,
        validator: (value) =>
            Validation.requiredField(value, message: 'country'.tr()),
      ),
      GlassTextField(
        controller: goalController,
        hintText: 'learning_goal'.tr(),
        prefixIcon: Icons.flag_outlined,
        maxLines: 2,
        validator: (value) =>
            Validation.requiredField(value, message: 'learning_goal'.tr()),
      ),
    ];

    return fields
        .asMap()
        .entries
        .map(
          (entry) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: entry.value
                .animate()
                .fadeIn(delay: (400 + entry.key * 100).ms, duration: 400.ms)
                .slideX(begin: -0.2, end: 0),
          ),
        )
        .toList();
  }
}
