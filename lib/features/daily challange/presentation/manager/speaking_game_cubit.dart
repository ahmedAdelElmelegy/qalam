import 'dart:async';
import 'package:arabic/features/daily%20challange/data/models/question_model.dart';
import 'package:arabic/features/daily%20challange/data/services/flashcard_local_service.dart';
import 'package:arabic/features/daily%20challange/presentation/manager/speaking_game_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeakingGameCubit extends Cubit<SpeakingGameState> {
  final FlashcardLocalService _localService;
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  bool _isSpeechInitialized = false;
  List<QuestionModel> _cards = [];
  int _correctAnswers = 0;
  int _totalCards = 0;
  int _currentIndex = 0;
  String _currentRecognized = '';

  SpeakingGameCubit({required FlashcardLocalService localService})
    : _localService = localService,
      super(SpeakingGameInitial());

  Future<void> startGame({required int day, required String locale}) async {
    emit(SpeakingGameLoading());
    try {
      _cards = await _localService.getFlashcards(day: day, locale: locale);
      _totalCards = _cards.length;
      _correctAnswers = 0;
      _currentIndex = 0;
      await _initSpeech();
      _emitLoadedState();
    } catch (e) {
      emit(SpeakingGameError(message: e.toString()));
    }
  }

  Future<void> _initSpeech() async {
    if (_isSpeechInitialized) return;
    try {
      _isSpeechInitialized = await _speechToText.initialize(
        onError: (error) {
          if (isClosed) return;
          // error_no_match or error_speech_timeout
          _emitLoadedState(isListening: false);
        },
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            _handleSpeechDone();
          }
        },
      );
    } catch (e) {
      emit(
        SpeakingGameError(
          message: 'speech_init_error'.tr(args: [e.toString()]),
        ),
      );
    }
  }

  void startListening() async {
    if (!_isSpeechInitialized) {
      await _initSpeech();
    }

    if (_isSpeechInitialized && _cards.isNotEmpty) {
      if (_cards.first.type != 'speaking') {
        // Not a speaking question, ignore start listening requests
        return;
      }

      _currentRecognized = '';
      _emitLoadedState(isListening: true, recognizedText: '');

      await _speechToText.listen(
        onResult: (result) {
          _currentRecognized = result.recognizedWords;
          if (state is SpeakingGameLoaded) {
            _emitLoadedState(
              isListening: true,
              recognizedText: _currentRecognized,
            );
          }

          if (result.finalResult && _currentRecognized.isNotEmpty) {
            stopListening();
          }
        },
        listenFor: const Duration(seconds: 5),
        pauseFor: const Duration(seconds: 2),
        listenOptions: stt.SpeechListenOptions(cancelOnError: true),
      );
    } else {
      emit(const SpeakingGameError(message: 'mic_permission_denied'));
    }
  }

  void stopListening() async {
    await _speechToText.stop();
    _handleSpeechDone();
  }

  void _handleSpeechDone() async {
    if (state is! SpeakingGameLoaded) return;

    // Stop listening UI
    _emitLoadedState(isListening: false, recognizedText: _currentRecognized);

    if (_currentRecognized.isEmpty) return;
    if (_cards.isEmpty || _cards.first.type != 'speaking') return;

    _evaluateAnswer(_currentRecognized);
  }

  Future<void> evaluateMultiChoiceAnswer(String answer) async {
    if (state is! SpeakingGameLoaded) return;
    if (_cards.isEmpty) return;

    _evaluateAnswer(answer);
  }

  void _evaluateAnswer(String userAnswer) async {
    emit(SpeakingGameChecking());

    final currentCard = _cards.first; // The top card

    bool isCorrect;
    if (currentCard.type == 'multipleChoice' ||
        currentCard.type == 'audioOptions' ||
        currentCard.type == 'listening') {
      isCorrect = userAnswer == currentCard.correctAnswer;
    } else {
      isCorrect = _checkPronunciation(userAnswer, currentCard.correctAnswer);
    }

    if (isCorrect) {
      emit(SpeakingGameCorrect(card: currentCard));
      await Future.delayed(const Duration(milliseconds: 1500));
      _correctAnswers++;
    } else {
      emit(
        SpeakingGameIncorrect(
          card: currentCard,
          recognizedText: _currentRecognized,
        ),
      );
      await Future.delayed(const Duration(milliseconds: 1500));
    }

    _cards.removeAt(0);
    _currentIndex++;
    _currentRecognized = '';

    if (_cards.isEmpty) {
      _finishGame();
    } else {
      _emitLoadedState();
    }
  }

  void _finishGame() {
    double percentage = _totalCards > 0
        ? (_correctAnswers / _totalCards) * 100
        : 0;
    bool isWin = percentage >= 70;
    emit(SpeakingGameOver(isWin: isWin, percentage: percentage.toInt()));
  }

  bool _checkPronunciation(String spoken, String target) {
    // Basic normalization: remove punctuation, lowercase
    String normalize(String s) =>
        s.replaceAll(RegExp(r'[^\w\s\u0600-\u06FF]'), '').trim().toLowerCase();

    final normalizedSpoken = normalize(spoken);
    final normalizedTarget = normalize(target);

    if (normalizedSpoken.isEmpty || normalizedTarget.isEmpty) return false;

    // Exact match
    if (normalizedSpoken.contains(normalizedTarget) ||
        normalizedTarget.contains(normalizedSpoken)) {
      return true;
    }

    // Basic distance/similarity could go here. For now, we rely on contains.
    return false;
  }

  void _emitLoadedState({bool? isListening, String? recognizedText}) {
    emit(
      SpeakingGameLoaded(
        cards: List.from(_cards), // create new list reference,
        currentCardIndex: _currentIndex,
        correctAnswers: _correctAnswers,
        totalCards: _totalCards,
        isListening: isListening ?? false,
        recognizedText: recognizedText ?? _currentRecognized,
      ),
    );
  }
}
