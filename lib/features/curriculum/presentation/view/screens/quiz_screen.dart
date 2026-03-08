import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/services/quiz_sound_service.dart';
import 'package:arabic/core/utils/network_checker.dart';
import 'package:arabic/features/curriculum/data/models/culture_model.dart';
import 'package:arabic/features/curriculum/presentation/manager/curriculum_cubit.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:arabic/features/home/presentation/view/widgets/home_bg.dart';
import 'package:arabic/features/curriculum/presentation/view/screens/lesson_content_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arabic/core/services/tts_service.dart';
import 'package:arabic/core/helpers/arabic_speech_helper.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:arabic/features/curriculum/presentation/manager/quiz/quiz_cubit.dart';
import 'package:arabic/features/curriculum/presentation/manager/cubit/sync_quiz_cubit.dart';
import 'package:arabic/features/curriculum/data/models/body/sync_quiz_request_body.dart';
import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';

class QuizScreen extends StatefulWidget {
  final Quiz? quiz;
  final String? lessonId;
  final int? quizLessonId; // Passed from API-driven lessons
  final String levelId;
  final String unitId;
  final bool isSkipQuiz;
  final bool isLevelQuiz;

  const QuizScreen({
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
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final TtsService _ttsService = TtsService();
  int _currentIndex = 0;
  String? _selectedAnswer;
  bool _isAnswerChecked = false;
  bool _isCorrect = false;
  int _score = 0;
  bool _isFinished = false;
  bool isSpeaking = false;

  // New state for Word Puzzle (reorder)
  List<String> _shuffledWords = [];
  List<String> _selectedWords = [];

  // New state for Fill in the Blank
  String? blankSelection;

  // New state for Speaking & Audio Options
  bool _isRecording = false;
  String? _activeAudioOption;
  bool _showSpeakingError = false;

  // Speech to Text
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _speechEnabled = false;
  String _recognizedWords = '';

  // New state to separate main question audio from option audio
  bool _isPlayingQuestion = false;

  // Safety flag to prevent operations after dispose
  bool _isDisposed = false;
  bool _isInitializingSpeech = false;

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
    });
  }

  Quiz? _fetchedQuiz;
  Quiz get _quiz => widget.quiz ?? _fetchedQuiz!;

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

      // Stop TTS and release the audio session before initializing speech
      // recognition, otherwise on first launch TTS holds the audio focus and
      // the microphone does not respond.
      await _ttsService.stop();

      // Note: We intentionally DO NOT initialize _speechToText here anymore.
      // Initializing in initState causes the permission dialog to appear immediately,
      // which often breaks the initialization flow on Android.
      // We defer initialize() to _toggleRecording() when the user actually taps the microphone.
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
    // Prevent double execution from overlapping STT callbacks
    if (_activeAudioOption != "checking") return;
    _activeAudioOption = null;

    final currentQuestion = _quiz.questions[_currentIndex];
    final rawAnswer = currentQuestion.correctAnswer.trim();

    // For single/short letter questions: match against the raw letter (preserving
    // أ vs ا distinction) so that _letterNames can look it up correctly.
    // Recognized words still get normalized to strip tashkeel etc.
    final actualNormalized = _normalizeArabic(_recognizedWords);
    final actualWordsNormalized = actualNormalized
        .split(' ')
        .where((w) => w.isNotEmpty)
        .toList();

    bool matched = false;

    if (rawAnswer.length <= 2) {
      // Single letter: check recognized words against the letter + its names
      for (final aWord in actualWordsNormalized) {
        if (_wordsMatch(rawAnswer, aWord)) {
          matched = true;
          break;
        }
      }
    } else {
      // Multi-word answer: use normalized comparison
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
      _selectedAnswer = userAnswer; // For UI consistency
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

    // Play sound feedback
    if (_isCorrect) {
      QuizSoundService.playCorrect();
    } else {
      QuizSoundService.playWrong();
    }
  }

  void _nextQuestion() {
    // Stop any active recording before moving to the next question
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
        // Level final exam passed → unlock the next level
        cubit.unlockNextLevel(widget.levelId);
      } else if (widget.isSkipQuiz) {
        cubit.testOutUnit(widget.levelId, widget.unitId);

        // Sync all lessons in the unit for "Test Out"
        final curriculumState = cubit.state;
        if (curriculumState is CurriculumLoaded && success) {
          try {
            final level = curriculumState.levels.firstWhere((l) => l.id == widget.levelId);
            final unit = level.units.firstWhere((u) => u.id == widget.unitId);
            
            final completions = unit.lessons.map((lesson) => Completion(
              id: lesson.id,
              dbId: lesson.dbId ?? 0,
              type: 'lesson',
              xpReward: lesson.xpReward,
              completedAt: DateTime.now(),
            )).toList();

            if (completions.isNotEmpty) {
              context.read<SyncQuizCubit>().syncQuiz(
                SyncQuizRequestBody(completions: completions),
              );
            }
          } catch (e) {
            debugPrint("Error finding unit lessons for sync: $e");
          }
        }
      } else if (widget.lessonId != null) {
        // It's a lesson quiz — mark lesson complete
        cubit.completeLesson(widget.levelId, widget.unitId, widget.lessonId!);
      } else {
        // It's a unit quiz — check if last unit BEFORE the state changes
        cubit.unlockNextUnit(widget.levelId, widget.unitId);
      }

      // Sync with server if it's a regular lesson quiz
      if (widget.lessonId != null && !widget.isSkipQuiz && success) {
        final curriculumState = cubit.state;
        if (curriculumState is CurriculumLoaded) {
          try {
            final level = curriculumState.levels.firstWhere((l) => l.id == widget.levelId);
            final unit = level.units.firstWhere((u) => u.id == widget.unitId);
            final lesson = unit.lessons.firstWhere((l) => l.id == widget.lessonId);

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

    // Network check: abort and show dialog if offline
    if (!await NetworkChecker.hasConnection()) {
      if (mounted && !_isDisposed) NetworkChecker.showNoNetworkDialog(context);
      return;
    }
    // Wait for initialization if it's currently in progress
    if (_isInitializingSpeech) {
      // Small delay to check again, or we can just return if we dont want to block.
      // But better to at least show a message or wait a bit.
      int retries = 0;
      while (_isInitializingSpeech && retries < 10) {
        await Future.delayed(const Duration(milliseconds: 200));
        retries++;
      }
    }

    // Check permission/init if not enabled
    if (!_speechEnabled) {
      if (_isInitializingSpeech) return;
      _isInitializingSpeech = true;
      try {
        _isInitializingSpeech = true;
        _speechEnabled = await _speechToText.initialize(
          onError: (error) {
            if (mounted && !_isDisposed) {
              debugPrint("Speech error: $error");
              setState(() => _isRecording = false);
            }
          },
          onStatus: (status) {
            debugPrint("Speech status: $status");
            // Only ignore status events that fire *during* the very first init call.
            // Once init is done _isInitializingSpeech = false, so all subsequent
            // auto-stop / done events are handled correctly.
            if (_isInitializingSpeech) return;
            if (mounted && !_isDisposed) {
              if (status == 'notListening' || status == 'done') {
                // Always reset recording state when STT engine stops,
                // regardless of how it stopped (auto-silence, manual, etc.)
                if (_isRecording) {
                  setState(() {
                    _isRecording = false;
                    _activeAudioOption = "checking";
                  });
                  // If finalResult hasn't arrived yet, trigger check after short delay
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (mounted &&
                        !_isDisposed &&
                        _activeAudioOption == "checking") {
                      _compareRecitation();
                    }
                  });
                } else if (_activeAudioOption != "checking") {
                  // Edge case: STT stopped but _isRecording was already false.
                  // Ensure we're not stuck in a red state.
                  setState(() => _isRecording = false);
                }
              }
            }
          },
        );

        // If we just initialized successfully (meaning permission was just granted
        // if this is the first time), give Android time to fully resume the activity
        // and hook up the audio hardware before we fire listen().
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
      // Force stop any playing TTS audio before starting mic
      await _ttsService.stop();

      // Start listening
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
          // Check if the user has finished speaking and it's a final result
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
      // Stop listening manually
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
    if (_isFinished) return _buildResultScreen();

    final currentQuestion = _quiz.questions[_currentIndex];
    final progress = (_currentIndex + 1) / _quiz.questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFF080818),
      body: Stack(
        children: [
          const Positioned.fill(child: Background3D()),
          HomeBackground(
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(progress),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 750;

                        final questionContent = Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (currentQuestion.imageUrl != null) ...[
                              _buildQuestionImage(currentQuestion.imageUrl!),
                              SizedBox(height: 24.h),
                            ],
                            _buildQuestionText(currentQuestion),
                          ],
                        );

                        final optionsContent = SingleChildScrollView(
                          padding: EdgeInsets.all(24.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (currentQuestion.type == QuestionType.reorder)
                                _buildWordPuzzle(currentQuestion)
                              else if (currentQuestion.type ==
                                  QuestionType.fillInTheBlank)
                                _buildFillInTheBlank(currentQuestion)
                              else if (currentQuestion.type ==
                                  QuestionType.audioOptions)
                                _buildAudioOptions(currentQuestion)
                              else if (currentQuestion.type ==
                                  QuestionType.speaking)
                                _buildSpeaking(currentQuestion)
                              else
                                ...currentQuestion.options.map(
                                  (opt) => _buildOption(
                                    opt,
                                    currentQuestion.correctAnswer,
                                  ),
                                ),
                            ],
                          ),
                        );

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
                              Expanded(flex: 5, child: optionsContent),
                            ],
                          );
                        }

                        return SingleChildScrollView(
                          padding: EdgeInsets.all(24.w),
                          child: Column(
                            children: [
                              questionContent,
                              SizedBox(height: 40.h),
                              if (currentQuestion.type == QuestionType.reorder)
                                _buildWordPuzzle(currentQuestion)
                              else if (currentQuestion.type ==
                                  QuestionType.fillInTheBlank)
                                _buildFillInTheBlank(currentQuestion)
                              else if (currentQuestion.type ==
                                  QuestionType.audioOptions)
                                _buildAudioOptions(currentQuestion)
                              else if (currentQuestion.type ==
                                  QuestionType.speaking)
                                _buildSpeaking(currentQuestion)
                              else
                                ...currentQuestion.options.map(
                                  (opt) => _buildOption(
                                    opt,
                                    currentQuestion.correctAnswer,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  _buildFooter(),
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

  Widget _buildWordPuzzle(Question question) {
    if (_shuffledWords.isEmpty) {
      _shuffledWords = List.from(question.options);
    }

    return Column(
      children: [
        // Selected Words Area
        Container(
          height: 120.h,
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: _isAnswerChecked
                  ? (_isCorrect ? const Color(0xFF10B981) : Colors.redAccent)
                  : Colors.white.withValues(alpha: 0.1),
              width: 1.5,
            ),
          ),
          child: Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            // textDirection: TextDirection.rtl,
            children: _selectedWords
                .map((word) => _buildWordChip(word, isSelected: true))
                .toList(),
          ),
        ),
        SizedBox(height: 40.h),
        // Word Bank
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          alignment: WrapAlignment.center,
          // textDirection: TextDirection.rtl,
          children: _shuffledWords
              .map((word) => _buildWordChip(word, isSelected: false))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildWordChip(String word, {required bool isSelected}) {
    bool isUsed = !isSelected && _selectedWords.contains(word);

    return GestureDetector(
      onTap: _isAnswerChecked || isUsed
          ? null
          : () {
              setState(() {
                if (isSelected) {
                  _selectedWords.remove(word);
                } else {
                  _selectedWords.add(word);
                  _speak(word);
                }
                // Update button state
                _selectedAnswer = _selectedWords.isEmpty
                    ? null
                    : _selectedWords.join(' ');
              });
            },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isUsed
              ? Colors.white.withValues(alpha: 0.02)
              : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD4AF37)
                : Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Text(
          word,
          style: AppTextStyles.arabicBody.copyWith(
            color: isUsed ? Colors.white24 : Colors.white,
            fontSize: 18.sp,
          ),
        ),
      ),
    ).animate().fadeIn();
  }

  Widget _buildFillInTheBlank(Question question) {
    // The question text always contains ___ where the blank is, e.g. "___بل" or "بح___" or "ت___اح"
    final parts = question.text.split('___');
    // parts[0] = before blank, parts[1] = after blank (may be empty string)
    final prefix = parts.isNotEmpty ? parts[0] : '';
    final suffix = parts.length > 1 ? parts[1] : '';

    // What to show inside the blank box:
    // - before checking: the selected letter (or empty)
    // - after checking wrong: show the correct answer in red
    final String blankContent;
    if (_isAnswerChecked && !_isCorrect) {
      blankContent = question.correctAnswer;
    } else {
      blankContent = _selectedAnswer ?? '';
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.arabicBody.copyWith(
                color: Colors.white,
                fontSize: 36.sp,
                height: 1.8,
              ),
              children: [
                // In RTL: first child renders on the RIGHT.
                // prefix = the part BEFORE the blank = start of the word = should be on the RIGHT.
                TextSpan(text: prefix),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.symmetric(horizontal: 6.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 2.h,
                    ),
                    constraints: BoxConstraints(minWidth: 44.w),
                    decoration: BoxDecoration(
                      color: _isAnswerChecked
                          ? (_isCorrect
                                ? const Color(0xFF10B981).withValues(alpha: 0.15)
                                : Colors.redAccent.withValues(alpha: 0.15))
                          : const Color(0xFFD4AF37).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border(
                        bottom: BorderSide(
                          color: _isAnswerChecked
                              ? (_isCorrect
                                    ? const Color(0xFF10B981)
                                    : Colors.redAccent)
                              : const Color(0xFFD4AF37),
                          width: 2.5,
                        ),
                      ),
                    ),
                    child: Text(
                      blankContent,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _isAnswerChecked
                            ? (_isCorrect
                                  ? const Color(0xFF10B981)
                                  : Colors.redAccent)
                            : const Color(0xFFD4AF37),
                        fontSize: 34.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppTextStyles.arabicBody.fontFamily,
                      ),
                    ),
                  ),
                ),
                // suffix in RTL is the part that appears to the LEFT of the blank (end of word)
                TextSpan(text: suffix),
              ],
            ),
          ),
        ),
        SizedBox(height: 40.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          alignment: WrapAlignment.center,
          children: question.options
              .map((opt) => _buildOption(opt, question.correctAnswer))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildAudioOptions(Question question) {
    return Column(
      children: [
        Wrap(
          spacing: 16.w,
          runSpacing: 16.h,
          alignment: WrapAlignment.center,
          children: question.options.map((opt) {
            final isActive = _activeAudioOption == opt;
            final isSelected = _selectedAnswer == opt;

            return GestureDetector(
              onTap: () => _onAudioOptionTap(opt),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 150.w,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFD4AF37).withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(25.r),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFD4AF37)
                        : Colors.white.withValues(alpha: 0.1),
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(
                              0xFFD4AF37,
                            ).withValues(alpha: 0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  children: [
                    Icon(
                          isActive
                              ? Icons.volume_up_rounded
                              : Icons.volume_down_rounded,
                          color: isSelected
                              ? const Color(0xFFD4AF37)
                              : Colors.white,
                          size: 32.sp,
                        )
                        .animate(target: isActive ? 1 : 0)
                        .scale(
                          begin: const Offset(1, 1),
                          end: const Offset(1.2, 1.2),
                        )
                        .shake(),
                    SizedBox(height: 12.h),
                    Text(
                      "Option",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSpeaking(Question question) {
    // Determine the status of this role-play turn
    final bool isChecking = _activeAudioOption == "checking";
    final bool isSuccess = _selectedAnswer == "success";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ── Role-play scenario card ──────────────────────────────────────
        // Container(
        //   width: double.infinity,
        //   padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [const Color(0xFF1A1A3A), const Color(0xFF0D0D22)],
        //       begin: Alignment.topLeft,
        //       end: Alignment.bottomRight,
        //     ),
        //     borderRadius: BorderRadius.circular(24.r),
        //     border: Border.all(
        //       color: const Color(0xFFD4AF37).withValues(alpha: 0.25),
        //       width: 1.5,
        //     ),
        //   ),
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       // AI Avatar
        //       Container(
        //         padding: EdgeInsets.all(10.w),
        //         decoration: BoxDecoration(
        //           shape: BoxShape.circle,
        //           color: const Color(0xFFD4AF37).withValues(alpha: 0.12),
        //           border: Border.all(
        //             color: const Color(0xFFD4AF37).withValues(alpha: 0.4),
        //           ),
        //         ),
        //         child: Icon(
        //           Icons.record_voice_over_rounded,
        //           color: const Color(0xFFD4AF37),
        //           size: 26.sp,
        //         ),
        //       ),
        //       SizedBox(width: 14.w),
        //       // Expanded(
        //       //   child: Column(
        //       //     crossAxisAlignment: CrossAxisAlignment.start,
        //       //     children: [
        //       //       Text(
        //       //         'سعاد',
        //       //         style: AppTextStyles.bodySmall.copyWith(
        //       //           color: const Color(0xFFD4AF37),
        //       //           fontWeight: FontWeight.w700,
        //       //           letterSpacing: 0.5,
        //       //         ),
        //       //       ),
        //       //       SizedBox(height: 4.h),
        //       //       Text(
        //       //         question.correctAnswer,
        //       //         style: AppTextStyles.arabicBody.copyWith(
        //       //           color: Colors.white,
        //       //           fontSize: 22.sp,
        //       //           height: 1.5,
        //       //         ),
        //       //         // textDirection: TextDirection.rtl,
        //       //       ),
        //       //     ],
        //       //   ),
        //       // ),
        //       // // Listen button
        //       GestureDetector(
        //         onTap: () =>
        //             _speak(question.correctAnswer, isQuestionAudio: true),
        //         child: AnimatedContainer(
        //           duration: const Duration(milliseconds: 200),
        //           padding: EdgeInsets.all(10.w),
        //           decoration: BoxDecoration(
        //             shape: BoxShape.circle,
        //             color: _isPlayingQuestion
        //                 ? const Color(0xFFD4AF37).withValues(alpha: 0.2)
        //                 : Colors.white.withValues(alpha: 0.06),
        //             border: Border.all(
        //               color: _isPlayingQuestion
        //                   ? const Color(0xFFD4AF37)
        //                   : Colors.white.withValues(alpha: 0.15),
        //             ),
        //           ),
        //           child: Icon(
        //             _isPlayingQuestion
        //                 ? Icons.graphic_eq_rounded
        //                 : Icons.volume_up_rounded,
        //             color: _isPlayingQuestion
        //                 ? const Color(0xFFD4AF37)
        //                 : Colors.white54,
        //             size: 22.sp,
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.05, end: 0),

        // SizedBox(height: 20.h),

        // ── User reply bubble ─────────────────────────────────────────────
        Align(
          alignment: Alignment.center,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            constraints: BoxConstraints(maxWidth: 280.w),
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: isSuccess
                  ? const Color(0xFF10B981).withValues(alpha: 0.12)
                  : _showSpeakingError
                  ? Colors.redAccent.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
                bottomLeft: Radius.circular(20.r),
                bottomRight: Radius.circular(20.r),
              ),
              border: Border.all(
                color: isSuccess
                    ? const Color(0xFF10B981).withValues(alpha: 0.4)
                    : _showSpeakingError
                    ? Colors.redAccent.withValues(alpha: 0.3)
                    : isChecking
                    ? Colors.blueAccent.withValues(alpha: 0.3)
                    : Colors.white.withValues(alpha: 0.08),
                width: 1.5,
              ),
            ),
            child: _recognizedWords.isNotEmpty
                ? Text(
                    _recognizedWords,
                    textAlign: TextAlign.right,
                    // textDirection: TextDirection.rtl,
                    style: AppTextStyles.arabicBody.copyWith(
                      color: isSuccess
                          ? const Color(0xFF10B981)
                          : _showSpeakingError
                          ? Colors.redAccent
                          : Colors.white,
                      fontSize: 20.sp,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : Text(
                    isChecking
                        ? 'checking'.tr()
                        : _isRecording
                        ? 'listening'.tr()
                        : 'quiz_reply_placeholder'.tr(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isChecking ? Colors.blueAccent : Colors.white30,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
          ),
        ).animate().fadeIn(delay: 200.ms),

        // ── Feedback label ────────────────────────────────────────────────
        if (isSuccess || _showSpeakingError) ...[
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSuccess ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: isSuccess ? const Color(0xFF10B981) : Colors.redAccent,
                size: 16.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                isSuccess
                    ? 'quiz_excellent'.tr()
                    : _recognizedWords.isEmpty
                    ? 'quiz_did_not_hear'.tr()
                    : 'quiz_try_again'.tr(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: isSuccess ? const Color(0xFF10B981) : Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ).animate().fadeIn().shake(hz: isSuccess ? 0 : 3),
        ],

        SizedBox(height: 32.h),

        // ── Mic button ────────────────────────────────────────────────────
        GestureDetector(
          onTap: _toggleRecording,
          child: Column(
            children: [
              AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isRecording
                          ? Colors.redAccent.withValues(alpha: 0.15)
                          : isChecking
                          ? Colors.blueAccent.withValues(alpha: 0.15)
                          : isSuccess
                          ? const Color(0xFF10B981).withValues(alpha: 0.1)
                          : const Color(0xFFD4AF37).withValues(alpha: 0.1),
                      border: Border.all(
                        color: _isRecording
                            ? Colors.redAccent
                            : isChecking
                            ? Colors.blueAccent
                            : isSuccess
                            ? const Color(0xFF10B981)
                            : const Color(0xFFD4AF37),
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              (_isRecording
                                      ? Colors.redAccent
                                      : isChecking
                                      ? Colors.blueAccent
                                      : isSuccess
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFD4AF37))
                                  .withValues(alpha: _isRecording ? 0.45 : 0.15),
                          blurRadius: _isRecording ? 24 : 12,
                          spreadRadius: _isRecording ? 4 : 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: isChecking
                          ? Icon(
                                  Icons.sync_rounded,
                                  color: Colors.blueAccent,
                                  size: 34.sp,
                                )
                                .animate(onPlay: (c) => c.repeat())
                                .rotate(duration: 800.ms)
                          : Icon(
                              _isRecording
                                  ? Icons.stop_rounded
                                  : isSuccess
                                  ? Icons.check_rounded
                                  : Icons.mic_rounded,
                              color: _isRecording
                                  ? Colors.redAccent
                                  : isSuccess
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFD4AF37),
                              size: 34.sp,
                            ),
                    ),
                  )
                  .animate(target: _isRecording ? 1 : 0)
                  .scale(
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.08, 1.08),
                    duration: 600.ms,
                    curve: Curves.easeInOut,
                  ),
              SizedBox(height: 12.h),
              Text(
                _isRecording
                    ? 'Tap to stop'
                    : isChecking
                    ? 'Checking...'
                    : isSuccess
                    ? 'Correct! Tap again to retry'
                    : 'Tap to speak',
                style: AppTextStyles.bodySmall.copyWith(
                  color: _isRecording
                      ? Colors.redAccent
                      : isChecking
                      ? Colors.blueAccent
                      : isSuccess
                      ? const Color(0xFF10B981)
                      : Colors.white54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(double progress) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10.h,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    color: const Color(0xFFD4AF37),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Text(
                '${_currentIndex + 1}/${_quiz.questions.length}',
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionImage(String url) {
    return Container(
      height: 180.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.r),
        child: Image.network(
          url,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.image_not_supported_rounded,
            color: Colors.white24,
            size: 50.w,
          ),
        ),
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildQuestionText(Question question) {
    // For fill-in-the-blank, always show a neutral instruction;
    // the word itself is displayed in _buildFillInTheBlank below.
    final String text = (question.type == QuestionType.fillInTheBlank)
        ? "Identify the missing letter" // Note: you can add `tr()` if you want
        : (question.textTranslations[context.locale.languageCode] ??
              question.text);
    final QuestionType type = question.type;
    final bool isListening = type == QuestionType.listening;

    Widget questionContent;
    if (isListening) {
      questionContent = const SizedBox.shrink();
    } else {
      // Logic to split English and Arabic text if both exist
      final RegExp arabicRegex = RegExp(
        r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]+',
      );
      if (arabicRegex.hasMatch(text) && RegExp(r'[a-zA-Z]').hasMatch(text)) {
        // Find indices to split (assuming standard "Arabic English" or "English Arabic" format)
        final arabicMatch = arabicRegex.stringMatch(text) ?? '';
        final englishPart = text.replaceAll(arabicRegex, '').trim();
        final arabicPart = arabicMatch.trim();

        if (englishPart.isNotEmpty && arabicPart.isNotEmpty) {
          questionContent = Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12.w, // Space between English and Arabic parts
            children: [
              Text(
                englishPart,
                style: AppTextStyles.h4.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                arabicPart,
                style: AppTextStyles.arabicBody.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: arabicPart.length <= 3 ? 60.sp : 32.sp,
                ),
              ),
            ],
          );
        } else {
          questionContent = _buildDefaultCenteredText(text);
        }
      } else {
        questionContent = _buildDefaultCenteredText(text);
      }
    }

    return Column(
      children: [
        questionContent,
        SizedBox(height: isListening ? 40.h : 12.h),
        if (type != QuestionType.audioOptions &&
            type != QuestionType.speaking &&
            type != QuestionType.multipleChoice)
          GestureDetector(
                onTap: () => _speak(
                  isListening
                      ? question
                            .correctAnswer /* speak the answer to listen to */
                      : (question.phonetic ?? text),
                  isQuestionAudio: true,
                ),
                child: Container(
                  width: isListening ? 80.w : null,
                  height: isListening ? 80.w : null,
                  padding: EdgeInsets.symmetric(
                    horizontal: isListening ? 0 : 24.w,
                    vertical: isListening ? 0 : 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: _isPlayingQuestion
                        ? const Color(0xFFD4AF37).withValues(alpha: 0.2)
                        : const Color(0xFFD4AF37).withValues(alpha: 0.1),
                    shape: isListening ? BoxShape.circle : BoxShape.rectangle,
                    borderRadius: isListening
                        ? null
                        : BorderRadius.circular(30.r),
                    border: Border.all(
                      color: _isPlayingQuestion
                          ? const Color(0xFFD4AF37)
                          : const Color(0xFFD4AF37).withValues(alpha: 0.3),
                      width: _isPlayingQuestion ? 2 : 1,
                    ),
                    boxShadow: _isPlayingQuestion
                        ? [
                            BoxShadow(
                              color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isPlayingQuestion
                              ? Icons.graphic_eq_rounded
                              : Icons.play_arrow_rounded,
                          color: const Color(0xFFD4AF37),
                          size: isListening ? 36.w : 28.w,
                        ),
                        if (!isListening && type == QuestionType.listening) ...[
                          // This case is handled by isListening now, but keeping for logic
                          SizedBox(width: 8.w),
                          Text(
                            'LISTEN',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: const Color(0xFFD4AF37),
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              )
              .animate(target: _isPlayingQuestion ? 1 : 0)
              .shimmer(
                duration: 1000.ms,
                color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
              ),
        if (isListening) ...[
          SizedBox(height: 20.h),
          Text(
            'Listen carefully and select the correct option',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white38),
          ),
        ],
      ],
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildDefaultCenteredText(String text) {
    final bool isArabic = RegExp(
      r'^[\u0600-\u06FF\s\u064B-\u065F]+$',
    ).hasMatch(text.trim());

    final widget = Text(
      text,
      textAlign: TextAlign.center,
      style: AppTextStyles.arabicBody.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: text.trim().length <= 3 ? 60.sp : 26.sp,
      ),
    );

    if (isArabic) {
      return widget;
    }
    return widget;
  }

  Widget _buildOption(String option, String correct) {
    bool isSelected = _selectedAnswer == option;
    bool isCorrectOption = option == correct;

    Color borderColor = Colors.white.withValues(alpha: 0.12);
    Color bgColor = Colors.white.withValues(alpha: 0.05);

    if (_isAnswerChecked) {
      if (isCorrectOption) {
        borderColor = const Color(0xFF10B981);
        bgColor = const Color(0xFF10B981).withValues(alpha: 0.1);
      } else if (isSelected && !isCorrectOption) {
        borderColor = Colors.redAccent;
        bgColor = Colors.redAccent.withValues(alpha: 0.1);
      }
    } else if (isSelected) {
      borderColor = const Color(0xFFD4AF37);
      bgColor = const Color(0xFFD4AF37).withValues(alpha: 0.1);
    }

    return GestureDetector(
      onTap: _isAnswerChecked
          ? null
          : () {
              setState(() => _selectedAnswer = option);
              _speak(option);
            },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_isAnswerChecked && isCorrectOption) ...[
              const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981)),
              SizedBox(width: 12.w),
            ] else if (_isAnswerChecked && isSelected && !isCorrectOption) ...[
              const Icon(Icons.cancel_rounded, color: Colors.redAccent),
              SizedBox(width: 12.w),
            ] else ...[
              SizedBox(width: 36.w),
            ],
            Expanded(
              child: Text(
                option,
                textAlign: TextAlign.right,
                style: AppTextStyles.arabicBody.copyWith(
                  color: Colors.white,
                  fontSize: 22.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildFooter() {
    final currentQuestion = _quiz.questions[_currentIndex];
    final isSpeaking = currentQuestion.type == QuestionType.speaking;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFF121225),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSpeaking && !_isAnswerChecked) ...[
            TextButton(
              onPressed: () {
                // Auto skip the question and give the user the score to avoid forcing pronunciation
                setState(() {
                  _selectedAnswer = "skipped";
                  _isAnswerChecked = true;
                  _isCorrect = true;
                  _score++;
                });
                _nextQuestion();
              },
              style: TextButton.styleFrom(
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                ),
              ),
              child: Text(
                'skip_audio'.tr(),
                style: AppTextStyles.h4.copyWith(
                  color: Colors.white70,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 12.h),
          ],
          ElevatedButton(
            onPressed: _selectedAnswer == null
                ? null
                : (_isAnswerChecked ? _nextQuestion : _checkAnswer),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isAnswerChecked
                  ? (_isCorrect ? const Color(0xFF10B981) : Colors.redAccent)
                  : const Color(0xFFD4AF37),
              minimumSize: Size(double.infinity, 60.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: Text(
              _currentIndex < _quiz.questions.length - 1
                  ? (_isAnswerChecked
                        ? 'quiz_continue'.tr()
                        : 'quiz_check'.tr())
                  : (_isAnswerChecked ? 'quiz_finish'.tr() : 'quiz_check'.tr()),
              style: AppTextStyles.h4.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    final success = _score / _quiz.questions.length >= _quiz.passingScore;
    final nextNav = success
        ? context.read<CurriculumCubit>().getNextNavigation(
            widget.levelId,
            widget.unitId,
            widget.lessonId,
          )
        : null;
    final nextItem = nextNav?['item'];

    String buttonText = 'quiz_finish'.tr();
    if (success && nextItem != null) {
      buttonText = nextItem is Lesson
          ? 'quiz_next_lesson'.tr()
          : 'quiz_final_challenge'.tr();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF080818),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: success
                        ? const Color(0xFFD4AF37).withValues(alpha: 0.1)
                        : Colors.white.withValues(alpha: 0.05),
                  ),
                  child: Icon(
                    success
                        ? Icons.emoji_events_rounded
                        : Icons.sentiment_very_dissatisfied_rounded,
                    size: 100.w,
                    color: success ? const Color(0xFFD4AF37) : Colors.grey,
                  ),
                )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .shimmer(
                  duration: 2000.ms,
                  color: success ? Colors.white54 : Colors.transparent,
                )
                .scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.1, 1.1),
                  duration: 1500.ms,
                  curve: Curves.easeInOut,
                ),
            SizedBox(height: 32.h),
            Text(
              success ? 'quiz_passed'.tr() : 'quiz_failed'.tr(),
              style: AppTextStyles.h1.copyWith(
                color: Colors.white,
                letterSpacing: 2,
                fontWeight: FontWeight.w900,
              ),
            ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),
            SizedBox(height: 12.h),
            Text(
              'quiz_score'.tr(args: ['$_score', '${_quiz.questions.length}']),
              style: AppTextStyles.h4.copyWith(
                color: success ? const Color(0xFF10B981) : Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(delay: 400.ms),
            SizedBox(height: 60.h),
            if (success)
              Text(
                'quiz_xp_earned'.tr(
                  args: ['${widget.lessonId != null ? 10 : 50}'],
                ),
                style: TextStyle(
                  color: const Color(0xFFD4AF37),
                  letterSpacing: 3,
                  fontWeight: FontWeight.w900,
                  fontSize: 16.sp,
                ),
              ).animate().fadeIn(delay: 800.ms).scale(),
            SizedBox(height: 40.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: ElevatedButton(
                onPressed: () {
                  if (success && nextItem != null) {
                    Navigator.pop(context); // Pop QuizScreen
                    if (widget.lessonId != null) {
                      Navigator.pop(context); // Pop LessonContentScreen
                    }

                    if (nextItem is Lesson) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LessonContentScreen(
                            lesson: nextItem,
                            levelId: nextNav!['levelId'],
                            unitId: nextNav['unitId'],
                          ),
                        ),
                      );
                    } else if (nextItem is Quiz) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizScreen(
                            quiz: nextItem,
                            levelId: nextNav!['levelId'],
                            unitId: nextNav['unitId'],
                          ),
                        ),
                      );
                    }
                  } else {
                    Navigator.pop(context);
                    if (success && widget.lessonId != null) {
                      // If we successfully finished a lesson quiz, pop the content screen too
                      Navigator.pop(context);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  minimumSize: Size(double.infinity, 60.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: AppTextStyles.h4.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
