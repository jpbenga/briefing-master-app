import 'learning_language.dart';

class LanguageCatalog {
  static const List<LearningLanguage> supported = [
    LearningLanguage(
      code: 'en',
      nameNative: 'English',
      nameEnglish: 'English',
      flagEmoji: '🇺🇸',
      sttLocale: 'en-US',
      ttsVoice: 'en-US-neutral',
      llmPromptLanguage: 'English',
    ),
    LearningLanguage(
      code: 'fr',
      nameNative: 'Français',
      nameEnglish: 'French',
      flagEmoji: '🇫🇷',
      sttLocale: 'fr-FR',
      ttsVoice: 'fr-FR-neutral',
      llmPromptLanguage: 'French',
    ),
    LearningLanguage(
      code: 'es',
      nameNative: 'Español',
      nameEnglish: 'Spanish',
      flagEmoji: '🇪🇸',
      sttLocale: 'es-ES',
      ttsVoice: 'es-ES-neutral',
      llmPromptLanguage: 'Spanish',
    ),
    LearningLanguage(
      code: 'pt',
      nameNative: 'Português',
      nameEnglish: 'Portuguese',
      flagEmoji: '🇵🇹',
      sttLocale: 'pt-PT',
      ttsVoice: 'pt-PT-neutral',
      llmPromptLanguage: 'Portuguese',
    ),
    LearningLanguage(
      code: 'de',
      nameNative: 'Deutsch',
      nameEnglish: 'German',
      flagEmoji: '🇩🇪',
      sttLocale: 'de-DE',
      ttsVoice: 'de-DE-neutral',
      llmPromptLanguage: 'German',
    ),
  ];

  static LearningLanguage? byCode(String code) {
    for (final language in supported) {
      if (language.code == code) {
        return language;
      }
    }
    return null;
  }
}
