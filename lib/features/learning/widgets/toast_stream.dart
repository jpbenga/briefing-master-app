import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_state.dart';
import '../../../core/ui/toasts.dart';
import '../../monetization/logic/entitlements.dart';

final speakingActiveProvider = StateProvider<bool>((ref) => false);

final toastStreamProvider = StreamProvider<ToastMessage?>((ref) async* {
  final isActive = ref.watch(speakingActiveProvider);
  final hasPremium = ref.watch(hasPremiumProvider);
  final profile = ref.watch(userProfileProvider);
  if (!hasPremium || !isActive) {
    yield null;
    return;
  }

  final tips = [
    ToastMessage(
      id: 'tip-1',
      type: ToastType.tip,
      title: 'Executive Polish',
      body: 'Commit to a timeline. Replace “soon” with a measurable ETA.',
    ),
    ToastMessage(
      id: 'tip-2',
      type: ToastType.tip,
      title: 'Structure',
      body: 'Use PREP: Point → Reason → Example → Point. Keep it crisp.',
    ),
    ToastMessage(
      id: 'warn-1',
      type: ToastType.warn,
      title: 'Hesitation Detected',
      body: 'You paused twice. Anchor with a connector: “Therefore…”',
    ),
    ToastMessage(
      id: 'tip-3',
      type: ToastType.tip,
      title: 'Leadership Tone',
      body: 'Own the narrative: “We identified the driver, and we’re mitigating it now.”',
    ),
    ToastMessage(
      id: 'tip-4',
      type: ToastType.tip,
      title: 'Data Authority',
      body: 'Reference the metric: “${profile.dashboardMetric}” — then propose the recovery plan.',
    ),
  ];

  final random = Random();
  while (ref.read(speakingActiveProvider)) {
    await Future<void>.delayed(const Duration(milliseconds: 1900));
    if (!ref.read(speakingActiveProvider)) {
      break;
    }
    final tip = tips[random.nextInt(tips.length)];
    yield ToastMessage(
      id: '${DateTime.now().millisecondsSinceEpoch}-${random.nextInt(1000)}',
      type: tip.type,
      title: tip.title,
      body: tip.body,
    );
  }
});
