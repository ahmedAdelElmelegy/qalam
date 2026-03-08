import 'package:arabic/core/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local Storage Helper
/// Handles storing and retrieving data from SharedPreferences
class LocalStorage {
  // ==================== Token Methods ====================

  /// Save authentication token
  static Future<bool> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(AppConstants.userTOKEN, token);
    } catch (e) {
      return false;
    }
  }

  /// Get authentication token
  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(AppConstants.userTOKEN);
    } catch (e) {
      return null;
    }
  }

  /// Check if user is logged in (has token)
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Remove authentication token
  static Future<bool> removeToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(AppConstants.userTOKEN);
    } catch (e) {
      return false;
    }
  }

  // ==================== Language Methods ====================

  /// Save selected language code
  static Future<bool> saveLanguage(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(AppConstants.lang, languageCode);
    } catch (e) {
      return false;
    }
  }

  /// Get selected language code
  static Future<String?> getLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(AppConstants.lang);
    } catch (e) {
      return null;
    }
  }

  /// Remove selected language
  static Future<bool> removeLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(AppConstants.lang);
    } catch (e) {
      return false;
    }
  }

  // ==================== User Info Methods ====================
  static const String _userEmailKey = 'user_email';
  static const String _userFullNameKey = 'user_full_name';
  static const String _userAgeKey = 'user_age';
  static const String _userCountryKey = 'user_country';
  static const String _userLearningGoalKey = 'user_learning_goal';
  static const String _userProfileImagePathKey = 'user_profile_image';
  static const String _userEmailIdKey = 'user_email_id';

  /// Save user email
  static Future<bool> saveUserEmail(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_userEmailKey, email);
    } catch (e) {
      return false;
    }
  }

  /// Get user email
  static Future<String?> getUserEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userEmailKey);
    } catch (e) {
      return null;
    }
  }

  /// Save user full name
  static Future<bool> saveUserFullName(String fullName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_userFullNameKey, fullName);
    } catch (e) {
      return false;
    }
  }

  /// Get user full name
  static Future<String?> getUserFullName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userFullNameKey);
    } catch (e) {
      return null;
    }
  }

  /// Save user age
  static Future<bool> saveUserAge(int age) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setInt(_userAgeKey, age);
    } catch (e) {
      return false;
    }
  }

  /// Get user age
  static Future<int?> getUserAge() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_userAgeKey);
    } catch (e) {
      return null;
    }
  }

  // save email id
  // set email id
  static Future<bool> saveEmailId(int emailId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setInt(_userEmailIdKey, emailId);
    } catch (e) {
      return false;
    }
  }

  static Future<int?> getEmailId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_userEmailIdKey);
    } catch (e) {
      return null;
    }
  }

  /// Save user country
  static Future<bool> saveUserCountry(String country) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_userCountryKey, country);
    } catch (e) {
      return false;
    }
  }

  /// Get user country
  static Future<String?> getUserCountry() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userCountryKey);
    } catch (e) {
      return null;
    }
  }

  /// Save user learning goal
  static Future<bool> saveUserLearningGoal(String goal) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_userLearningGoalKey, goal);
    } catch (e) {
      return false;
    }
  }

  /// Get user learning goal
  static Future<String?> getUserLearningGoal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userLearningGoalKey);
    } catch (e) {
      return null;
    }
  }

  /// Save user profile image path
  static Future<bool> saveUserProfileImage(String path) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_userProfileImagePathKey, path);
    } catch (e) {
      return false;
    }
  }

  /// Get user profile image path
  static Future<String?> getUserProfileImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userProfileImagePathKey);
    } catch (e) {
      return null;
    }
  }

  // ==================== App Preferences ====================
  static const String _ttsSpeedKey = 'tts_speed';

  /// Save TTS speech rate
  static Future<bool> saveTtsSpeed(double speed) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setDouble(_ttsSpeedKey, speed);
    } catch (e) {
      return false;
    }
  }

  /// Get TTS speech rate (defaults to 0.42)
  static Future<double> getTtsSpeed() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble(_ttsSpeedKey) ?? 0.42;
    } catch (e) {
      return 0.42;
    }
  }

  // ==================== Lesson Completion Methods ====================
  static const String _completedLessonsPrefix = 'completed_lessons_';

  /// Get current user ID (as string)
  static Future<String> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.get(AppConstants.userId);
      return id?.toString() ?? 'anonymous';
    } catch (e) {
      return 'anonymous';
    }
  }

  /// Save lesson completion for current user
  static Future<bool> saveLessonCompletion(String lessonCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = await getUserId();
      final key = '$_completedLessonsPrefix$userId';
      
      final completed = prefs.getStringList(key) ?? [];
      if (!completed.contains(lessonCode)) {
        completed.add(lessonCode);
        return await prefs.setStringList(key, completed);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get completed lesson codes for current user
  static Future<List<String>> getCompletedLessons() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = await getUserId();
      final key = '$_completedLessonsPrefix$userId';
      return prefs.getStringList(key) ?? [];
    } catch (e) {
      return [];
    }
  }

  /// Check if a lesson is completed for current user
  static Future<bool> isLessonCompleted(String lessonCode) async {
    final completed = await getCompletedLessons();
    return completed.contains(lessonCode);
  }

  // ==================== Clear Methods ====================

  /// Clear all stored data (logout)
  static Future<bool> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.clear();
    } catch (e) {
      return false;
    }
  }

  /// Clear only user data (keep preferences like language)
  static Future<void> clearUserData() async {
    await removeToken();
    // await _instance.remove(_userEmailKey);
    // await _instance.remove(_userFullNameKey);
  }
}
