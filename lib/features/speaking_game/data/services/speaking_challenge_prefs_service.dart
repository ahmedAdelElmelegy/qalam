import 'package:shared_preferences/shared_preferences.dart';

class SpeakingChallengePrefsService {
  final SharedPreferences _prefs;

  SpeakingChallengePrefsService(this._prefs);

  static const String _completionPrefix = 'speaking_challenge_day_';

  Future<void> markDayCompleted(int day) async {
    final now = DateTime.now();
    await _prefs.setString('$_completionPrefix$day', now.toIso8601String());
  }

  bool isDayCompleted(int day) {
    return _prefs.containsKey('$_completionPrefix$day');
  }

  bool isDayUnlocked(int day) {
    if (day == 1) return true;
    
    final prevDayStr = _prefs.getString('$_completionPrefix${day - 1}');
    if (prevDayStr == null) return false;
    
    final prevDayDate = DateTime.parse(prevDayStr);
    final now = DateTime.now();
    
    // Check if current date is strictly after prevDayDate
    final prevDayCalendar = DateTime(prevDayDate.year, prevDayDate.month, prevDayDate.day);
    final todayCalendar = DateTime(now.year, now.month, now.day);
    
    return todayCalendar.isAfter(prevDayCalendar);
  }
}
