import 'package:flutter/material.dart';

class DynamicI18nText {
  const DynamicI18nText(this.values);

  final Map<String, String> values;

  String resolve(Locale locale) {
    final exact = values[locale.languageCode];
    if (exact != null && exact.isNotEmpty) {
      return exact;
    }
    final fallback = values['en'];
    if (fallback != null && fallback.isNotEmpty) {
      return fallback;
    }
    if (values.isNotEmpty) {
      return values.values.first;
    }
    return '';
  }
}

class Scenario {
  const Scenario({
    required this.id,
    required this.title,
    required this.description,
    required this.intent,
  });

  final String id;
  final DynamicI18nText title;
  final DynamicI18nText description;
  final DynamicI18nText intent;
}
