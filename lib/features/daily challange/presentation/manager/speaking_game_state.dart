import 'package:arabic/features/daily%20challange/data/models/question_model.dart';
import 'package:equatable/equatable.dart';

abstract class SpeakingGameState extends Equatable {
  const SpeakingGameState();

  @override
  List<Object?> get props => [];
}

class SpeakingGameInitial extends SpeakingGameState {}

class SpeakingGameLoading extends SpeakingGameState {}

class SpeakingGameLoaded extends SpeakingGameState {
  final List<QuestionModel> cards;
  final int
  currentCardIndex; // Unused if we just pop from top, but good for progress
  final int correctAnswers;
  final int totalCards;
  final String recognizedText;
  final bool isListening;

  const SpeakingGameLoaded({
    required this.cards,
    this.currentCardIndex = 0,
    required this.correctAnswers,
    required this.totalCards,
    this.recognizedText = '',
    this.isListening = false,
  });

  SpeakingGameLoaded copyWith({
    List<QuestionModel>? cards,
    int? currentCardIndex,
    int? correctAnswers,
    int? totalCards,
    String? recognizedText,
    bool? isListening,
  }) {
    return SpeakingGameLoaded(
      cards: cards ?? this.cards,
      currentCardIndex: currentCardIndex ?? this.currentCardIndex,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      totalCards: totalCards ?? this.totalCards,
      recognizedText: recognizedText ?? this.recognizedText,
      isListening: isListening ?? this.isListening,
    );
  }

  @override
  List<Object?> get props => [
    cards,
    currentCardIndex,
    correctAnswers,
    totalCards,
    recognizedText,
    isListening,
  ];
}

class SpeakingGameChecking extends SpeakingGameState {}

class SpeakingGameCorrect extends SpeakingGameState {
  final QuestionModel card;

  const SpeakingGameCorrect({required this.card});

  @override
  List<Object?> get props => [card];
}

class SpeakingGameIncorrect extends SpeakingGameState {
  final QuestionModel card;
  final String recognizedText;

  const SpeakingGameIncorrect({
    required this.card,
    required this.recognizedText,
  });

  @override
  List<Object?> get props => [card, recognizedText];
}

class SpeakingGameOver extends SpeakingGameState {
  final bool isWin;
  final int percentage;

  const SpeakingGameOver({required this.isWin, required this.percentage});

  @override
  List<Object?> get props => [isWin, percentage];
}

class SpeakingGameError extends SpeakingGameState {
  final String message;

  const SpeakingGameError({required this.message});

  @override
  List<Object?> get props => [message];
}
