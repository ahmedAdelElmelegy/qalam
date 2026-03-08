import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:arabic/core/services/tts_service.dart';
import 'package:arabic/features/voice_translator/data/services/mlkit_translation_service.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';
import 'voice_translator_state.dart';

class VoiceTranslatorCubit extends Cubit<VoiceTranslatorState> {
  final MlKitTranslationService _translationService;
  final TtsService _ttsService;
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final InternetConnection _internetConnection = InternetConnection();

  bool _isSpeechInitialized = false;
  bool _translationInProgress = false; // prevents double-call from onStatus + stopListening
  int _translationSessionId = 0; // Tracks the current attempt, allows cancelling old ones
  String _currentUserSpeech = '';
  
  String _currentAiArabicReply = '';
  String _currentAiTranslation = '';

  String selectedLocaleId = 'en_US';
  String selectedLanguageName = 'English';

  VoiceTranslatorCubit({
    required MlKitTranslationService translationService,
    required TtsService ttsService,
  })  : _translationService = translationService,
        _ttsService = ttsService,
        super(VoiceTranslatorInitial());

  Future<void> _initSpeech() async {
    if (_isSpeechInitialized) return;
    try {
      _isSpeechInitialized = await _speechToText.initialize(
        onError: (error) {
          if (isClosed) return;
          // error_no_match means the mic heard nothing usable — just go back to idle
          if (error.errorMsg == 'error_no_match' ||
              error.errorMsg == 'error_speech_timeout') {
            emit(VoiceTranslatorNoMatch());
          } else {
            emit(VoiceTranslatorError(
              originalText: _currentUserSpeech,
              error: 'Speech Error: ${error.errorMsg}',
            ));
          }
        },
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            // Delay gives the final onResult callback time to arrive before we
            // process — without this the last spoken word is always dropped.
            Future.delayed(const Duration(milliseconds: 400), () {
              _handleSpeechDone();
            });
          }
        },
      );
      if (_isSpeechInitialized) {
        await Future.delayed(const Duration(milliseconds: 800));
      }
    } catch (e) {
      emit(VoiceTranslatorError(error: 'Failed to initialize speech: $e'));
    }
  }

  void startListening() async {
    if (!_isSpeechInitialized) {
      await _initSpeech();
    }
    
    if (_isSpeechInitialized) {
      // Stop TTS if it's currently speaking
      await _ttsService.stop();
      _translationSessionId++; // New session => cancel any pending translations
      _currentUserSpeech = '';
      _currentAiArabicReply = '';
      _currentAiTranslation = '';
      _translationInProgress = false; // reset for new session
      
      emit(const VoiceTranslatorListening());
      
      await _speechToText.listen(
        onResult: (result) {
          _currentUserSpeech = result.recognizedWords;
          if (state is VoiceTranslatorListening) {
            emit(VoiceTranslatorListening(partialText: _currentUserSpeech));
          }
          // finalResult = true means the engine has committed to this transcript.
          // Trigger translation immediately without waiting for onStatus.
          if (result.finalResult && _currentUserSpeech.isNotEmpty) {
            _handleSpeechDone();
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5), // increased from 3s → 5s to avoid early cut-off
        localeId: selectedLocaleId,
        listenOptions: stt.SpeechListenOptions(cancelOnError: true),
      );
    } else {
      emit(const VoiceTranslatorError(error: 'Microphone permission denied.'));
    }
  }

  void stopListening() async {
    await _speechToText.stop();
    _handleSpeechDone();
  }

  void _handleSpeechDone() async {
    // Guard: prevent double-translation when onStatus AND stopListening() both fire
    if (_translationInProgress) return;
    _translationInProgress = true;

    if (_currentUserSpeech.isEmpty) {
      _translationInProgress = false;
      emit(VoiceTranslatorInitial());
      return;
    }
    
    emit(VoiceTranslatorTranslating(originalText: _currentUserSpeech));
    
    try {
      final bool isConnected = await _internetConnection.hasInternetAccess;
      if (!isConnected) {
        emit(VoiceTranslatorError(
            originalText: _currentUserSpeech,
            error: ApiErrorHandler.getUserMessage(NetworkException("No internet connection"))));
        _translationInProgress = false;
        return;
      }

      final currentSessionId = _translationSessionId;

      final responseData = await _translationService.generateConversationalResponse(
        _currentUserSpeech,
        sourceLanguage: selectedLanguageName,
      );
      
      // If the user tapped the mic again while we were translating, discard this result.
      if (currentSessionId != _translationSessionId) return;

      _currentAiArabicReply = responseData['arabic_response'] ?? '';
      _currentAiTranslation = responseData['translation'] ?? '';
      
      emit(VoiceTranslatorSuccess(
        userSpeech: _currentUserSpeech,
        aiArabicReply: _currentAiArabicReply,
        aiTranslation: _currentAiTranslation,
        isSpeaking: true,
      ));
      
      // Auto-play the Arabic reply
      await _ttsService.speak(_currentAiArabicReply, language: "ar-SA");
      
      // If user tapped mic while AI was speaking, don't update to "success/stopped speaking"
      if (currentSessionId != _translationSessionId) return;

      if (!isClosed) {
        emit(VoiceTranslatorSuccess(
          userSpeech: _currentUserSpeech,
          aiArabicReply: _currentAiArabicReply,
          aiTranslation: _currentAiTranslation,
          isSpeaking: false,
        ));
      }
    } catch (e) {
      if (_translationSessionId == _translationSessionId) {
        String errorMessage = 'Translation failed: $e';
        if (e is Exception) {
            errorMessage = ApiErrorHandler.getUserMessage(ApiErrorHandler.handleError(e));
        }
        emit(VoiceTranslatorError(originalText: _currentUserSpeech, error: errorMessage));
      }
    } finally {
      _translationInProgress = false; // always reset so next session works
    }
  }
  
  void replayTranslation() async {
    if (_currentAiArabicReply.isNotEmpty && state is VoiceTranslatorSuccess) {
      emit(VoiceTranslatorSuccess(
        userSpeech: _currentUserSpeech,
        aiArabicReply: _currentAiArabicReply,
        aiTranslation: _currentAiTranslation,
        isSpeaking: true,
      ));
      
      await _ttsService.speak(_currentAiArabicReply, language: "ar-SA");
      
      if (!isClosed) {
        emit(VoiceTranslatorSuccess(
          userSpeech: _currentUserSpeech,
          aiArabicReply: _currentAiArabicReply,
          aiTranslation: _currentAiTranslation,
          isSpeaking: false,
        ));
      }
    }
  }

  void changeLanguage(String localeId, String languageName) {
    selectedLocaleId = localeId;
    selectedLanguageName = languageName;
    emit(VoiceTranslatorInitial());
  }

  @override
  Future<void> close() {
    _speechToText.stop();
    _ttsService.stop();
    _translationService.dispose();
    return super.close();
  }
}
