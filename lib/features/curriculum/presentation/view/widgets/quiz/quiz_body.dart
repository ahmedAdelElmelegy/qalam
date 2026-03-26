import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/services/quiz_sound_service.dart';
import 'package:arabic/core/utils/local_storage.dart';
import 'package:arabic/core/utils/network_checker.dart';
import 'package:arabic/features/curriculum/data/models/culture_model.dart';
import 'package:arabic/features/curriculum/data/models/progress/sync_quiz_request_body.dart';
import 'package:arabic/features/curriculum/presentation/manager/curriculum_cubit.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:arabic/features/home/presentation/view/widgets/home_bg.dart';
import 'package:arabic/core/services/tts_service.dart';
import 'package:arabic/core/helpers/arabic_speech_helper.dart';
import 'package:arabic/features/curriculum/presentation/manager/quiz/quiz_cubit.dart';
import 'package:arabic/features/curriculum/presentation/manager/sync/sync_quiz_cubit.dart';

import 'quiz_header.dart';
import 'quiz_question_image.dart';
import 'quiz_question_text.dart';
import 'quiz_option.dart';
import 'quiz_footer.dart';
import 'quiz_result_screen.dart';
import 'quiz_word_puzzle.dart';
import 'quiz_fill_in_the_blank.dart';
import 'quiz_audio_options.dart';
import 'quiz_speaking.dart';

class QuizBody extends StatefulWidget {
  final Quiz? quiz;
  final String? lessonId;
  final int? quizLessonId;
  final String levelId;
  final String unitId;
  final bool isSkipQuiz;
  final bool isLevelQuiz;

  const QuizBody({
    super.key,
    this.quiz,
    this.quizLessonId,
    this.lessonId,
    required this.levelId,
    required this.unitId,
    this.isSkipQuiz = false,
    this.isLevelQuiz = false,
  });

  @override
  State<QuizBody> createState() => _QuizBodyState();
}

class _QuizBodyState extends State<QuizBody> {
  final TtsService _ttsService = TtsService();
  int _currentIndex = 0;
  String? _selectedAnswer;
  bool _isAnswerChecked = false;
  bool _isCorrect = false;
  int _score = 0;
  bool _isFinished = false;
  bool isSpeaking = false;

  List<String> _shuffledWords = [];
  List<String> _selectedWords = [];
  String? blankSelection;
  bool _isRecording = false;
  String? _activeAudioOption;
  bool _showSpeakingError = false;

  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _speechEnabled = false;
  String _recognizedWords = '';
  bool _isPlayingQuestion = false;
  bool _isDisposed = false;
  bool _isInitializingSpeech = false;
  int? userId;
  Quiz? _fetchedQuiz;

  Quiz get _quiz => widget.quiz ?? _fetchedQuiz!;

  @override
  void initState() {
    super.initState();
    _initTts();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.quiz == null && widget.quizLessonId != null) {
        context.read<QuizCubit>().getLessonQuiz(
          lessonId: widget.quizLessonId!,
          lang: context.locale.languageCode,
        );
      }
      loadInitialData();
    });
  }

  Future<void> loadInitialData() async {
    await LocalStorage.getEmailId().then((value) {
      setState(() {
        userId = value;
      });
    });
  }

  Future<void> _initTts() async {
    if (_isInitializingSpeech) return;
    _isInitializingSpeech = true;

    try {
      await _ttsService.initialize();
      await _ttsService.updateSpeed(0.4);

      await _ttsService.setStartHandler(() {
        if (mounted && !_isDisposed) setState(() => isSpeaking = true);
      });

      await _ttsService.setCompletionHandler(() {
        if (mounted && !_isDisposed) {
          setState(() {
            isSpeaking = false;
            _isPlayingQuestion = false;
          });
        }
      });

      await _ttsService.stop();
    } catch (e) {
      debugPrint("Initialization error: $e");
    } finally {
      _isInitializingSpeech = false;
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _ttsService.clearHandlers();
    _speechToText.stop();
    _speechToText.cancel();
    super.dispose();
  }

  String _extractArabic(String text) {
    return ArabicSpeechHelper.extractArabic(text);
  }

  Future<void> _speak(String text, {bool isQuestionAudio = false}) async {
    if (_isDisposed) return;
    final arabicText = _extractArabic(text);
    if (arabicText.isEmpty) return;

    if (isQuestionAudio) {
      setState(() => _isPlayingQuestion = true);
    }
    await _ttsService.speak(arabicText, language: "ar-SA");
  }

  String _normalize(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  String _normalizeArabic(String text) {
    return ArabicSpeechHelper.normalizeArabic(text);
  }

  bool _wordsMatch(String expected, String actual) {
    return ArabicSpeechHelper.wordsMatch(expected, actual);
  }

  void _compareRecitation() {
    if (_activeAudioOption != "checking") return;
    _activeAudioOption = null;

    final currentQuestion = _quiz.questions[_currentIndex];
    final rawAnswer = currentQuestion.correctAnswer.trim();

    final actualNormalized = _normalizeArabic(_recognizedWords);
    final actualWordsNormalized = actualNormalized
        .split(' ')
        .where((w) => w.isNotEmpty)
        .toList();

    bool matched = false;

    if (rawAnswer.length <= 2) {
      for (final aWord in actualWordsNormalized) {
        if (_wordsMatch(rawAnswer, aWord)) {
          matched = true;
          break;
        }
      }
    } else {
      final expectedNormalized = _normalizeArabic(rawAnswer);
      final expectedWordsNormalized = expectedNormalized
          .split(' ')
          .where((w) => w.isNotEmpty)
          .toList();

      int matchedWords = 0;
      for (int i = 0; i < expectedWordsNormalized.length; i++) {
        final expectedNorm = expectedWordsNormalized[i];
        for (int j = 0; j < actualWordsNormalized.length; j++) {
          if (_wordsMatch(expectedNorm, actualWordsNormalized[j])) {
            matchedWords++;
            break;
          }
        }
      }

      final accuracy = expectedWordsNormalized.isEmpty
          ? 0.0
          : (matchedWords / expectedWordsNormalized.length) * 100;
      matched = accuracy >= 70;
    }

    setState(() {
      if (matched) {
        _selectedAnswer = "success";
        _showSpeakingError = false;
        _checkAnswer();
      } else {
        _selectedAnswer = null;
        _showSpeakingError = true;
      }
    });
  }

  void _checkAnswer() {
    final currentQuestion = _quiz.questions[_currentIndex];
    bool correct = false;

    if (currentQuestion.type == QuestionType.reorder) {
      final userAnswer = _normalize(_selectedWords.join(' '));
      final correctAnswer = _normalize(currentQuestion.correctAnswer);
      correct = userAnswer == correctAnswer;
      _selectedAnswer = userAnswer;
    } else if (currentQuestion.type == QuestionType.speaking) {
      correct = _selectedAnswer == "success" || _selectedAnswer == "skipped";
    } else {
      final userAnswer = _normalize(_selectedAnswer ?? "");
      final correctAnswer = _normalize(currentQuestion.correctAnswer);
      correct = userAnswer == correctAnswer;
    }

    setState(() {
      _isAnswerChecked = true;
      _isCorrect = correct;
      if (_isCorrect) _score++;
    });

    if (_isCorrect) {
      QuizSoundService.playCorrect();
    } else {
      QuizSoundService.playWrong();
    }
  }

  void _nextQuestion() {
    if (_isRecording || _speechToText.isListening) {
      _speechToText.stop();
      setState(() => _isRecording = false);
    }

    if (_currentIndex < _quiz.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _isAnswerChecked = false;
        _isCorrect = false;
        _shuffledWords = [];
        _selectedWords = [];
        blankSelection = null;
        _activeAudioOption = null;
        _showSpeakingError = false;
        _isPlayingQuestion = false;
        _recognizedWords = '';
      });
    } else {
      setState(() {
        _isFinished = true;
      });
      _handleCompletion();
    }
  }

  void _handleCompletion() {
    final success = _score / _quiz.questions.length >= _quiz.passingScore;
    if (success) {
      final cubit = context.read<CurriculumCubit>();
      if (widget.isLevelQuiz) {
        cubit.unlockNextLevel(widget.levelId);
      } else if (widget.isSkipQuiz) {
        cubit.testOutUnit(widget.levelId, widget.unitId);

        final curriculumState = cubit.state;
        if (curriculumState is CurriculumLoaded && success) {
          try {
            final level = curriculumState.levels.firstWhere(
              (l) => l.id == widget.levelId,
            );
            final unit = level.units.firstWhere((u) => u.id == widget.unitId);

            final completions = unit.lessons
                .map(
                  (lesson) => Completion(
                    id: lesson.id,
                    dbId: lesson.dbId ?? 0,
                    type: 'lesson',
                    xpReward: lesson.xpReward,
                    completedAt: DateTime.now(),
                  ),
                )
                .toList();

            if (completions.isNotEmpty) {
              context.read<SyncQuizCubit>().syncQuiz(
                SyncQuizRequestBody(completions: completions),
                userId ?? 0,
              );
            }
          } catch (e) {
            debugPrint("Error finding unit lessons for sync: $e");
          }
        }
      } else if (widget.lessonId != null) {
        cubit.completeLesson(widget.levelId, widget.unitId, widget.lessonId!);
      } else {
        cubit.unlockNextUnit(widget.levelId, widget.unitId);
      }

      if (widget.lessonId != null && !widget.isSkipQuiz && success) {
        final curriculumState = cubit.state;
        if (curriculumState is CurriculumLoaded) {
          try {
            final level = curriculumState.levels.firstWhere(
              (l) => l.id == widget.levelId,
            );
            final unit = level.units.firstWhere((u) => u.id == widget.unitId);
            final lesson = unit.lessons.firstWhere(
              (l) => l.id == widget.lessonId,
            );

            context.read<SyncQuizCubit>().syncQuiz(
              SyncQuizRequestBody(
                completions: [
                  Completion(
                    id: widget.lessonId!,
                    dbId: widget.quizLessonId ?? lesson.dbId ?? 0,
                    type: 'lesson',
                    xpReward: lesson.xpReward,
                    completedAt: DateTime.now(),
                  ),
                ],
              ),
              userId ?? 0,
            );
          } catch (e) {
            debugPrint("Error finding lesson for sync: $e");
          }
        }
      }
    }
  }

  void _onAudioOptionTap(String option) async {
    if (_isAnswerChecked || _isDisposed) return;
    setState(() {
      _selectedAnswer = option;
      _activeAudioOption = option;
    });
    await _speak(option);
    if (mounted && !_isDisposed) {
      setState(() => _activeAudioOption = null);
    }
  }

  Future<void> _toggleRecording() async {
    if (_isAnswerChecked || _isDisposed) return;

    if (!await NetworkChecker.hasConnection()) {
      if (mounted && !_isDisposed) NetworkChecker.showNoNetworkDialog(context);
      return;
    }

    if (_isInitializingSpeech) {
      int retries = 0;
      while (_isInitializingSpeech && retries < 10) {
        await Future.delayed(const Duration(milliseconds: 200));
        retries++;
      }
    }

    if (!_speechEnabled) {
      if (_isInitializingSpeech) return;
      _isInitializingSpeech = true;
      try {
        _speechEnabled = await _speechToText.initialize(
          onError: (error) {
            if (mounted && !_isDisposed) {
              debugPrint("Speech error: $error");
              setState(() => _isRecording = false);
            }
          },
          onStatus: (status) {
            debugPrint("Speech status: $status");
            if (_isInitializingSpeech) return;
            if (mounted && !_isDisposed) {
              if (status == 'notListening' || status == 'done') {
                if (_isRecording) {
                  setState(() {
                    _isRecording = false;
                    _activeAudioOption = "checking";
                  });
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (mounted &&
                        !_isDisposed &&
                        _activeAudioOption == "checking") {
                      _compareRecitation();
                    }
                  });
                } else if (_activeAudioOption != "checking") {
                  setState(() => _isRecording = false);
                }
              }
            }
          },
        );

        if (_speechEnabled) {
          await Future.delayed(const Duration(milliseconds: 800));
        }
      } finally {
        _isInitializingSpeech = false;
      }

      if (!_speechEnabled) {
        if (mounted && !_isDisposed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Microphone permission required')),
          );
        }
        return;
      }
    }

    if (_speechToText.isNotListening) {
      await _ttsService.stop();

      if (_isDisposed) return;
      setState(() {
        _isRecording = true;
        _showSpeakingError = false;
        _recognizedWords = '';
      });

      await _speechToText.listen(
        onResult: (result) {
          if (_isDisposed || !mounted) return;
          setState(() {
            _recognizedWords = result.recognizedWords;
          });
          if (result.finalResult) {
            setState(() {
              _isRecording = false;
              _activeAudioOption = "checking";
            });
            _compareRecitation();
          }
        },
        localeId: 'ar_SA',
        pauseFor: const Duration(seconds: 4),
        listenOptions: stt.SpeechListenOptions(listenMode: .dictation),
      );
    } else {
      if (_isDisposed) return;
      setState(() {
        _isRecording = false;
        _activeAudioOption = "checking";
      });
      await _speechToText.stop();
      if (!_isDisposed && mounted) {
        _compareRecitation();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SyncQuizCubit, SyncQuizState>(
      listener: (context, state) {
        if (state is SyncQuizFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(ApiErrorHandler.getUserMessage(state.message)),
              backgroundColor: Colors.redAccent,
            ),
          );
        } else if (state is SyncQuizSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('quiz_sync_success'.tr()),
              backgroundColor: const Color(0xFF10B981),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: widget.quiz != null
          ? _buildQuizBody(context)
          : BlocBuilder<QuizCubit, QuizState>(
              builder: (context, state) {
                if (state is QuizSucess) {
                  _fetchedQuiz = state.quiz.toDomain();
                  return _buildQuizBody(context);
                }
                if (state is QuizFailed) {
                  return _buildErrorState(state.exception);
                }
                return _buildLoadingState();
              },
            ),
    );
  }

  Widget _buildQuizBody(BuildContext context) {
    if (_isFinished) {
      return QuizResultScreen(
        score: _score,
        quizLength: _quiz.questions.length,
        passingScore: _quiz.passingScore,
        levelId: widget.levelId,
        unitId: widget.unitId,
        lessonId: widget.lessonId,
        quizLessonId: widget.quizLessonId,
      );
    }

    final currentQuestion = _quiz.questions[_currentIndex];
    final progress = (_currentIndex + 1) / _quiz.questions.length;

    Widget getOptionsContent() {
      if (currentQuestion.type == QuestionType.reorder) {
        return QuizWordPuzzle(
          question: currentQuestion,
          shuffledWords: _shuffledWords.isEmpty
              ? List.from(currentQuestion.options)
              : _shuffledWords,
          selectedWords: _selectedWords,
          isAnswerChecked: _isAnswerChecked,
          isCorrect: _isCorrect,
          onWordTap: (word, isSelected) {
            setState(() {
              if (isSelected) {
                _selectedWords.remove(word);
              } else {
                _selectedWords.add(word);
                _speak(word);
              }
              _selectedAnswer = _selectedWords.isEmpty
                  ? null
                  : _selectedWords.join(' ');
            });
          },
        );
      } else if (currentQuestion.type == QuestionType.fillInTheBlank) {
        return QuizFillInTheBlank(
          question: currentQuestion,
          selectedAnswer: _selectedAnswer,
          isAnswerChecked: _isAnswerChecked,
          isCorrect: _isCorrect,
          onOptionTap: (opt) {
            setState(() => _selectedAnswer = opt);
            _speak(opt);
          },
        );
      } else if (currentQuestion.type == QuestionType.audioOptions) {
        return QuizAudioOptions(
          question: currentQuestion,
          activeAudioOption: _activeAudioOption,
          selectedAnswer: _selectedAnswer,
          onAudioOptionTap: _onAudioOptionTap,
        );
      } else if (currentQuestion.type == QuestionType.speaking) {
        return QuizSpeaking(
          question: currentQuestion,
          isChecking: _activeAudioOption == "checking",
          isSuccess: _selectedAnswer == "success",
          showSpeakingError: _showSpeakingError,
          recognizedWords: _recognizedWords,
          isRecording: _isRecording,
          onToggleRecording: _toggleRecording,
        );
      } else {
        return Column(
          children: currentQuestion.options
              .map(
                (opt) => QuizOption(
                  option: opt,
                  correct: currentQuestion.correctAnswer,
                  isSelected: _selectedAnswer == opt,
                  isAnswerChecked: _isAnswerChecked,
                  onTap: () {
                    setState(() => _selectedAnswer = opt);
                    _speak(opt);
                  },
                ),
              )
              .toList(),
        );
      }
    }

    final questionContent = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (currentQuestion.imageUrl != null) ...[
          QuizQuestionImage(url: currentQuestion.imageUrl!),
          SizedBox(height: 24.h),
        ],
        QuizQuestionText(
          question: currentQuestion,
          isPlayingQuestion: _isPlayingQuestion,
          onTapAudio: () => _speak(
            currentQuestion.type == QuestionType.listening
                ? currentQuestion.correctAnswer
                : (currentQuestion.phonetic ?? currentQuestion.text),
            isQuestionAudio: true,
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: const Color(0xFF080818),
      body: Stack(
        children: [
          const Positioned.fill(child: Background3D()),
          HomeBackground(
            child: SafeArea(
              child: Column(
                children: [
                  QuizHeader(
                    progress: progress,
                    currentIndex: _currentIndex,
                    totalQuestions: _quiz.questions.length,
                    onClose: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 750;

                        if (isWide) {
                          return Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Center(
                                  child: SingleChildScrollView(
                                    padding: EdgeInsets.all(32.w),
                                    child: questionContent,
                                  ),
                                ),
                              ),
                              VerticalDivider(
                                color: Colors.white.withValues(alpha: 0.1),
                                width: 1,
                              ),
                              Expanded(
                                flex: 5,
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.all(24.w),
                                  child: getOptionsContent(),
                                ),
                              ),
                            ],
                          );
                        }

                        return SingleChildScrollView(
                          padding: EdgeInsets.all(24.w),
                          child: Column(
                            children: [
                              questionContent,
                              SizedBox(height: 40.h),
                              getOptionsContent(),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  QuizFooter(
                    currentIndex: _currentIndex,
                    quizLength: _quiz.questions.length,
                    isSpeaking: currentQuestion.type == QuestionType.speaking,
                    isAnswerChecked: _isAnswerChecked,
                    isCorrect: _isCorrect,
                    hasSelectedAnswer: _selectedAnswer != null,
                    onCheckAnswer: _checkAnswer,
                    onNextQuestion: _nextQuestion,
                    onSkipAudio: () {
                      setState(() {
                        _selectedAnswer = "skipped";
                        _isAnswerChecked = true;
                        _isCorrect = true;
                        _score++;
                      });
                      _nextQuestion();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Scaffold(
      backgroundColor: Color(0xFF080818),
      body: Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37))),
    );
  }

  Widget _buildErrorState(AppException exception) {
    return Scaffold(
      backgroundColor: const Color(0xFF080818),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.redAccent,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                ApiErrorHandler.getUserMessage(exception),
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (widget.quizLessonId != null) {
                    context.read<QuizCubit>().getLessonQuiz(
                      lessonId: widget.quizLessonId!,
                      lang: context.locale.languageCode,
                    );
                  }
                },
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
