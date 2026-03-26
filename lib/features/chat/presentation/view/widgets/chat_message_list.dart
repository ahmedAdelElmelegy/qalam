import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arabic/features/chat/presentation/manager/chat_cubit.dart';
import 'package:arabic/features/chat/presentation/manager/chat_state.dart';
import 'chat_message_bubble.dart';
import 'chat_typing_indicator.dart';

class ChatMessageList extends StatelessWidget {
  final ScrollController scrollController;
  final void Function(String) onSpeak;

  const ChatMessageList({
    super.key,
    required this.scrollController,
    required this.onSpeak,
  });

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            controller: scrollController,
            padding: EdgeInsets.all(16.w),
            itemCount: state.messages.length + (state.isSending ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.messages.length) {
                return const ChatTypingIndicator();
              }
              return ChatMessageBubble(
                message: state.messages[index],
                onSpeak: onSpeak,
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
