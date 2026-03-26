import 'package:arabic/core/utils/network_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/features/chat/presentation/manager/penpal_cubit.dart';
import 'package:arabic/features/chat/presentation/manager/penpal_state.dart';
import 'package:arabic/features/chat/presentation/view/widgets/penpal_chat_bubble.dart';
import 'package:arabic/features/chat/presentation/view/widgets/chat_drawer.dart';
import 'package:arabic/features/chat/presentation/view/widgets/penpal_app_bar.dart';
import 'package:arabic/features/chat/presentation/view/widgets/penpal_error_banner.dart';
import 'package:arabic/features/chat/presentation/view/widgets/penpal_typing_indicator.dart';
import 'package:arabic/features/chat/presentation/view/widgets/penpal_message_input.dart';
import 'package:arabic/core/theme/colors.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

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
                    ..setTranslationRaw(isArabic ? -slide : slide, 0.0, 0.0)
                    ..multiply(Matrix4.diagonal3Values(scale, scale, 1.0))
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
                appBar: PenpalAppBar(
                  onLeadingPressed: () {
                    if (_drawerController.value > 0.5) {
                      _drawerController.reverse();
                    } else {
                      Navigator.pop(context);
                    }
                  },
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
                            const PenpalErrorBanner(),

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
                                        return const PenpalTypingIndicator();
                                      }
                                      final msgIndex = state.isAiTyping
                                          ? index - 1
                                          : index;
                                      final message =
                                          activeMessages[activeMessages.length -
                                              1 -
                                              msgIndex];

                                      return PenpalChatBubble(message: message);
                                    },
                                  );
                                },
                              ),
                            ),

                            // Message Input Area
                            PenpalMessageInput(
                              textController: _textController,
                              onSendMessage: _sendMessage,
                            ),
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
}
