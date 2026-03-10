import 'dart:ui';
import 'package:arabic/features/chat/presentation/manager/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:arabic/core/services/tts_service.dart';
import 'package:arabic/features/chat/presentation/manager/chat_state.dart';
import 'package:arabic/features/chat/data/models/chat_model.dart';
import 'package:arabic/features/chat/presentation/view/screens/my_words_screen.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:arabic/features/home/presentation/view/widgets/home_bg.dart';
import 'package:arabic/core/theme/style.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TtsService _ttsService = TtsService();

  @override
  void initState() {
    super.initState();
    _initTts();
    context.read<ChatCubit>().initChat();
  }

  Future<void> _initTts() async {
    try {
      await _ttsService.initialize();
      await _ttsService.updateSpeed(0.5);
    } catch (e) {
      debugPrint("TTS Initialization error: $e");
    }
  }

  Future<void> _speak(String text) async {
    if (text.isEmpty) return;
    await _ttsService.speak(text, language: "ar-SA");
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: Background3D()),
          HomeBackground(
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildToolsRow(),
                  BlocBuilder<ChatCubit, ChatState>(
                    builder: (context, state) {
                      if (state is ChatLoaded && state.errorMessage != null) {
                        return _buildErrorBanner(state.errorMessage!);
                      }
                      return const SizedBox();
                    },
                  ),
                  Expanded(child: _buildMessageList()),
                  _buildInputArea(),
                ],
              ),
            ),
          ),
          _buildHelpOverlay(),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(String error) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.redAccent,
            size: 20,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              error,
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white54, size: 16),
            onPressed: () {
              // We need a way to clear the error, maybe a cubit method?
              // For now, let's just show it.
            },
          ),
        ],
      ),
    ).animate().shake();
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'AI Arabic Tutor',
                  style: AppTextStyles.h4.copyWith(color: Colors.white),
                ),
                BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    if (state is ChatLoaded && state.activeScenario != null) {
                      return Text(
                        'Scenario: ${state.activeScenario!.title}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: const Color(0xFFD4AF37),
                        ),
                      );
                    }
                    return Text(
                      'Ready to chat',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white70,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          _buildVocabButton(),
        ],
      ),
    );
  }

  Widget _buildVocabButton() {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final count = (state is ChatLoaded) ? state.myWords.length : 0;
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyWordsScreen()),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFFD4AF37),
                  size: 16,
                ),
                SizedBox(width: 4.w),
                Text(
                  '$count',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildToolsRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          SizedBox(width: 8.w),
          _buildToolChip(
            label: 'Scenarios',
            isActive: false,
            onTap: _showScenarioSelector,
            icon: Icons.theater_comedy_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildToolChip({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFFD4AF37).withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isActive ? const Color(0xFFD4AF37) : Colors.white12,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFFD4AF37) : Colors.white70,
              size: 16,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                color: isActive ? const Color(0xFFD4AF37) : Colors.white70,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
          );
        }
        if (state is ChatLoaded) {
          _scrollToBottom();
          return ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.all(16.w),
            itemCount: state.messages.length + (state.isSending ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.messages.length) {
                return _buildTypingIndicator();
              }
              return _buildMessageBubble(state.messages[index]);
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.role == MessageRole.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child:
          Column(
            crossAxisAlignment: isUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 0.75.sw),
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: isUser
                      ? const Color(0xFF6366F1).withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.r),
                    topRight: Radius.circular(24.r),
                    bottomLeft: isUser ? Radius.circular(24.r) : Radius.zero,
                    bottomRight: isUser ? Radius.zero : Radius.circular(24.r),
                  ),
                  border: Border.all(
                    color: isUser
                        ? const Color(0xFF6366F1).withValues(alpha: 0.3)
                        : Colors.white12,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            message.content,
                            style: AppTextStyles.arabicBody.copyWith(
                              color: Colors.white,
                              fontSize: 16.sp,
                              height: 1.5,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                        if (!isUser)
                          IconButton(
                            icon: const Icon(
                              Icons.volume_up_rounded,
                              color: Color(0xFFD4AF37),
                              size: 20,
                            ),
                            onPressed: () => _speak(message.content),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ).animate().fadeIn().slideY(
            begin: 0.1,
            end: 0,
            curve: Curves.easeOutQuad,
          ),
    );
  }


  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child:
          Container(
                margin: EdgeInsets.only(bottom: 16.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'AI is thinking...',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .shimmer(duration: 1.seconds),
    );
  }

  Widget _buildInputArea() {
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
              // padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(24.r),
                // border: Border.all(color: Colors.white12),
              ),
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Type in Arabic...',
                  hintStyle: TextStyle(color: Colors.white30),

                  border: InputBorder.none,
                ),
                onSubmitted: (val) {
                  if (val.trim().isNotEmpty) {
                    context.read<ChatCubit>().sendMessage(val.trim());
                    _controller.clear();
                  }
                },
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: () {
              if (_controller.text.trim().isNotEmpty) {
                context.read<ChatCubit>().sendMessage(_controller.text.trim());
                _controller.clear();
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

  void _showScenarioSelector() {
    final scenarios = [
      RoleplayScenario(
        id: 'restaurant',
        title: 'At the Restaurant',
        description: 'Order your favorite meal and ask for the bill.',
        roleAi: 'The Waiter',
        roleUser: 'The Customer',
        initialMessage: 'أهلاً بك في مطعمنا! ماذا تحب أن تأكل اليوم؟',
        goal: 'Order food and pay the check.',
        targetVocab: ['قائمة الطعام', 'الحساب', 'لذيذ', 'أريد'],
      ),
      RoleplayScenario(
        id: 'airport',
        title: 'At the Airport',
        description: 'Check in for your flight and ask about your gate.',
        roleAi: 'Airport Staff',
        roleUser: 'Passenger',
        initialMessage: 'مرحباً! هل يمكنني رؤية جواز سفرك من فضلك؟',
        goal: 'Check-in and find the boarding gate.',
        targetVocab: ['جواز سفر', 'بوابة', 'رحلة', 'حقيبة'],
      ),
      RoleplayScenario(
        id: 'doctor',
        title: 'Visiting the Doctor',
        description: 'Explain your symptoms and get a prescription.',
        roleAi: 'The Doctor',
        roleUser: 'The Patient',
        initialMessage: 'سلامتك! مم تشكو اليوم؟',
        goal: 'Describe health issues and get advice.',
        targetVocab: ['ألم', 'دواء', 'حرارة', 'أشعر بـ'],
      ),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
          border: const Border(top: BorderSide(color: Colors.white12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Choose a Scenario', style: AppTextStyles.h4),
            SizedBox(height: 16.h),
            ...scenarios.map(
              (s) => ListTile(
                title: Text(
                  s.title,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  s.description,
                  style: const TextStyle(color: Colors.white54),
                ),
                trailing: const Icon(
                  Icons.play_arrow_rounded,
                  color: Color(0xFFD4AF37),
                ),
                onTap: () {
                  context.read<ChatCubit>().startScenario(s);
                  Navigator.pop(context);
                },
              ),
            ),
            const Divider(color: Colors.white12),
            ListTile(
              leading: const Icon(
                Icons.add_circle_outline_rounded,
                color: Color(0xFFD4AF37),
              ),
              title: const Text(
                'Custom Scenario',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Describe any situation (e.g., "At the barbershop")',
                style: TextStyle(color: Colors.white54),
              ),
              onTap: () {
                Navigator.pop(context);
                _showCustomScenarioDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomScenarioDialog() {
    final TextEditingController customController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: const Color(0xFF1A1A2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
            side: BorderSide(color: Colors.white12),
          ),
          title: Text('Custom AI Scenario', style: AppTextStyles.h4),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tell the AI where you want to be or who you want to talk to.',
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: customController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'e.g., Buying a plane ticket...',
                  hintStyle: const TextStyle(color: Colors.white24),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onPressed: () {
                if (customController.text.trim().isNotEmpty) {
                  context.read<ChatCubit>().generateAndStartScenario(
                    customController.text.trim(),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Generate',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpOverlay() {
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
