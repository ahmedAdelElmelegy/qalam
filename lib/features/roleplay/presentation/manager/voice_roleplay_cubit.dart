import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:arabic/core/services/voice_roleplay_service.dart';
import 'package:arabic/core/services/tts_service.dart';
import 'package:arabic/features/chat/data/models/chat_model.dart';
import 'package:arabic/features/roleplay/data/models/roleplay_scenario_model.dart';
import 'package:arabic/features/roleplay/presentation/manager/voice_roleplay_state.dart';
import 'package:arabic/features/roleplay/data/models/roleplay_response_model.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceRoleplayCubit extends Cubit<VoiceRoleplayState> {
  final VoiceRoleplayService _service;
  final TtsService _ttsService;
  final RoleplayScenarioModel scenario;
  final String languageCode;
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  final List<ChatMessage> _history = [];
  RoleplayResponseModel? _lastResponse;
  bool _speechEnabled = false;

  VoiceRoleplayCubit({
    required VoiceRoleplayService service,
    required TtsService ttsService,
    required this.scenario,
    required this.languageCode,
  }) : _service = service,
       _ttsService = ttsService,
       super(VoiceRoleplayInitial()) {
    _initServices();
  }

  Future<void> _initServices() async {
    try {
      await _ttsService.initialize();
      _ttsService.setCompletionHandler(() {
        if (!isClosed) {
          emit(
            VoiceRoleplayIdle(history: _history, lastResponse: _lastResponse),
          );
          startListening();
        }
      });

      // Start the conversation with the scenario's initial greeting
      _history.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: scenario.initialGreeting,
          timestamp: DateTime.now(),
          role: MessageRole.assistant,
        ),
      );

      if (!isClosed) {
        emit(VoiceRoleplayIdle(history: _history));
      }

      // Optionally speak the initial greeting automatically
      await _ttsService.speak(scenario.initialGreeting, language: "ar-SA");
    } catch (e) {
      if (!isClosed) {
        emit(
          VoiceRoleplayError(
            history: _history,
            error: "Failed to initialize services: $e",
          ),
        );
      }
    }
  }

  Future<void> startListening() async {
    if (!_speechEnabled) {
      try {
        _speechEnabled = await _speechToText.initialize(
          onError: (error) {
            debugPrint("STT Error: $error");
            if (!isClosed) {
              String errorMessage;
              if (error.errorMsg == 'error_no_match' ||
                  error.errorMsg == 'error_speech_timeout' ||
                  error.errorMsg == 'error_network_timeout') {
                errorMessage = "voice_roleplay_mic_error_no_match";
              } else {
                errorMessage = "voice_roleplay_mic_error_generic";
              }
              emit(VoiceRoleplayError(history: _history, error: errorMessage));
              // After showing the error, return to Idle state to keep the UI clean
              Future.delayed(const Duration(seconds: 1), () {
                if (!isClosed) {
                  emit(
                    VoiceRoleplayIdle(
                      history: _history,
                      lastResponse: _lastResponse,
                    ),
                  );
                }
              });
            }
          },
        );
        if (_speechEnabled) {
          await Future.delayed(const Duration(milliseconds: 800));
        }
      } catch (e) {
        debugPrint("Speech Initialization failed: $e");
      }
    }

    if (!_speechEnabled) {
      emit(
        VoiceRoleplayError(
          history: _history,
          error: "Microphone permission not granted.",
        ),
      );
      return;
    }

    try {
      await _ttsService.stop(); // Stop any ongoing speech
      emit(VoiceRoleplayListening(history: _history, recognizedText: ""));

      await _speechToText.listen(
        onResult: (result) {
          if (isClosed) return;

          if (result.finalResult) {
            _processUserInput(result.recognizedWords);
          } else {
            emit(
              VoiceRoleplayListening(
                history: _history,
                recognizedText: result.recognizedWords,
              ),
            );
          }
        },
        localeId: 'ar_SA',
        pauseFor: const Duration(seconds: 5),
        listenOptions: stt.SpeechListenOptions(
          listenMode: stt.ListenMode.dictation,
        ),
      );
    } catch (e) {
      if (!isClosed) {
        emit(
          VoiceRoleplayError(
            history: _history,
            error: "Failed to start listening: $e",
          ),
        );
      }
    }
  }

  Future<void> stopListeningManually() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
    }
    // Immediately update the UI to reflect that we stopped listening
    if (!isClosed) {
      emit(VoiceRoleplayIdle(history: _history, lastResponse: _lastResponse));
    }
  }

  Future<void> _processUserInput(String text) async {
    if (text.trim().isEmpty) {
      emit(VoiceRoleplayIdle(history: _history, lastResponse: _lastResponse));
      return;
    }

    // Add user message to history
    _history.add(
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: text,
        timestamp: DateTime.now(),
        role: MessageRole.user,
      ),
    );

    emit(VoiceRoleplayProcessing(history: _history));

    try {
      final response = await _service.sendVoiceRoleplayMessage(
        history: _history,
        scenarioContext: scenario.systemPromptContext,
        targetLanguageCode: languageCode,
      );
      _lastResponse = response;

      // Add AI response to history
      final displayMessageText =
          response.roleplayReplyAr +
          (response.nextQuestionAr.isNotEmpty
              ? " ${response.nextQuestionAr}"
              : "");

      // We append transliteration to the content so it can be extracted later if needed
      final fullContent =
          "$displayMessageText\n\n${response.roleplayReplyTransliteration}";

      _history.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: fullContent,
          timestamp: DateTime.now(),
          role: MessageRole.assistant,
        ),
      );

      // Construct spoken string smoothly
      String spokenText = "";
      if (response.correctionAr.isNotEmpty) {
        // Add a clear indicator that this is a correction, not the character speaking.
        // Using Arabic comma '،' creates a natural pause instead of '... ...' which causes TTS errors.
        spokenText += "مَلْحُوظَة تَعْلِيمِيَّة: ${response.correctionAr}، ";
      } else if (response.correctReplyAr.isNotEmpty &&
          response.roleplayReplyAr.isEmpty) {
        // Fallback if only correctReply is available
        spokenText +=
            "كَانَ الأَفْضَلُ أَنْ تَقُول: ${response.correctReplyAr}، ";
      }

      // Attach the character reply
      spokenText += displayMessageText;

      emit(VoiceRoleplaySpeaking(history: _history, response: response));

      // Speak the constructed text
      await _ttsService.speak(spokenText, language: "ar-SA");
    } catch (e) {
      if (!isClosed) {
        emit(
          VoiceRoleplayError(
            history: _history,
            error: "Failed to get AI response: $e",
          ),
        );
      }
    }
  }

  @override
  Future<void> close() {
    _ttsService.stop();
    _speechToText.cancel();
    return super.close();
  }
}
