// lib/utils/validation.dart

class Validation {
  // ---------- Basic ----------
  static bool isEmpty(String? v) => v == null || v.trim().isEmpty;

  static bool isEmail(String? v) {
    if (isEmpty(v)) return false;
    final value = v!.trim();
    final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');
    return regex.hasMatch(value);
  }

  static bool isPhone(String? v) {
    if (isEmpty(v)) return false;
    final value = v!.trim();
    // Loose: allows +, spaces, dashes, parentheses
    final regex = RegExp(r'^\+?[\d\s\-\(\)]{7,}$');
    return regex.hasMatch(value);
  }

  static bool isUrl(String? v) {
    if (isEmpty(v)) return false;
    final value = v!.trim();
    final uri = Uri.tryParse(value);
    return uri != null && (uri.hasScheme && uri.host.isNotEmpty);
  }

  static bool isNumber(String? v) {
    if (isEmpty(v)) return false;
    return num.tryParse(v!.trim()) != null;
  }

  static bool isInt(String? v) {
    if (isEmpty(v)) return false;
    return int.tryParse(v!.trim()) != null;
  }

  static bool inRangeNum(String? v, num min, num max) {
    final n = num.tryParse((v ?? '').trim());
    if (n == null) return false;
    return n >= min && n <= max;
  }

  // ---------- Length ----------
  static bool minLength(String? v, int min) => (v ?? '').trim().length >= min;
  static bool maxLength(String? v, int max) => (v ?? '').trim().length <= max;
  static bool exactLength(String? v, int len) => (v ?? '').trim().length == len;

  // ---------- Password ----------
  static bool strongPassword(
    String? v, {
    int min = 8,
    bool upper = false,
    bool lower = false,
    bool number = true,
    bool special = false,
  }) {
    if (isEmpty(v)) return false;
    final value = v!;

    if (value.length < min) return false;
    if (upper && !RegExp(r'[A-Z]').hasMatch(value)) return false;
    if (lower && !RegExp(r'[a-z]').hasMatch(value)) return false;
    if (number && !RegExp(r'[0-9]').hasMatch(value)) return false;
    if (special && !RegExp(r'[^\w\s]').hasMatch(value)) return false;

    return true;
  }

  // ---------- Common TextFormField validators ----------
  static String? requiredField(String? v, {String message = 'Required'}) {
    return isEmpty(v) ? '$message is Required' : null;
  }

  static String? emailField(String? v, {String message = 'Invalid email'}) {
    if (isEmpty(v)) return 'Email is Required';
    return isEmail(v) ? null : "Enter a valid Email";
  }

  static String? phoneField(String? v, {String message = 'Invalid phone'}) {
    if (isEmpty(v)) return '$message is Required';
    return isPhone(v) ? null : message;
  }

  static String? minLenField(String? v, int min, {String? message}) {
    if (isEmpty(v)) return 'Required';
    return minLength(v, min) ? null : (message ?? 'Minimum $min characters');
  }

  static String? passwordField(
    String? v, {
    int min = 8,
    String weakMessage = 'Password',
  }) {
    if (isEmpty(v)) return ' $weakMessage is Required';
    return strongPassword(v, min: min)
        ? null
        : ' $weakMessage must be at least $min characters';
  }
}
