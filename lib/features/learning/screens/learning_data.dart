import 'dart:math';

const baseScenario = {
  'title': 'Crisis Meeting: Revenue Drop',
  'description':
      'You must brief leadership on the situation, propose a root-cause path, and commit to a recovery plan — under pressure.',
};

const semanticPools = {
  'Reporting a delay': {
    'tier1': ['We are late.', 'It will take more time.', 'I am checking it.'],
    'tier2': [
      'We’re experiencing a delay due to dependencies.',
      'I’m actively investigating the cause.',
      'I’ll share an updated ETA shortly.',
    ],
    'tier3': [
      'We’ve identified the bottleneck and are executing a mitigation plan.',
      'I’m investigating the root cause and will confirm the corrective actions.',
      'You’ll have a revised timeline and risk assessment within the hour.',
    ],
    'connectors': ['However', 'Therefore', 'As a result', 'To de-risk this'],
    'powerVerbs': ['stabilize', 'mitigate', 'validate', 'escalate', 'unblock'],
  },
  'Sharing bad news': {
    'tier1': ['We have a problem.', 'It’s not good.', 'Sales are down.'],
    'tier2': [
      'We’ve seen a negative variance this quarter.',
      'The trend is below forecast.',
      'We need to address the drivers quickly.',
    ],
    'tier3': [
      'We’re facing a material shortfall versus forecast, and we’re already executing a recovery plan.',
      'I’ll walk you through the drivers, our mitigation strategy, and the expected impact timeline.',
      'Our priority is to stabilize performance while preserving customer trust.',
    ],
    'connectors': ['First', 'Second', 'Net-net', 'Here’s the upside'],
    'powerVerbs': ['quantify', 'triage', 'stabilize', 'accelerate', 'align'],
  },
};

double clamp(double value, double min, double max) {
  return value.clamp(min, max);
}

String pickRandom(List<String> items) {
  final random = Random();
  return items[random.nextInt(items.length)];
}

int computeSophisticationScore(String text) {
  final lower = text.toLowerCase();
  var score = 42;

  const filler = ['uh', 'um', 'like', 'you know', 'basically', 'sort of', 'kinda'];
  final fillerHits = filler.where(lower.contains).length;
  score -= fillerHits * 6;

  const rewards = [
    'root cause',
    'mitigation',
    'risk',
    'stabilize',
    'timeline',
    'impact',
    'therefore',
    'as a result',
    'net-net',
    'corrective',
  ];
  final rewardHits = rewards.where(lower.contains).length;
  score += rewardHits * 7;

  const structure = ['first', 'second', 'third', 'to summarize', 'in short', 'my recommendation'];
  final structureHits = structure.where(lower.contains).length;
  score += structureHits * 5;

  if (text.trim().length < 40) score -= 7;
  if (text.trim().length > 240) score -= 4;

  return clamp(score.toDouble(), 0, 100).round();
}

String detectIntentCluster(String text) {
  final lower = text.toLowerCase();
  if (lower.contains('delay') || lower.contains('eta') || lower.contains('blocked')) {
    return 'Reporting a delay';
  }
  if (lower.contains('revenue') || lower.contains('down') || lower.contains('variance') || lower.contains('forecast')) {
    return 'Sharing bad news';
  }
  return 'Sharing bad news';
}

class TierUpgrade {
  const TierUpgrade({required this.tier2, required this.tier3, required this.rationale});

  final String tier2;
  final String tier3;
  final String rationale;
}

TierUpgrade generateTierUpgrade(String cluster) {
  final pool = semanticPools[cluster] ?? semanticPools['Sharing bad news']!;
  final tier2 = pickRandom(List<String>.from(pool['tier2'] as List));
  final tier3 = pickRandom(List<String>.from(pool['tier3'] as List));
  final connectors = List<String>.from(pool['connectors'] as List);
  final powerVerbs = List<String>.from(pool['powerVerbs'] as List);
  return TierUpgrade(
    tier2: tier2,
    tier3: tier3,
    rationale:
        'Upgrade via executive structure + measurable commitments. Add connectors like “${pickRandom(connectors)}” and a power verb like “${pickRandom(powerVerbs)}”.',
  );
}
