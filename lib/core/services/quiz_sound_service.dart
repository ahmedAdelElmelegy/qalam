import 'package:audioplayers/audioplayers.dart';

/// Plays short sound effects for quiz feedback (correct / wrong).
class QuizSoundService {
  static final AudioPlayer _player = AudioPlayer();

  /// Call this once in main() or app startup to pre-load the player.
  static Future<void> init() async {
    await _player.setReleaseMode(ReleaseMode.stop);
  }

  /// Plays the "correct answer" sound.
  static Future<void> playCorrect() async {
    await _player.stop();
    await _player.play(AssetSource('audio/correct.mp3'));
  }

  /// Plays the "wrong answer" sound.
  static Future<void> playWrong() async {
    await _player.stop();
    await _player.play(AssetSource('audio/wrong.mp3'));
  }

  static Future<void> dispose() async {
    await _player.dispose();
  }
}
