class LearningLanguage {
  const LearningLanguage({
    required this.code,
    required this.nameNative,
    required this.nameEnglish,
    this.flagEmoji,
    required this.sttLocale,
    required this.ttsVoice,
    required this.llmPromptLanguage,
  });

  final String code;
  final String nameNative;
  final String nameEnglish;
  final String? flagEmoji;

  /// Placeholder: used by future STT configuration.
  final String sttLocale;

  /// Placeholder: used by future TTS configuration.
  final String ttsVoice;

  /// Placeholder: used by future LLM prompt language.
  final String llmPromptLanguage;
}
