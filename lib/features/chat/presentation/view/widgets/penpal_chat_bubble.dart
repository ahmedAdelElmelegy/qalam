import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/features/chat/data/models/chat_message_model.dart';
import 'package:arabic/core/theme/colors.dart';

class PenpalChatBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isCorrecting;
  final VoidCallback onCorrectPressed;

  const PenpalChatBubble({
    super.key,
    required this.message,
    required this.isCorrecting,
    required this.onCorrectPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // Main Chat Bubble
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.primary
                    : const Color(0xFF1E293B), // Darker gray for AI
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 0),
                  bottomRight: Radius.circular(isUser ? 0 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      height: 1.4,
                    ),
                    // textDirection: TextDirection.rtl, // Ensure Arabic reads RTL
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    DateFormat('hh:mm a').format(message.timestamp),
                    style: TextStyle(color: Colors.white54, fontSize: 10.sp),
                  ),
                ],
              ),
            ),

            // Magic Wand Correction Button (Only for user messages)
            if (isUser) ...[
              SizedBox(height: 4.h),
              if (message.correctionText == null)
                GestureDetector(
                  onTap: isCorrecting ? null : onCorrectPressed,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isCorrecting)
                        SizedBox(
                          width: 12.w,
                          height: 12.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.accentGold,
                          ),
                        )
                      else
                        Icon(
                          Icons.auto_fix_high,
                          color: AppColors.accentGold,
                          size: 16.sp,
                        ),
                      SizedBox(width: 4.w),
                      Text(
                        'correct_me'
                            .tr(), // Needs to be added to translation files if missing, fallback: 'Correct Me'
                        style: TextStyle(
                          color: AppColors.accentGold,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

              // Grammar Correction Box (if available)
              if (message.correctionText != null)
                Container(
                  margin: EdgeInsets.only(top: 8.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.accentGold.withValues(alpha: 0.1),
                    border: Border.all(
                      color: AppColors.accentGold.withValues(alpha: 0.5),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: AppColors.accentGold,
                            size: 16.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Grammar Correction',
                            style: TextStyle(
                              color: AppColors.accentGold,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        message.correctionText!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          height: 1.4,
                        ),
                        // textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
