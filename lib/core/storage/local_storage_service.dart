import 'package:hive_flutter/hive_flutter.dart';

/// Hive-backed key/value storage for non-sensitive cached data
/// (locale choice, onboarding completion, etc). Never store tokens here.
class LocalStorageService {
  LocalStorageService(this._box);

  static const boxName = 'app_prefs';

  static const languageCodeKey = 'language_code';
  static const onboardingCompleteKey = 'onboarding_complete';
  static const userProfileKey = 'user_profile';
  static const notificationsEnabledKey = 'notifications_enabled';
  static const darkModeEnabledKey = 'dark_mode_enabled';

  final Box _box;

  static Future<Box> openBox() => Hive.openBox(boxName);

  bool hasSelectedLanguage() => _box.containsKey(languageCodeKey);

  String? getLanguageCode() => _box.get(languageCodeKey) as String?;

  Future<void> setLanguageCode(String code) => _box.put(languageCodeKey, code);

  bool isOnboardingComplete() =>
      (_box.get(onboardingCompleteKey) as bool?) ?? false;

  Future<void> setOnboardingComplete() =>
      _box.put(onboardingCompleteKey, true);

  Future<void> saveUserProfile(Map<String, dynamic> profile) =>
      _box.put(userProfileKey, profile);

  Map<String, dynamic>? getUserProfile() {
    final raw = _box.get(userProfileKey);
    return raw == null ? null : Map<String, dynamic>.from(raw as Map);
  }

  Future<void> clearUserProfile() => _box.delete(userProfileKey);

  bool isNotificationsEnabled() =>
      (_box.get(notificationsEnabledKey) as bool?) ?? true;

  Future<void> setNotificationsEnabled(bool value) =>
      _box.put(notificationsEnabledKey, value);

  bool isDarkModeEnabled() =>
      (_box.get(darkModeEnabledKey) as bool?) ?? false;

  Future<void> setDarkModeEnabled(bool value) =>
      _box.put(darkModeEnabledKey, value);
}
