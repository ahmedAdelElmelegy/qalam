import 'package:equatable/equatable.dart';

abstract class VoiceTranslatorState extends Equatable {
  const VoiceTranslatorState();

  @override
  List<Object?> get props => [];
}

class VoiceTranslatorInitial extends VoiceTranslatorState {}

/// Emitted when STT hears nothing recognizable (error_no_match / timeout)
class VoiceTranslatorNoMatch extends VoiceTranslatorState {}

class VoiceTranslatorListening extends VoiceTranslatorState {
  final String partialText;

  const VoiceTranslatorListening({this.partialText = ''});

  @override
  List<Object?> get props => [partialText];
}

class VoiceTranslatorTranslating extends VoiceTranslatorState {
  final String originalText;

  const VoiceTranslatorTranslating({required this.originalText});

  @override
  List<Object?> get props => [originalText];
}

class VoiceTranslatorSuccess extends VoiceTranslatorState {
  final String userSpeech;
  final String aiArabicReply;
  final String aiTranslation;
  final bool isSpeaking;

  const VoiceTranslatorSuccess({
    required this.userSpeech,
    required this.aiArabicReply,
    required this.aiTranslation,
    this.isSpeaking = false,
  });

  @override
  List<Object?> get props => [userSpeech, aiArabicReply, aiTranslation, isSpeaking];
}

class VoiceTranslatorError extends VoiceTranslatorState {
  final String originalText;
  final String error;

  const VoiceTranslatorError({
    this.originalText = '',
    required this.error,
  });

  @override
  List<Object?> get props => [originalText, error];
}
