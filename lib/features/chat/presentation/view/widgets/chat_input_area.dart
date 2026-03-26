import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arabic/features/chat/presentation/manager/chat_cubit.dart';

class ChatInputArea extends StatelessWidget {
  final TextEditingController controller;

  const ChatInputArea({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E).withValues(alpha: 0.5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Type in Arabic...',
                  hintStyle: TextStyle(color: Colors.white30),
                  border: InputBorder.none,
                ),
                onSubmitted: (val) {
                  if (val.trim().isNotEmpty) {
                    context.read<ChatCubit>().sendMessage(val.trim());
                    controller.clear();
                  }
                },
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: () {
              if (controller.text.trim().isNotEmpty) {
                context.read<ChatCubit>().sendMessage(controller.text.trim());
                controller.clear();
              }
            },
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: const BoxDecoration(
                color: Color(0xFFD4AF37),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
