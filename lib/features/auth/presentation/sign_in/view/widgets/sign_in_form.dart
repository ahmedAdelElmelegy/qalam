import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/helpers/show_snake_bar.dart';
import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/validator/validator.dart';
import 'package:arabic/core/utils/local_storage.dart';
import 'package:arabic/core/widgets/glass_container.dart';
import 'package:arabic/core/widgets/premium_btn.dart';
import 'package:arabic/features/auth/data/model/body/sign_in_request_body.dart';
import 'package:arabic/features/auth/presentation/manager/auth/auth_cubit.dart';
import 'package:arabic/features/auth/presentation/sign_in/view/widgets/glass_text_field.dart';
import 'package:arabic/features/home/presentation/view/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:easy_localization/easy_localization.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GlassContainer(
              padding: EdgeInsets.all(24.w),
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthAuthenticated) {
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      // Get the language saved in AuthCubit
                      final savedLang = await LocalStorage.getLanguage();
                      if (context.mounted && savedLang != null) {
                        await context.setLocale(Locale(savedLang));
                      }
                      if (context.mounted) {
                        context.pushAndRemoveUntil(HomeScreen());
                      }
                    });
                  } else if (state is AuthError) {
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
                        // Email Field
                        GlassTextField(
                              controller: emailController,
                              hintText: 'email_address'.tr(),
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) =>
                                  Validation.emailField(value),
                            )
                            .animate()
                            .fadeIn(delay: 400.ms, duration: 400.ms)
                            .slideX(begin: -0.2, end: 0),

                        SizedBox(height: 16.h),

                        // Password Field
                        GlassTextField(
                              controller: passwordController,
                              hintText: 'password'.tr(),
                              prefixIcon: Icons.lock_outline,
                              isPassword: true,
                              validator: (value) => Validation.requiredField(
                                value,
                                message: 'password'.tr(),
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 500.ms, duration: 400.ms)
                            .slideX(begin: -0.2, end: 0),

                        SizedBox(height: 12.h),

                        // Forgot Password
                        Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'forgot_password'.tr(),
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.accentGold,
                                  ),
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 600.ms, duration: 400.ms)
                            .slideX(begin: 0.2, end: 0),

                        SizedBox(height: 24.h),

                        // Login Button
                        PremiumButton(
                          text: 'sign_in'.tr(),
                          isLoading: state is AuthLoading,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthCubit>().login(
                                requestBody: SignInRequestBody(
                                  email: emailController.text,
                                  password: passwordController.text,
                                ),
                              );
                            }
                          },
                        )
                        .animate()
                        .fadeIn(delay: 700.ms, duration: 400.ms)
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
            .slideY(begin: 0.2, end: 0),
      ],
    );
  }
}
