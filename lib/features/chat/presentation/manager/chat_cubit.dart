import 'package:arabic/core/services/groq_chat_service.dart';
import 'package:arabic/features/chat/data/models/chat_model.dart';
import 'package:arabic/features/chat/presentation/manager/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatState> {
  final GroqChatService _chatService = GroqChatService();

  ChatCubit() : super(ChatInitial());

  void initChat() {
    emit(ChatLoaded(messages: [], myWords: []));
  }


  void startScenario(RoleplayScenario scenario) {
    if (state is ChatLoaded) {
      final s = state as ChatLoaded;
      final initialMsg = ChatMessage(
        content: scenario.initialMessage,
        role: MessageRole.assistant,
      );
      emit(
        s.copyWith(
          activeScenario: scenario,
          messages: [initialMsg],
          helpHints: null,
        ),
      );
    }
  }

  Future<void> generateAndStartScenario(String prompt) async {
    if (state is ChatLoaded) {
      final s = state as ChatLoaded;
      emit(s.copyWith(isSending: true, errorMessage: null));

      try {
        final scenario = await _chatService.generateScenario(prompt);
        final initialMsg = ChatMessage(
          content: scenario.initialMessage,
          role: MessageRole.assistant,
        );
        emit(s.copyWith(
          activeScenario: scenario,
          messages: [initialMsg],
          helpHints: null,
          isSending: false,
          errorMessage: null,
        ));
      } catch (e) {
        emit(s.copyWith(isSending: false, errorMessage: 'Generation Failed: ${e.toString()}'));
      }
    }
  }

  Future<void> sendMessage(String text) async {
    if (state is ChatLoaded) {
      final s = state as ChatLoaded;
      if (s.isSending) return;

      final userMsg = ChatMessage(content: text, role: MessageRole.user);
      final updatedMessages = List<ChatMessage>.from(s.messages)..add(userMsg);

      emit(s.copyWith(messages: updatedMessages, isSending: true, errorMessage: null));

      try {
        final response = await _chatService.sendMessage(
          history: updatedMessages,
          scenario: s.activeScenario,
        );


        final List<VocabItem> newVocab = [];
        if (response['extracted_vocab'] != null) {
          for (var item in response['extracted_vocab']) {
            newVocab.add(
              VocabItem(
                term: item['term'],
                meaning: item['meaning'],
                example: item['example'],
              ),
            );
          }
        }

        final aiMsg = ChatMessage(
          content: response['ai_message'] ?? response['message'] ?? '',
          role: MessageRole.assistant,
        );

        final List<VocabItem> updatedWords = List.from(s.myWords);
        for (var v in newVocab) {
          if (!updatedWords.any((existing) => existing.term == v.term)) {
            updatedWords.add(v);
          }
        }

        emit(
          s.copyWith(
            messages: List.from(updatedMessages)..add(aiMsg),
            myWords: updatedWords,
            helpHints: response['help'],
            isSending: false,
            errorMessage: null,
          ),
        );
      } catch (e) {
        emit(s.copyWith(isSending: false, errorMessage: e.toString()));
      }
    }
  }
}
