import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:arabic/core/services/groq_chat_service.dart';
import 'package:arabic/core/utils/network_checker.dart';
import 'package:arabic/features/chat/data/models/chat_message_model.dart';
import 'package:arabic/features/chat/data/models/chat_session_model.dart';
import 'package:arabic/features/chat/presentation/manager/penpal_state.dart';

class PenpalCubit extends Cubit<PenpalState> {
  final GroqChatService _chatService;
  static const String _historyPrefsKey = 'penpal_chat_sessions_v2';

  PenpalCubit(this._chatService) : super(const PenpalState());

  /// Loads all chat sessions from SharedPreferences
  Future<void> loadSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(_historyPrefsKey);

      if (historyJson != null && historyJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(historyJson);
        final loadedSessions = decoded
            .map(
              (json) => ChatSessionModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();

        // Sort by updatedAt descending
        loadedSessions.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

        String? activeId = state.activeSessionId;
        if (activeId == null && loadedSessions.isNotEmpty) {
          activeId = loadedSessions.first.id;
        }

        emit(
          state.copyWith(sessions: loadedSessions, activeSessionId: activeId),
        );
      } else {
        emit(state.copyWith(sessions: []));
        await createNewSession();
      }
    } catch (e) {
      debugPrint('Error loading chat sessions: $e');
    }
  }

  /// Sets the active session to display in the Chat Screen
  void setActiveSession(String? sessionId) {
    if (sessionId == null) {
      emit(state.copyWith(clearActiveSession: true));
    } else {
      emit(state.copyWith(activeSessionId: sessionId));
    }
  }

  /// Creates a new empty session and makes it active
  Future<void> createNewSession() async {
    final welcomeMessage = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: 'chat_buddy_welcome'.tr(), // Localized welcome
      sender: MessageSender.ai,
      timestamp: DateTime.now(),
    );

    final newSession = ChatSessionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title:
          'new_chat', // Use translation key so `.tr()` in UI works dynamically
      previewText: welcomeMessage.text,
      updatedAt: DateTime.now(),
      messages: [welcomeMessage],
    );

    final updatedSessions = List<ChatSessionModel>.from(state.sessions)
      ..insert(0, newSession);

    emit(
      state.copyWith(sessions: updatedSessions, activeSessionId: newSession.id),
    );

    await _saveSessions(updatedSessions);
  }

  /// Sends a user message in the currently active session
  Future<void> sendMessage(String text, {String? language}) async {
    if (text.trim().isEmpty) return;

    // 1. Network Check
    final hasConnection = await NetworkChecker.hasConnection();
    if (!hasConnection) {
      emit(state.copyWith(isNetworkError: true));
      return;
    }

    // If no active session, create one first
    if (state.activeSession == null) {
      await createNewSession();
    }

    final activeSession = state.activeSession!;

    // Create user message
    final userMessage = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );

    final updatedMessages = List<ChatMessageModel>.from(activeSession.messages)
      ..add(userMessage);

    // Update session with user message and new title/preview if it's the first real message
    final isFirstUserMessage = activeSession.messages.length <= 1;
    final String newTitle = isFirstUserMessage
        ? (text.length > 20 ? '${text.substring(0, 20)}...' : text)
        : activeSession.title;

    var updatedSession = activeSession.copyWith(
      title: newTitle,
      previewText: text,
      updatedAt: DateTime.now(),
      messages: updatedMessages,
    );

    _updateSessionInList(updatedSession);
    emit(state.copyWith(isAiTyping: true, error: null, isNetworkError: false));

    try {
      // Get AI response
      final aiResponseText = await _chatService.getPenpalResponse(
        updatedMessages,
        language ?? 'Arabic',
      );

      final aiMessage = ChatMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: aiResponseText,
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
      );

      final finalMessages = List<ChatMessageModel>.from(updatedSession.messages)
        ..add(aiMessage);

      updatedSession = updatedSession.copyWith(
        previewText: aiResponseText, // Preview becomes AI response
        updatedAt: DateTime.now(),
        messages: finalMessages,
      );

      _updateSessionInList(updatedSession);
      emit(state.copyWith(isAiTyping: false));
    } on SocketException {
      emit(state.copyWith(isAiTyping: false, isNetworkError: true));
    } on TimeoutException {
      emit(state.copyWith(isAiTyping: false, isNetworkError: true));
    } catch (e) {
      debugPrint('Error sending message: $e');
      emit(state.copyWith(isAiTyping: false, error: 'failed_to_send_message'));
    }
  }


  /// Clears the current error
  void clearError() {
    emit(state.copyWith(error: null, isNetworkError: false));
  }

  /// Deletes a specific session
  Future<void> deleteSession(String sessionId) async {
    final newSessions = state.sessions.where((s) => s.id != sessionId).toList();

    emit(
      state.copyWith(
        sessions: newSessions,
        clearActiveSession: state.activeSessionId == sessionId,
      ),
    );

    await _saveSessions(newSessions);
  }

  // --- Helpers ---

  void _updateSessionInList(ChatSessionModel updatedSession) {
    final index = state.sessions.indexWhere((s) => s.id == updatedSession.id);
    if (index == -1) return;

    final newSessions = List<ChatSessionModel>.from(state.sessions);
    newSessions[index] = updatedSession;

    // Move updated session to the top
    newSessions.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    emit(state.copyWith(sessions: newSessions));
    _saveSessions(newSessions);
  }

  Future<void> _saveSessions(List<ChatSessionModel> sessions) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> jsonList = sessions
          .map((m) => m.toJson())
          .toList();
      final String encoded = jsonEncode(jsonList);
      await prefs.setString(_historyPrefsKey, encoded);
    } catch (e) {
      debugPrint('Error saving chat sessions: $e');
    }
  }
}
