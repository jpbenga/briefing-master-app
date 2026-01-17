import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_locales.dart';
import 'locale_persistence.dart';

class UiLocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final persistence = ref.read(localePersistenceProvider);
    final saved = persistence.loadUiLocaleCode();
    if (saved != null && saved.isNotEmpty) {
      final locale = Locale(saved);
      if (AppLocales.isSupportedUiLocale(locale)) {
        return locale;
      }
    }
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    return AppLocales.resolveUiLocale(deviceLocale);
  }

  Future<void> updateLocale(Locale locale) async {
    if (!AppLocales.isSupportedUiLocale(locale)) {
      return;
    }
    state = locale;
    await ref.read(localePersistenceProvider).saveUiLocaleCode(locale.languageCode);
  }
}

final uiLocaleProvider = NotifierProvider<UiLocaleNotifier, Locale>(UiLocaleNotifier.new);
