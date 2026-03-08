import 'package:equatable/equatable.dart';
import 'package:arabic/features/chat/data/models/chat_session_model.dart';

class PenpalState extends Equatable {
  final List<ChatSessionModel> sessions;
  final String? activeSessionId;
  final bool isAiTyping;
  final String? correctingMessageId;
  final String? error;
  final bool isNetworkError;

  const PenpalState({
    this.sessions = const [],
    this.activeSessionId,
    this.isAiTyping = false,
    this.correctingMessageId,
    this.error,
    this.isNetworkError = false,
  });

  ChatSessionModel? get activeSession {
    if (activeSessionId == null) return null;
    try {
      return sessions.firstWhere((s) => s.id == activeSessionId);
    } catch (_) {
      return null;
    }
  }

  PenpalState copyWith({
    List<ChatSessionModel>? sessions,
    String? activeSessionId,
    bool? isAiTyping,
    String? correctingMessageId,
    String? error,
    bool? isNetworkError,
    bool clearActiveSession = false,
  }) {
    return PenpalState(
      sessions: sessions ?? this.sessions,
      activeSessionId: clearActiveSession ? null : (activeSessionId ?? this.activeSessionId),
      isAiTyping: isAiTyping ?? this.isAiTyping,
      correctingMessageId: correctingMessageId ?? this.correctingMessageId,
      error: error, // passing null clears it
      isNetworkError: isNetworkError ?? false,
    );
  }

  @override
  List<Object?> get props => [
        sessions,
        activeSessionId,
        isAiTyping,
        correctingMessageId,
        error,
        isNetworkError
      ];
}
