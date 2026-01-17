import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_locales.dart';
import 'locale_persistence.dart';

class LearningLocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final persistence = ref.read(localePersistenceProvider);
    final saved = persistence.loadLearningLocaleCode();
    if (saved != null && saved.isNotEmpty) {
      final locale = Locale(saved);
      if (AppLocales.isSupportedLearningLocale(locale)) {
        return locale;
      }
    }
    return const Locale('en');
  }

  Future<void> updateLocale(Locale locale) async {
    if (!AppLocales.isSupportedLearningLocale(locale)) {
      return;
    }
    state = locale;
    await ref.read(localePersistenceProvider).saveLearningLocaleCode(locale.languageCode);
  }
}

final learningLocaleProvider = NotifierProvider<LearningLocaleNotifier, Locale>(LearningLocaleNotifier.new);
