import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';
import '../dynamic_content/dynamic_i18n_models.dart';
import '../dynamic_content/dynamic_i18n_provider.dart';
import '../i18n/learning_locale_provider.dart';
import 'language_catalog.dart';
import '../ui/toasts.dart';

class LearningClusterContent {
  const LearningClusterContent({
    required this.intent,
    required this.tier1,
    required this.tier2,
    required this.tier3,
    required this.connectors,
    required this.powerVerbs,
  });

  final String intent;
  final List<String> tier1;
  final List<String> tier2;
  final List<String> tier3;
  final List<String> connectors;
  final List<String> powerVerbs;
}

class LearningClusters {
  static const String sharingBadNews = _clusterSharingBadNews;
  static const String reportingDelay = _clusterReportingDelay;
}

class TierUpgrade {
  const TierUpgrade({required this.tier2, required this.tier3, required this.rationale});

  final String tier2;
  final String tier3;
  final String rationale;
}

class CoachTip {
  const CoachTip({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
  });

  final String id;
  final ToastType type;
  final String title;
  final String body;
}

class QuizPrompt {
  const QuizPrompt({
    required this.cue,
    required this.good,
    required this.synonyms,
  });

  final String cue;
  final String good;
  final List<String> synonyms;
}

class QuizFeedback {
  const QuizFeedback({
    required this.timesUpMessage,
    required this.timesUpHaptic,
    required this.correctMessage,
    required this.correctHaptic,
    required this.notQuiteMessage,
    required this.notQuiteHaptic,
  });

  final String timesUpMessage;
  final String timesUpHaptic;
  final String correctMessage;
  final String correctHaptic;
  final String notQuiteMessage;
  final String notQuiteHaptic;
}

class SpeakingPrompt {
  const SpeakingPrompt({
    required this.primary,
    required this.secondary,
  });

  final String primary;
  final String secondary;
}

class LearningContentResolver {
  LearningContentResolver({
    required this.learningLocale,
    required this.profile,
    required this.scenarios,
  });

  final Locale learningLocale;
  final UserProfile profile;
  final List<Scenario> scenarios;

  String get languageCode => learningLocale.languageCode;

  LearningLanguage? get learningLanguage => LanguageCatalog.byCode(languageCode);

  /// Placeholder hooks for future AI integrations.
  String sttLocaleCode() => learningLanguage?.sttLocale ?? 'en-US';

  String ttsVoice() => learningLanguage?.ttsVoice ?? 'en-US-neutral';

  String llmPromptLanguage() => learningLanguage?.llmPromptLanguage ?? 'English';

  Scenario scenarioForCluster(String clusterId) {
    final scenario = scenarios.firstWhere(
      (item) => item.id == _clusterScenarioMap[clusterId],
      orElse: () => scenarios.first,
    );
    return scenario;
  }

  String scenarioTitle(Scenario scenario) => scenario.title.resolve(learningLocale);

  String scenarioDescription(Scenario scenario) => scenario.description.resolve(learningLocale);

  LearningClusterContent clusterContent(String clusterId) {
    final data = _clusterPools[clusterId] ?? _clusterPools[_clusterSharingBadNews]!;
    return LearningClusterContent(
      intent: _resolveText(data.intent),
      tier1: _resolveList(data.tier1),
      tier2: _resolveList(data.tier2),
      tier3: _resolveList(data.tier3),
      connectors: _resolveList(data.connectors),
      powerVerbs: _resolveList(data.powerVerbs),
    );
  }

  List<String> availableClusters() => _clusterPools.keys.toList(growable: false);

  String clusterLabel(String clusterId) {
    final data = _clusterPools[clusterId] ?? _clusterPools[_clusterSharingBadNews]!;
    return _resolveText(data.intent);
  }

  String detectIntentCluster(String text) {
    final lower = text.toLowerCase();
    final keywords = _intentKeywords[languageCode] ?? _intentKeywords['en']!;
    for (final entry in keywords.entries) {
      if (entry.value.any(lower.contains)) {
        return entry.key;
      }
    }
    return _clusterSharingBadNews;
  }

  TierUpgrade generateTierUpgrade(String clusterId) {
    final data = _clusterPools[clusterId] ?? _clusterPools[_clusterSharingBadNews]!;
    final tier2 = _pickRandom(_resolveList(data.tier2));
    final tier3 = _pickRandom(_resolveList(data.tier3));
    final connectors = _resolveList(data.connectors);
    final powerVerbs = _resolveList(data.powerVerbs);
    final rationaleTemplate = _resolveText(_rationaleTemplates);
    return TierUpgrade(
      tier2: tier2,
      tier3: tier3,
      rationale: rationaleTemplate
          .replaceAll('{connector}', _pickRandom(connectors))
          .replaceAll('{powerVerb}', _pickRandom(powerVerbs)),
    );
  }

  SpeakingPrompt speakingPrompt() {
    final primaryTemplate = _resolveText(_speakingPromptPrimary);
    final secondaryTemplate = _resolveText(_speakingPromptSecondary);
    return SpeakingPrompt(
      primary: primaryTemplate.replaceAll('{metric}', profile.dashboardMetric),
      secondary: secondaryTemplate,
    );
  }

  String tier3BackInstruction() {
    return _resolveText(_tier3BackInstruction);
  }

  String battleCardTemplate() {
    return _resolveText(_battleCardTemplate).replaceAll('{metric}', profile.dashboardMetric);
  }

  List<String> speakingSeedCandidates(String clusterId) {
    final templates = _speakingSeedTemplates[languageCode] ?? _speakingSeedTemplates['en'] ?? const [];
    final connector = pickRandomConnector(clusterId);
    return templates
        .map((template) => template
            .replaceAll('{metric}', profile.dashboardMetric)
            .replaceAll('{connector}', connector))
        .toList(growable: false);
  }

  String pickRandomSeed(List<String> items) {
    return _pickRandom(items);
  }

  String upgradeToastTitle() => _resolveText(_upgradeToastTitle);

  String upgradeToastBody() => _resolveText(_upgradeToastBody);

  List<CoachTip> coachTips() {
    return _coachTips.map((tip) {
      return CoachTip(
        id: tip.id,
        type: tip.type,
        title: _resolveText(tip.title),
        body: _resolveText(tip.body).replaceAll('{metric}', profile.dashboardMetric),
      );
    }).toList(growable: false);
  }

  List<QuizPrompt> quizPrompts() {
    return _quizPrompts.map((prompt) {
      return QuizPrompt(
        cue: _resolveText(prompt.cue).replaceAll('{metric}', profile.dashboardMetric),
        good: _resolveText(prompt.good).replaceAll('{metric}', profile.dashboardMetric),
        synonyms: _resolveList(prompt.synonyms),
      );
    }).toList(growable: false);
  }

  QuizFeedback quizFeedback() {
    return QuizFeedback(
      timesUpMessage: _resolveText(_quizTimesUpMessage),
      timesUpHaptic: _resolveText(_quizTimesUpHaptic),
      correctMessage: _resolveText(_quizCorrectMessage),
      correctHaptic: _resolveText(_quizCorrectHaptic),
      notQuiteMessage: _resolveText(_quizNotQuiteMessage),
      notQuiteHaptic: _resolveText(_quizNotQuiteHaptic),
    );
  }

  int computeSophisticationScore(String text) {
    final lower = text.toLowerCase();
    var score = 42;

    final filler = _resolveList(_fillerWords);
    final fillerHits = filler.where(lower.contains).length;
    score -= fillerHits * 6;

    final rewards = _resolveList(_rewardWords);
    final rewardHits = rewards.where(lower.contains).length;
    score += rewardHits * 7;

    final structure = _resolveList(_structureWords);
    final structureHits = structure.where(lower.contains).length;
    score += structureHits * 5;

    if (text.trim().length < 40) score -= 7;
    if (text.trim().length > 240) score -= 4;

    return _clamp(score.toDouble(), 0, 100).round();
  }

  String pickRandomConnector(String clusterId) {
    final data = _clusterPools[clusterId] ?? _clusterPools[_clusterSharingBadNews]!;
    return _pickRandom(_resolveList(data.connectors));
  }

  String pickRandomTierSentence(String clusterId, int tier) {
    final data = _clusterPools[clusterId] ?? _clusterPools[_clusterSharingBadNews]!;
    final list = switch (tier) {
      1 => data.tier1,
      2 => data.tier2,
      _ => data.tier3,
    };
    return _pickRandom(_resolveList(list));
  }

  List<String> _resolveList(Map<String, List<String>> values) {
    final exact = values[languageCode];
    if (exact != null && exact.isNotEmpty) {
      return exact;
    }
    final fallback = values['en'];
    if (fallback != null && fallback.isNotEmpty) {
      return fallback;
    }
    return values.values.isNotEmpty ? values.values.first : const [];
  }

  String _resolveText(Map<String, String> values) {
    final exact = values[languageCode];
    if (exact != null && exact.isNotEmpty) {
      return exact;
    }
    final fallback = values['en'];
    if (fallback != null && fallback.isNotEmpty) {
      return fallback;
    }
    return values.values.isNotEmpty ? values.values.first : '';
  }

  String _pickRandom(List<String> items) {
    final random = Random();
    return items[random.nextInt(items.length)];
  }

  double _clamp(double value, double min, double max) {
    return value.clamp(min, max);
  }
}

class _ClusterPoolData {
  const _ClusterPoolData({
    required this.intent,
    required this.tier1,
    required this.tier2,
    required this.tier3,
    required this.connectors,
    required this.powerVerbs,
  });

  final Map<String, String> intent;
  final Map<String, List<String>> tier1;
  final Map<String, List<String>> tier2;
  final Map<String, List<String>> tier3;
  final Map<String, List<String>> connectors;
  final Map<String, List<String>> powerVerbs;
}

class _CoachTipData {
  const _CoachTipData({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
  });

  final String id;
  final ToastType type;
  final Map<String, String> title;
  final Map<String, String> body;
}

class _QuizPromptData {
  const _QuizPromptData({
    required this.cue,
    required this.good,
    required this.synonyms,
  });

  final Map<String, String> cue;
  final Map<String, String> good;
  final Map<String, List<String>> synonyms;
}

const String _clusterSharingBadNews = 'sharing_bad_news';
const String _clusterReportingDelay = 'reporting_delay';

const Map<String, String> _clusterScenarioMap = {
  _clusterSharingBadNews: 'crisis_revenue_drop',
  _clusterReportingDelay: 'reporting_delay',
};

const Map<String, Map<String, List<String>>> _intentKeywords = {
  'en': {
    _clusterReportingDelay: ['delay', 'eta', 'blocked'],
    _clusterSharingBadNews: ['revenue', 'down', 'variance', 'forecast', 'problem'],
  },
  'fr': {
    _clusterReportingDelay: ['retard', 'eta', 'bloqué', 'dépendance'],
    _clusterSharingBadNews: ['revenu', 'baisse', 'variance', 'prévision', 'problème'],
  },
  'es': {
    _clusterReportingDelay: ['retraso', 'eta', 'bloqueado', 'dependencia'],
    _clusterSharingBadNews: ['ingresos', 'baja', 'variación', 'pronóstico', 'problema'],
  },
  'pt': {
    _clusterReportingDelay: ['atraso', 'eta', 'bloqueado', 'dependência'],
    _clusterSharingBadNews: ['receita', 'queda', 'variação', 'previsão', 'problema'],
  },
  'de': {
    _clusterReportingDelay: ['verzögerung', 'eta', 'blockiert', 'abhängigkeit'],
    _clusterSharingBadNews: ['umsatz', 'rückgang', 'abweichung', 'prognose', 'problem'],
  },
};

const Map<String, List<String>> _fillerWords = {
  'en': ['uh', 'um', 'like', 'you know', 'basically', 'sort of', 'kinda'],
  'fr': ['euh', 'hein', 'genre', 'tu vois', 'en fait', 'un peu', 'quoi'],
  'es': ['eh', 'este', 'o sea', 'sabes', 'básicamente', 'como que', 'pues'],
  'pt': ['hã', 'é', 'tipo', 'sabe', 'basicamente', 'meio que', 'né'],
  'de': ['äh', 'hm', 'sozusagen', 'weißt du', 'eigentlich', 'irgendwie', 'halt'],
};

const Map<String, List<String>> _rewardWords = {
  'en': ['root cause', 'mitigation', 'risk', 'stabilize', 'timeline', 'impact', 'therefore', 'as a result', 'net-net'],
  'fr': [
    'cause racine',
    'atténuation',
    'risque',
    'stabiliser',
    'calendrier',
    'impact',
    'donc',
    'par conséquent',
    'net-net'
  ],
  'es': [
    'causa raíz',
    'mitigación',
    'riesgo',
    'estabilizar',
    'cronograma',
    'impacto',
    'por lo tanto',
    'como resultado',
    'net-net'
  ],
  'pt': [
    'causa raiz',
    'mitigação',
    'risco',
    'estabilizar',
    'cronograma',
    'impacto',
    'portanto',
    'como resultado',
    'net-net'
  ],
  'de': [
    'ursache',
    'minderung',
    'risiko',
    'stabilisieren',
    'zeitplan',
    'auswirkung',
    'daher',
    'als resultat',
    'net-net'
  ],
};

const Map<String, List<String>> _structureWords = {
  'en': ['first', 'second', 'third', 'to summarize', 'in short', 'my recommendation'],
  'fr': ['premièrement', 'deuxièmement', 'troisièmement', 'pour résumer', 'en bref', 'ma recommandation'],
  'es': ['primero', 'segundo', 'tercero', 'para resumir', 'en breve', 'mi recomendación'],
  'pt': ['primeiro', 'segundo', 'terceiro', 'para resumir', 'em resumo', 'minha recomendação'],
  'de': ['erstens', 'zweitens', 'drittens', 'zusammenfassend', 'kurz gesagt', 'meine empfehlung'],
};

const Map<String, String> _rationaleTemplates = {
  'en': 'Upgrade via executive structure + measurable commitments. Add connectors like “{connector}” and a power verb like “{powerVerb}”.',
  'fr':
      'Montez en gamme avec une structure exécutive + des engagements mesurables. Ajoutez un connecteur comme « {connector} » et un verbe d’action comme « {powerVerb} ».',
  'es':
      'Sube de nivel con estructura ejecutiva + compromisos medibles. Añade conectores como “{connector}” y un verbo de poder como “{powerVerb}”.',
  'pt':
      'Evolua com estrutura executiva + compromissos mensuráveis. Adicione conectores como “{connector}” e um verbo de ação como “{powerVerb}”.',
  'de':
      'Steigere das Niveau mit Executive-Struktur + messbaren Zusagen. Füge Konnektoren wie „{connector}“ und ein Power-Verb wie „{powerVerb}“ hinzu.',
};

const Map<String, String> _speakingPromptPrimary = {
  'en': 'Explain why {metric} happened, and propose a recovery plan.',
  'fr': 'Expliquez pourquoi {metric} est arrivé et proposez un plan de reprise.',
  'es': 'Explica por qué ocurrió {metric} y propone un plan de recuperación.',
  'pt': 'Explique por que {metric} aconteceu e proponha um plano de recuperação.',
  'de': 'Erkläre, warum {metric} passiert ist, und schlage einen Erholungsplan vor.',
};

const Map<String, String> _speakingPromptSecondary = {
  'en': 'Speak like leadership is listening. No apologies. Commit to action.',
  'fr': 'Parlez comme si la direction écoutait. Pas d’excuses. Engagez-vous.',
  'es': 'Habla como si la dirección escuchara. Sin disculpas. Comprométete.',
  'pt': 'Fale como se a liderança estivesse ouvindo. Sem desculpas. Assuma compromissos.',
  'de': 'Sprich, als ob die Führung zuhört. Keine Entschuldigungen. Verpflichte dich zum Handeln.',
};

const Map<String, String> _tier3BackInstruction = {
  'en': 'Now commit: timeline + impact + mitigation.',
  'fr': 'Engagez-vous maintenant : calendrier + impact + atténuation.',
  'es': 'Comprométete ahora: cronograma + impacto + mitigación.',
  'pt': 'Comprometa-se agora: cronograma + impacto + mitigação.',
  'de': 'Jetzt festlegen: Zeitplan + Impact + Minderung.',
};

const Map<String, List<String>> _speakingSeedTemplates = {
  'en': [
    'So, uh, we have a problem. {metric}. I’m looking into it and we will fix it soon.',
    'First, {metric}. Second, we identified two drivers. Therefore, we are executing a mitigation plan and will provide a revised timeline within the hour.',
    'Net-net: {metric}. My recommendation is to stabilize churn risk, quantify impact, and align on corrective actions today.',
    '{connector}: the variance is material. We’re investigating root cause and confirming corrective actions with a measurable ETA.',
  ],
  'fr': [
    'Alors, euh, nous avons un problème. {metric}. J’enquête et nous réglerons ça bientôt.',
    'Premièrement, {metric}. Deuxièmement, nous avons identifié deux facteurs. Donc, nous déployons un plan d’atténuation et fournirons un calendrier révisé dans l’heure.',
    'Net-net : {metric}. Ma recommandation est de stabiliser le churn, quantifier l’impact et aligner les actions correctives aujourd’hui.',
    '{connector} : la variance est significative. Nous analysons la cause racine et confirmons des actions correctives avec un ETA mesurable.',
  ],
  'es': [
    'Entonces, eh, tenemos un problema. {metric}. Lo estoy revisando y lo resolveremos pronto.',
    'Primero, {metric}. Segundo, identificamos dos factores. Por lo tanto, estamos ejecutando un plan de mitigación y daremos un cronograma revisado en una hora.',
    'En resumen: {metric}. Mi recomendación es estabilizar el churn, cuantificar el impacto y alinear acciones correctivas hoy.',
    '{connector}: la variación es material. Investigamos la causa raíz y confirmamos acciones correctivas con un ETA medible.',
  ],
  'pt': [
    'Então, hum, temos um problema. {metric}. Estou analisando e vamos resolver em breve.',
    'Primeiro, {metric}. Segundo, identificamos dois fatores. Portanto, estamos executando um plano de mitigação e forneceremos um cronograma revisado dentro de uma hora.',
    'Em resumo: {metric}. Minha recomendação é estabilizar o churn, quantificar o impacto e alinhar ações corretivas hoje.',
    '{connector}: a variação é material. Estamos investigando a causa raiz e confirmando ações corretivas com um ETA mensurável.',
  ],
  'de': [
    'Also, äh, wir haben ein Problem. {metric}. Ich schaue es mir an und wir beheben es bald.',
    'Erstens, {metric}. Zweitens haben wir zwei Treiber identifiziert. Daher setzen wir einen Minderungsplan um und liefern innerhalb einer Stunde einen revidierten Zeitplan.',
    'Net-net: {metric}. Meine Empfehlung ist, Churn zu stabilisieren, den Impact zu quantifizieren und heute Korrekturmaßnahmen abzustimmen.',
    '{connector}: die Abweichung ist wesentlich. Wir untersuchen die Ursache und bestätigen Korrekturmaßnahmen mit einer messbaren ETA.',
  ],
};

const Map<String, String> _upgradeToastTitle = {
  'en': 'Upgrade Ready',
  'fr': 'Upgrade prêt',
  'es': 'Mejora lista',
  'pt': 'Upgrade pronto',
  'de': 'Upgrade bereit',
};

const Map<String, String> _upgradeToastBody = {
  'en': 'Your Tier 3 rewrite is prepared. Apply it for the Aha moment.',
  'fr': 'Votre réécriture Tier 3 est prête. Appliquez-la pour l’effet “Aha”.',
  'es': 'Tu reescritura Tier 3 está lista. Aplícala para el momento “Aha”.',
  'pt': 'Sua reescrita Tier 3 está pronta. Aplique-a para o momento “Aha”.',
  'de': 'Deine Tier-3-Umschreibung ist bereit. Wende sie für den Aha-Moment an.',
};

const Map<String, String> _battleCardTemplate = {
  'en':
      'Net-net: {metric}. We’ve identified the primary drivers, and we’re executing a mitigation plan now. My recommendation is to stabilize the trend within 2 weeks, while preserving customer trust. I’ll confirm corrective actions and a revised timeline within the hour.',
  'fr':
      'Net-net : {metric}. Nous avons identifié les facteurs principaux et exécutons un plan d’atténuation. Ma recommandation est de stabiliser la tendance sous 2 semaines tout en préservant la confiance client. Je confirmerai les actions correctives et un calendrier révisé dans l’heure.',
  'es':
      'En resumen: {metric}. Identificamos los factores principales y ejecutamos un plan de mitigación. Mi recomendación es estabilizar la tendencia en 2 semanas mientras preservamos la confianza del cliente. Confirmaré acciones correctivas y un cronograma revisado dentro de la hora.',
  'pt':
      'Em resumo: {metric}. Identificamos os principais fatores e estamos executando um plano de mitigação. Minha recomendação é estabilizar a tendência em 2 semanas, preservando a confiança do cliente. Confirmarei ações corretivas e um cronograma revisado dentro de uma hora.',
  'de':
      'Net-net: {metric}. Wir haben die Haupttreiber identifiziert und setzen jetzt einen Minderungsplan um. Meine Empfehlung ist, den Trend innerhalb von 2 Wochen zu stabilisieren und das Kundenvertrauen zu wahren. Ich bestätige Korrekturmaßnahmen und einen revidierten Zeitplan innerhalb einer Stunde.',
};

const Map<String, String> _quizTimesUpMessage = {
  'en': 'Time’s up. Executive clarity requires speed under pressure.',
  'fr': 'Temps écoulé. La clarté exécutive exige de la vitesse sous pression.',
  'es': 'Se acabó el tiempo. La claridad ejecutiva exige rapidez bajo presión.',
  'pt': 'Tempo esgotado. Clareza executiva exige velocidade sob pressão.',
  'de': 'Die Zeit ist um. Executive-Klarheit braucht Tempo unter Druck.',
};

const Map<String, String> _quizTimesUpHaptic = {
  'en': 'hesitation',
  'fr': 'hésitation',
  'es': 'duda',
  'pt': 'hesitação',
  'de': 'zögern',
};

const Map<String, String> _quizCorrectMessage = {
  'en': 'Correct. Executive-grade synonym mapping detected.',
  'fr': 'Correct. Cartographie de synonymes de niveau exécutif détectée.',
  'es': 'Correcto. Mapeo de sinónimos de nivel ejecutivo detectado.',
  'pt': 'Correto. Mapeamento de sinônimos nível executivo detectado.',
  'de': 'Richtig. Executive-taugliche Synonymzuordnung erkannt.',
};

const Map<String, String> _quizCorrectHaptic = {
  'en': 'correct',
  'fr': 'correct',
  'es': 'correcto',
  'pt': 'correto',
  'de': 'korrekt',
};

const Map<String, String> _quizNotQuiteMessage = {
  'en': 'Not quite. Aim for connectors + measurable commitments.',
  'fr': 'Pas encore. Visez des connecteurs + des engagements mesurables.',
  'es': 'No del todo. Apunta a conectores + compromisos medibles.',
  'pt': 'Ainda não. Busque conectores + compromissos mensuráveis.',
  'de': 'Noch nicht. Setze auf Konnektoren + messbare Zusagen.',
};

const Map<String, String> _quizNotQuiteHaptic = {
  'en': 'hesitation',
  'fr': 'hésitation',
  'es': 'duda',
  'pt': 'hesitação',
  'de': 'zögern',
};

const List<_CoachTipData> _coachTips = [
  _CoachTipData(
    id: 'tip-1',
    type: ToastType.tip,
    title: {
      'en': 'Executive Polish',
      'fr': 'Polish exécutif',
      'es': 'Pulido ejecutivo',
      'pt': 'Polimento executivo',
      'de': 'Executive-Politur',
    },
    body: {
      'en': 'Commit to a timeline. Replace “soon” with a measurable ETA.',
      'fr': 'Engagez-vous sur un calendrier. Remplacez « bientôt » par un ETA mesurable.',
      'es': 'Comprométete con un calendario. Sustituye “pronto” por un ETA medible.',
      'pt': 'Comprometa-se com um cronograma. Substitua “em breve” por um ETA mensurável.',
      'de': 'Verpflichte dich auf einen Zeitplan. Ersetze „bald“ durch eine messbare ETA.',
    },
  ),
  _CoachTipData(
    id: 'tip-2',
    type: ToastType.tip,
    title: {
      'en': 'Structure',
      'fr': 'Structure',
      'es': 'Estructura',
      'pt': 'Estrutura',
      'de': 'Struktur',
    },
    body: {
      'en': 'Use PREP: Point → Reason → Example → Point. Keep it crisp.',
      'fr': 'Utilisez PREP : Point → Raison → Exemple → Point. Restez concis.',
      'es': 'Usa PREP: Punto → Razón → Ejemplo → Punto. Sé conciso.',
      'pt': 'Use PREP: Ponto → Razão → Exemplo → Ponto. Seja conciso.',
      'de': 'Nutze PREP: Punkt → Grund → Beispiel → Punkt. Halte es knapp.',
    },
  ),
  _CoachTipData(
    id: 'warn-1',
    type: ToastType.warn,
    title: {
      'en': 'Hesitation Detected',
      'fr': 'Hésitation détectée',
      'es': 'Duda detectada',
      'pt': 'Hesitação detectada',
      'de': 'Zögern erkannt',
    },
    body: {
      'en': 'You paused twice. Anchor with a connector: “Therefore…”',
      'fr': 'Vous avez hésité deux fois. Ancrez avec un connecteur : « Donc… »',
      'es': 'Hiciste dos pausas. Ancla con un conector: “Por lo tanto…”',
      'pt': 'Você pausou duas vezes. Ancore com um conector: “Portanto…”',
      'de': 'Du hast zweimal pausiert. Verankere mit einem Konnektor: „Daher…“',
    },
  ),
  _CoachTipData(
    id: 'tip-3',
    type: ToastType.tip,
    title: {
      'en': 'Leadership Tone',
      'fr': 'Tonalité leadership',
      'es': 'Tono de liderazgo',
      'pt': 'Tom de liderança',
      'de': 'Leadership-Ton',
    },
    body: {
      'en': 'Own the narrative: “We identified the driver, and we’re mitigating it now.”',
      'fr': 'Assumez le récit : « Nous avons identifié le facteur et nous le traitons maintenant. »',
      'es': 'Asume el relato: “Identificamos el factor y lo estamos mitigando ahora.”',
      'pt': 'Assuma a narrativa: “Identificamos o fator e estamos mitigando agora.”',
      'de': 'Übernimm die Narrative: „Wir haben den Treiber identifiziert und mitigieren ihn jetzt.“',
    },
  ),
  _CoachTipData(
    id: 'tip-4',
    type: ToastType.tip,
    title: {
      'en': 'Data Authority',
      'fr': 'Autorité data',
      'es': 'Autoridad de datos',
      'pt': 'Autoridade de dados',
      'de': 'Datenautorität',
    },
    body: {
      'en': 'Reference the metric: “{metric}” — then propose the recovery plan.',
      'fr': 'Référez-vous à la métrique : « {metric} » — puis proposez le plan de reprise.',
      'es': 'Menciona la métrica: “{metric}” — y luego propone el plan de recuperación.',
      'pt': 'Referencie a métrica: “{metric}” — e então proponha o plano de recuperação.',
      'de': 'Nenne die Kennzahl: „{metric}“ — und schlage dann den Erholungsplan vor.',
    },
  ),
];

const List<_QuizPromptData> _quizPrompts = [
  _QuizPromptData(
    cue: {
      'en': 'Upgrade: “I’m looking into it.”',
      'fr': 'Améliorez : « J’examine cela. »',
      'es': 'Mejora: “Lo estoy revisando.”',
      'pt': 'Evolua: “Estou analisando isso.”',
      'de': 'Upgrade: „Ich schaue es mir an.“',
    },
    good: {
      'en': 'I’m investigating the root cause and will confirm corrective actions with a measurable ETA.',
      'fr':
          'J’enquête sur la cause racine et je confirmerai les actions correctives avec un ETA mesurable.',
      'es':
          'Estoy investigando la causa raíz y confirmaré las acciones correctivas con un ETA medible.',
      'pt':
          'Estou investigando a causa raiz e confirmarei as ações corretivas com um ETA mensurável.',
      'de':
          'Ich untersuche die Ursache und bestätige Korrekturmaßnahmen mit einer messbaren ETA.',
    },
    synonyms: {
      'en': ['investigating', 'root cause', 'corrective actions', 'measurable ETA'],
      'fr': ['enquête', 'cause racine', 'actions correctives', 'ETA mesurable'],
      'es': ['investigando', 'causa raíz', 'acciones correctivas', 'ETA medible'],
      'pt': ['investigando', 'causa raiz', 'ações corretivas', 'ETA mensurável'],
      'de': ['untersuchen', 'ursache', 'korrekturmaßnahmen', 'messbare ETA'],
    },
  ),
  _QuizPromptData(
    cue: {
      'en': 'Use the metric: “{metric}” with leadership tone.',
      'fr': 'Utilisez la métrique : « {metric} » avec un ton leadership.',
      'es': 'Usa la métrica: “{metric}” con tono de liderazgo.',
      'pt': 'Use a métrica: “{metric}” com tom de liderança.',
      'de': 'Nutze die Kennzahl: „{metric}“ im Leadership-Ton.',
    },
    good: {
      'en':
          'Net-net: {metric}. We’re executing a mitigation plan and will provide a revised timeline within the hour.',
      'fr':
          'Net-net : {metric}. Nous exécutons un plan d’atténuation et fournirons un calendrier révisé dans l’heure.',
      'es':
          'En resumen: {metric}. Estamos ejecutando un plan de mitigación y daremos un cronograma revisado dentro de la hora.',
      'pt':
          'Em resumo: {metric}. Estamos executando um plano de mitigação e forneceremos um cronograma revisado dentro de uma hora.',
      'de':
          'Net-net: {metric}. Wir setzen einen Minderungsplan um und liefern innerhalb einer Stunde einen revidierten Zeitplan.',
    },
    synonyms: {
      'en': ['net-net', 'mitigation plan', 'revised timeline'],
      'fr': ['net-net', 'plan d’atténuation', 'calendrier révisé'],
      'es': ['net-net', 'plan de mitigación', 'cronograma revisado'],
      'pt': ['net-net', 'plano de mitigação', 'cronograma revisado'],
      'de': ['net-net', 'minderungsplan', 'revidierter zeitplan'],
    },
  ),
  _QuizPromptData(
    cue: {
      'en': 'Replace apology with ownership.',
      'fr': 'Remplacez l’excuse par la responsabilité.',
      'es': 'Sustituye la disculpa por responsabilidad.',
      'pt': 'Substitua a desculpa por responsabilidade.',
      'de': 'Ersetze Entschuldigung durch Verantwortung.',
    },
    good: {
      'en': 'We own the outcome. We identified the driver and we’re stabilizing performance now.',
      'fr': 'Nous assumons le résultat. Nous avons identifié le facteur et stabilisons la performance.',
      'es': 'Asumimos el resultado. Identificamos el factor y estamos estabilizando el rendimiento.',
      'pt': 'Assumimos o resultado. Identificamos o fator e estamos estabilizando o desempenho.',
      'de': 'Wir übernehmen die Verantwortung. Wir haben den Treiber identifiziert und stabilisieren jetzt.',
    },
    synonyms: {
      'en': ['own the outcome', 'identified the driver', 'stabilizing'],
      'fr': ['assumer le résultat', 'facteur identifié', 'stabilisation'],
      'es': ['asumir el resultado', 'factor identificado', 'estabilizando'],
      'pt': ['assumir o resultado', 'fator identificado', 'estabilizando'],
      'de': ['verantwortung übernehmen', 'treiber identifiziert', 'stabilisieren'],
    },
  ),
];

const Map<String, String> _quizCorrectHaptic = {
  'en': 'correct',
  'fr': 'correct',
  'es': 'correcto',
  'pt': 'correto',
  'de': 'korrekt',
};

const Map<String, String> _quizTimesUpHaptic = {
  'en': 'hesitation',
  'fr': 'hésitation',
  'es': 'duda',
  'pt': 'hesitação',
  'de': 'zögern',
};

const Map<String, String> _quizNotQuiteHaptic = {
  'en': 'hesitation',
  'fr': 'hésitation',
  'es': 'duda',
  'pt': 'hesitação',
  'de': 'zögern',
};

const Map<String, String> _quizCorrectMessage = {
  'en': 'Correct. Executive-grade synonym mapping detected.',
  'fr': 'Correct. Cartographie de synonymes de niveau exécutif détectée.',
  'es': 'Correcto. Mapeo de sinónimos de nivel ejecutivo detectado.',
  'pt': 'Correto. Mapeamento de sinônimos nível executivo detectado.',
  'de': 'Richtig. Executive-taugliche Synonymzuordnung erkannt.',
};

const Map<String, String> _quizTimesUpMessage = {
  'en': 'Time’s up. Executive clarity requires speed under pressure.',
  'fr': 'Temps écoulé. La clarté exécutive exige de la vitesse sous pression.',
  'es': 'Se acabó el tiempo. La claridad ejecutiva exige rapidez bajo presión.',
  'pt': 'Tempo esgotado. Clareza executiva exige velocidade sob pressão.',
  'de': 'Die Zeit ist um. Executive-Klarheit braucht Tempo unter Druck.',
};

const Map<String, String> _quizNotQuiteMessage = {
  'en': 'Not quite. Aim for connectors + measurable commitments.',
  'fr': 'Pas encore. Visez des connecteurs + des engagements mesurables.',
  'es': 'No del todo. Apunta a conectores + compromisos medibles.',
  'pt': 'Ainda não. Busque conectores + compromissos mensuráveis.',
  'de': 'Noch nicht. Setze auf Konnektoren + messbare Zusagen.',
};

const Map<String, _ClusterPoolData> _clusterPools = {
  _clusterReportingDelay: _ClusterPoolData(
    intent: {
      'en': 'Reporting a delay',
      'fr': 'Signaler un retard',
      'es': 'Informar un retraso',
      'pt': 'Reportar um atraso',
      'de': 'Eine Verzögerung melden',
    },
    tier1: {
      'en': ['We are late.', 'It will take more time.', 'I am checking it.'],
      'fr': ['Nous sommes en retard.', 'Il faut plus de temps.', 'Je vérifie.'],
      'es': ['Vamos tarde.', 'Tomará más tiempo.', 'Lo estoy revisando.'],
      'pt': ['Estamos atrasados.', 'Vai levar mais tempo.', 'Estou verificando.'],
      'de': ['Wir sind spät dran.', 'Es dauert länger.', 'Ich prüfe es.'],
    },
    tier2: {
      'en': [
        'We’re experiencing a delay due to dependencies.',
        'I’m actively investigating the cause.',
        'I’ll share an updated ETA shortly.',
      ],
      'fr': [
        'Nous subissons un retard dû aux dépendances.',
        'J’enquête activement sur la cause.',
        'Je partagerai un nouvel ETA rapidement.',
      ],
      'es': [
        'Estamos experimentando un retraso por dependencias.',
        'Estoy investigando activamente la causa.',
        'Compartiré un nuevo ETA pronto.',
      ],
      'pt': [
        'Estamos com atraso devido a dependências.',
        'Estou investigando ativamente a causa.',
        'Compartilharei um novo ETA em breve.',
      ],
      'de': [
        'Wir haben eine Verzögerung wegen Abhängigkeiten.',
        'Ich untersuche die Ursache aktiv.',
        'Ich teile bald eine aktualisierte ETA.',
      ],
    },
    tier3: {
      'en': [
        'We’ve identified the bottleneck and are executing a mitigation plan.',
        'I’m investigating the root cause and will confirm the corrective actions.',
        'You’ll have a revised timeline and risk assessment within the hour.',
      ],
      'fr': [
        'Nous avons identifié le goulot et déployons un plan d’atténuation.',
        'J’analyse la cause racine et confirmerai les actions correctives.',
        'Vous aurez un calendrier révisé et une analyse de risque dans l’heure.',
      ],
      'es': [
        'Identificamos el cuello de botella y ejecutamos un plan de mitigación.',
        'Estoy investigando la causa raíz y confirmaré las acciones correctivas.',
        'Tendrás un cronograma revisado y evaluación de riesgo en una hora.',
      ],
      'pt': [
        'Identificamos o gargalo e estamos executando um plano de mitigação.',
        'Estou investigando a causa raiz e confirmarei as ações corretivas.',
        'Você terá um cronograma revisado e avaliação de risco dentro de uma hora.',
      ],
      'de': [
        'Wir haben den Engpass identifiziert und setzen einen Minderungsplan um.',
        'Ich untersuche die Ursache und bestätige Korrekturmaßnahmen.',
        'Innerhalb einer Stunde erhältst du einen revidierten Zeitplan und eine Risikoanalyse.',
      ],
    },
    connectors: {
      'en': ['However', 'Therefore', 'As a result', 'To de-risk this'],
      'fr': ['Cependant', 'Donc', 'Par conséquent', 'Pour réduire le risque'],
      'es': ['Sin embargo', 'Por lo tanto', 'Como resultado', 'Para reducir el riesgo'],
      'pt': ['No entanto', 'Portanto', 'Como resultado', 'Para reduzir o risco'],
      'de': ['Allerdings', 'Daher', 'Infolgedessen', 'Zur Risikominimierung'],
    },
    powerVerbs: {
      'en': ['stabilize', 'mitigate', 'validate', 'escalate', 'unblock'],
      'fr': ['stabiliser', 'atténuer', 'valider', 'escalader', 'débloquer'],
      'es': ['estabilizar', 'mitigar', 'validar', 'escalar', 'desbloquear'],
      'pt': ['estabilizar', 'mitigar', 'validar', 'escalar', 'desbloquear'],
      'de': ['stabilisieren', 'mindern', 'validieren', 'eskalieren', 'entblocken'],
    },
  ),
  _clusterSharingBadNews: _ClusterPoolData(
    intent: {
      'en': 'Sharing bad news',
      'fr': 'Partager une mauvaise nouvelle',
      'es': 'Compartir malas noticias',
      'pt': 'Compartilhar más notícias',
      'de': 'Schlechte Nachrichten teilen',
    },
    tier1: {
      'en': ['We have a problem.', 'It’s not good.', 'Sales are down.'],
      'fr': ['Nous avons un problème.', 'Ce n’est pas bon.', 'Les ventes baissent.'],
      'es': ['Tenemos un problema.', 'No va bien.', 'Las ventas bajan.'],
      'pt': ['Temos um problema.', 'Não está bom.', 'As vendas caíram.'],
      'de': ['Wir haben ein Problem.', 'Das ist nicht gut.', 'Die Verkäufe sind rückläufig.'],
    },
    tier2: {
      'en': [
        'We’ve seen a negative variance this quarter.',
        'The trend is below forecast.',
        'We need to address the drivers quickly.',
      ],
      'fr': [
        'Nous constatons une variance négative ce trimestre.',
        'La tendance est sous la prévision.',
        'Nous devons agir vite sur les facteurs.',
      ],
      'es': [
        'Vemos una variación negativa este trimestre.',
        'La tendencia está por debajo del pronóstico.',
        'Debemos abordar los factores rápidamente.',
      ],
      'pt': [
        'Vimos uma variação negativa neste trimestre.',
        'A tendência está abaixo da previsão.',
        'Precisamos agir rapidamente sobre os fatores.',
      ],
      'de': [
        'Wir sehen eine negative Abweichung in diesem Quartal.',
        'Der Trend liegt unter der Prognose.',
        'Wir müssen die Treiber schnell adressieren.',
      ],
    },
    tier3: {
      'en': [
        'We’re facing a material shortfall versus forecast, and we’re already executing a recovery plan.',
        'I’ll walk you through the drivers, our mitigation strategy, and the expected impact timeline.',
        'Our priority is to stabilize performance while preserving customer trust.',
      ],
      'fr': [
        'Nous faisons face à un écart significatif vs la prévision et exécutons déjà un plan de reprise.',
        'Je vais détailler les facteurs, notre stratégie d’atténuation et le calendrier d’impact.',
        'Notre priorité est de stabiliser la performance tout en préservant la confiance client.',
      ],
      'es': [
        'Enfrentamos una caída material vs el pronóstico y ya ejecutamos un plan de recuperación.',
        'Desglosaré los factores, nuestra estrategia de mitigación y el calendario de impacto.',
        'Nuestra prioridad es estabilizar el rendimiento preservando la confianza del cliente.',
      ],
      'pt': [
        'Estamos enfrentando uma queda material vs a previsão e já executamos um plano de recuperação.',
        'Vou detalhar os fatores, nossa estratégia de mitigação e o cronograma de impacto.',
        'Nossa prioridade é estabilizar o desempenho preservando a confiança do cliente.',
      ],
      'de': [
        'Wir stehen vor einer wesentlichen Lücke zur Prognose und setzen bereits einen Erholungsplan um.',
        'Ich erläutere die Treiber, unsere Minderungsstrategie und den erwarteten Impact-Zeitplan.',
        'Unsere Priorität ist es, die Performance zu stabilisieren und das Kundenvertrauen zu wahren.',
      ],
    },
    connectors: {
      'en': ['First', 'Second', 'Net-net', 'Here’s the upside'],
      'fr': ['Premièrement', 'Deuxièmement', 'Net-net', 'Voici le positif'],
      'es': ['Primero', 'Segundo', 'Net-net', 'Aquí está lo positivo'],
      'pt': ['Primeiro', 'Segundo', 'Net-net', 'Aqui vai o positivo'],
      'de': ['Erstens', 'Zweitens', 'Net-net', 'Hier die positive Seite'],
    },
    powerVerbs: {
      'en': ['quantify', 'triage', 'stabilize', 'accelerate', 'align'],
      'fr': ['quantifier', 'trier', 'stabiliser', 'accélérer', 'aligner'],
      'es': ['cuantificar', 'priorizar', 'estabilizar', 'acelerar', 'alinear'],
      'pt': ['quantificar', 'priorizar', 'estabilizar', 'acelerar', 'alinhar'],
      'de': ['quantifizieren', 'triagieren', 'stabilisieren', 'beschleunigen', 'ausrichten'],
    },
  ),
};

final learningContentResolverProvider = Provider<LearningContentResolver>((ref) {
  final locale = ref.watch(learningLocaleProvider);
  final profile = ref.watch(userProfileProvider);
  final scenarios = ref.watch(scenariosProvider);
  return LearningContentResolver(
    learningLocale: locale,
    profile: profile,
    scenarios: scenarios,
  );
});
