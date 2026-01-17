import 'package:flutter/material.dart';

class AppLocales {
  static const List<Locale> supportedUiLocales = [
    Locale('en'),
    Locale('fr'),
    Locale('es'),
    Locale('pt'),
    Locale('de'),
  ];

  static const List<String> supportedLearningLanguageCodes = [
    'en',
    'fr',
    'es',
    'pt',
    'de',
  ];

  static Locale resolveUiLocale(Locale locale) {
    if (isSupportedUiLocale(locale)) {
      return Locale(locale.languageCode);
    }
    return const Locale('en');
  }

  static bool isSupportedUiLocale(Locale locale) {
    return supportedUiLocales.any((supported) => supported.languageCode == locale.languageCode);
  }

  static bool isSupportedLearningLocale(Locale locale) {
    return supportedLearningLanguageCodes.contains(locale.languageCode);
  }
}
