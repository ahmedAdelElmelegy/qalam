import 'package:equatable/equatable.dart';
import 'package:arabic/features/chat/data/models/chat_model.dart';
import 'package:arabic/features/roleplay/data/models/roleplay_response_model.dart';

abstract class VoiceRoleplayState extends Equatable {
  const VoiceRoleplayState();

  @override
  List<Object?> get props => [];
}

class VoiceRoleplayInitial extends VoiceRoleplayState {}

class VoiceRoleplayListening extends VoiceRoleplayState {
  final List<ChatMessage> history;
  final String recognizedText;

  const VoiceRoleplayListening({required this.history, required this.recognizedText});

  @override
  List<Object?> get props => [history, recognizedText];
}

class VoiceRoleplayProcessing extends VoiceRoleplayState {
  final List<ChatMessage> history;

  const VoiceRoleplayProcessing({required this.history});

  @override
  List<Object?> get props => [history];
}

class VoiceRoleplaySpeaking extends VoiceRoleplayState {
  final List<ChatMessage> history;
  final RoleplayResponseModel response;

  const VoiceRoleplaySpeaking({required this.history, required this.response});

  @override
  List<Object?> get props => [history, response];
}

class VoiceRoleplayIdle extends VoiceRoleplayState {
  final List<ChatMessage> history;
  final RoleplayResponseModel? lastResponse;

  const VoiceRoleplayIdle({required this.history, this.lastResponse});

  @override
  List<Object?> get props => [history, lastResponse];
}

class VoiceRoleplayError extends VoiceRoleplayState {
  final List<ChatMessage> history;
  final String error;

  const VoiceRoleplayError({required this.history, required this.error});

  @override
  List<Object?> get props => [history, error];
}
