import 'package:arabic/features/chat/data/models/chat_model.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;
  final List<VocabItem> myWords;
  final bool correctionMode;
  final RoleplayScenario? activeScenario;
  final Map<String, dynamic>? helpHints;
  final bool isSending;
  final String? errorMessage;

  ChatLoaded({
    required this.messages,
    required this.myWords,
    this.correctionMode = true,
    this.activeScenario,
    this.helpHints,
    this.isSending = false,
    this.errorMessage,
  });

  ChatLoaded copyWith({
    List<ChatMessage>? messages,
    List<VocabItem>? myWords,
    bool? correctionMode,
    RoleplayScenario? activeScenario,
    Map<String, dynamic>? helpHints,
    bool? isSending,
    String? errorMessage,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      myWords: myWords ?? this.myWords,
      correctionMode: correctionMode ?? this.correctionMode,
      activeScenario: activeScenario ?? this.activeScenario,
      helpHints: helpHints ?? this.helpHints,
      isSending: isSending ?? this.isSending,
      errorMessage:
          errorMessage, // We don't use ?? here to allow clearing the error
    );
  }
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}
