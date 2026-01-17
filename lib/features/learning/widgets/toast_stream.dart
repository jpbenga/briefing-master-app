import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/learning/learning_content_resolver.dart';
import '../../../core/ui/toasts.dart';
import '../../monetization/logic/entitlements.dart';

final speakingActiveProvider = StateProvider<bool>((ref) => false);

final toastStreamProvider = StreamProvider<ToastMessage?>((ref) async* {
  final isActive = ref.watch(speakingActiveProvider);
  final hasPremium = ref.watch(hasPremiumProvider);
  final resolver = ref.watch(learningContentResolverProvider);
  if (!hasPremium || !isActive) {
    yield null;
    return;
  }

  final tips = resolver.coachTips();

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
