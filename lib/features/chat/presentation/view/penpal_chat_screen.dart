import 'package:arabic/core/utils/network_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/features/chat/presentation/manager/penpal_cubit.dart';
import 'package:arabic/features/chat/presentation/manager/penpal_state.dart';
import 'package:arabic/features/chat/presentation/view/widgets/penpal_chat_bubble.dart';
import 'package:arabic/features/chat/presentation/view/widgets/chat_drawer.dart';
import 'package:arabic/core/theme/colors.dart';

class PenpalChatScreen extends StatelessWidget {
  const PenpalChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PenpalChatView();
  }
}

class _PenpalChatView extends StatefulWidget {
  const _PenpalChatView();

  @override
  State<_PenpalChatView> createState() => _PenpalChatViewState();
}

class _PenpalChatViewState extends State<_PenpalChatView>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _drawerController;

  @override
  void initState() {
    super.initState();
    _drawerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _textController.text;
    if (text.trim().isNotEmpty) {
      final String langCode = context.locale.languageCode;
      String language = 'Arabic';
      switch (langCode) {
        case 'en':
          language = 'English';
          break;
        case 'de':
          language = 'German';
          break;
        case 'fr':
          language = 'French';
          break;
        case 'ru':
          language = 'Russian';
          break;
        case 'zh':
          language = 'Chinese';
          break;
        default:
          language = 'Arabic';
      }

      context.read<PenpalCubit>().sendMessage(text, language: language);
      _textController.clear();
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _drawerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final drawerWidth = 280.w;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          // The Drawer is ALWAYS in the background stack
          const ChatDrawer(),

          // Main Content with 3D Transformation
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              final delta = details.primaryDelta! / drawerWidth;
              if (isArabic) {
                _drawerController.value -= delta;
              } else {
                _drawerController.value += delta;
              }
            },
            onHorizontalDragEnd: (details) {
              if (_drawerController.value > 0.5) {
                _drawerController.forward();
              } else {
                _drawerController.reverse();
              }
            },
            child: AnimatedBuilder(
              animation: _drawerController,
              builder: (context, child) {
                final double slide = _drawerController.value * drawerWidth;
                final double scale = 1 - (_drawerController.value * 0.15);
                final double radius = _drawerController.value * 32.r;
                final double rotation =
                    _drawerController.value * -0.1; // Subtle 3D tilt

                return Transform(
                  transform: Matrix4.identity()
                    ..translate(isArabic ? -slide : slide)
                    ..scale(scale)
                    ..rotateY(isArabic ? -rotation : rotation),
                  alignment: isArabic
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: 0.5 * _drawerController.value,
                          ),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(radius),
                      child: child,
                    ),
                  ),
                );
              },
              child: Scaffold(
                backgroundColor: const Color(
                  0xFF0F172A,
                ), // Dark slate background
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  leading: IconButton(
                    icon: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    onPressed: () {
                      if (_drawerController.value > 0.5) {
                        _drawerController.reverse();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  title: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.2,
                        ),
                        child: const Text('🤖', style: TextStyle(fontSize: 20)),
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'chat_buddy_title'.tr(),
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'chat_buddy_subtitle'.tr(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.accentGold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
                body: BlocListener<PenpalCubit, PenpalState>(
                  listenWhen: (prev, current) =>
                      !prev.isNetworkError && current.isNetworkError,
                  listener: (context, state) {
                    NetworkChecker.showNoNetworkDialog(context);
                  },
                  child: Stack(
                    children: [
                      // Background subtle gradient
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: const Alignment(0.5, -0.3),
                              radius: 1.0,
                              colors: [
                                AppColors.primary.withValues(alpha: 0.05),
                                const Color(0xFF0F172A),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Column(
                          children: [
                            // Error Banner
                            BlocBuilder<PenpalCubit, PenpalState>(
                              buildWhen: (prev, current) =>
                                  prev.error != current.error,
                              builder: (context, state) {
                                if (state.error == null) {
                                  return const SizedBox.shrink();
                                }
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 8.h,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 12.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent.withValues(
                                      alpha: 0.9,
                                    ),
                                    borderRadius: BorderRadius.circular(12.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.2,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.error_outline_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Text(
                                          state.error!.tr(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.close_rounded,
                                          color: Colors.white70,
                                          size: 20,
                                        ),
                                        onPressed: () => context
                                            .read<PenpalCubit>()
                                            .clearError(),
                                        constraints: const BoxConstraints(),
                                        padding: EdgeInsets.zero,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                            // Chat Messages List
                            Expanded(
                              child: BlocBuilder<PenpalCubit, PenpalState>(
                                builder: (context, state) {
                                  final activeMessages =
                                      state.activeSession?.messages ?? [];

                                  return ListView.builder(
                                    controller: _scrollController,
                                    reverse: true, // Start from bottom
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16.h,
                                    ),
                                    itemCount:
                                        activeMessages.length +
                                        (state.isAiTyping ? 1 : 0),
                                    itemBuilder: (context, index) {
                                      if (state.isAiTyping && index == 0) {
                                        return _buildTypingIndicator();
                                      }
                                      final msgIndex = state.isAiTyping
                                          ? index - 1
                                          : index;
                                      final message =
                                          activeMessages[activeMessages.length -
                                              1 -
                                              msgIndex];

                                      return PenpalChatBubble(
                                        message: message,
                                        isCorrecting:
                                            state.correctingMessageId ==
                                            message.id,
                                        onCorrectPressed: () {
                                          context
                                              .read<PenpalCubit>()
                                              .correctMessage(message.id);
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),

                            // Message Input Area
                            _buildMessageInput(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: const BoxDecoration(
          color: Color(0xFF1E293B),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 12.w,
              height: 12.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white54,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'typing'.tr().isNotEmpty && 'typing'.tr() != 'typing'
                  ? 'typing'.tr()
                  : 'Typing...',
              style: TextStyle(color: Colors.white54, fontSize: 12.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.9),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: TextField(
                controller: _textController,
                style: const TextStyle(
                  color: Colors.white,
                  locale: Locale('ar'),
                ),
                decoration: InputDecoration(
                  hintText: 'chat_type_hint'.tr(),
                  hintStyle: TextStyle(color: Colors.white30, fontSize: 14.sp),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
