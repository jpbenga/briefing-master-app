import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main()');
});

class LocalePersistence {
  LocalePersistence(this._prefs);

  static const String uiLocaleKey = 'tbm_ui_locale';
  static const String learningLocaleKey = 'tbm_learning_locale';

  final SharedPreferences _prefs;

  String? loadUiLocaleCode() => _prefs.getString(uiLocaleKey);

  String? loadLearningLocaleCode() => _prefs.getString(learningLocaleKey);

  Future<void> saveUiLocaleCode(String code) => _prefs.setString(uiLocaleKey, code);

  Future<void> saveLearningLocaleCode(String code) => _prefs.setString(learningLocaleKey, code);
}

final localePersistenceProvider = Provider<LocalePersistence>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalePersistence(prefs);
});
