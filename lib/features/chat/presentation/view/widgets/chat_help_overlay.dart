import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/chat/presentation/manager/chat_cubit.dart';
import 'package:arabic/features/chat/presentation/manager/chat_state.dart';

class ChatHelpOverlay extends StatelessWidget {
  const ChatHelpOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state is ChatLoaded && state.helpHints != null) {
          final help = state.helpHints!;
          return Positioned(
            bottom: 110.h,
            left: 24.w,
            right: 24.w,
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.5),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.lightbulb_outline_rounded,
                            color: Color(0xFFD4AF37),
                            size: 18,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Needs Help?',
                            style: TextStyle(
                              color: const Color(0xFFD4AF37),
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  if (help['hint1'] != null)
                    _buildHelpTab('Hint', help['hint1']),
                  if (help['hint2'] != null)
                    _buildHelpTab('Structure', help['hint2']),
                  if (help['full_answer'] != null)
                    _buildHelpTab('Answer', help['full_answer']),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.1, end: 0),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildHelpTab(String label, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white38,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            content,
            style: AppTextStyles.arabicBody.copyWith(
              color: Colors.white,
              fontSize: 13.sp,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}
