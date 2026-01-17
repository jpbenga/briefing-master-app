import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_state.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/ui/buttons.dart';
import '../../../core/ui/cards.dart';
import '../../../core/ui/pills.dart';
import '../../../core/ui/progress.dart';
import '../../../core/ui/screen_shell.dart';
import '../../../core/i18n/l10n_ext.dart';
import '../../../core/learning/learning_content_resolver.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int timeLeft = 20;
  int streak = 0;
  int points = 120;
  int promptIdx = 0;
  String answer = '';
  QuizResult? result;
  Timer? timer;
  late TextEditingController answerController;

  @override
  void initState() {
    super.initState();
    ref.read(modeProvider.notifier).state = AppMode.focus;
    answerController = TextEditingController();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        timeLeft = timeLeft <= 1 ? 0 : timeLeft - 1;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resolver = ref.watch(learningContentResolverProvider);
    final feedback = resolver.quizFeedback();

    if (timeLeft == 0 && result == null) {
      result = QuizResult(
        ok: false,
        msg: feedback.timesUpMessage,
        haptic: feedback.timesUpHaptic,
      );
      streak = 0;
      points = (points - 12).clamp(0, 999);
    }

    final challenges = resolver.quizPrompts();

    final current = challenges[promptIdx];
    final nextReview = streak >= 3
        ? context.l10n.reviewInDays(3)
        : streak == 2
            ? context.l10n.reviewInHours(24)
            : streak == 1
                ? context.l10n.reviewInHours(6)
                : context.l10n.reviewInMinutes(30);

    return ScreenShell(
      title: context.l10n.quizTitle,
      left: const BackButtonWidget(),
      right: Pill(label: context.l10n.stageLabel(3, 4), icon: Icons.timer_outlined),
      footer: Column(
        children: [
          AppPrimaryButton(
            label: context.l10n.quizContinueToRevision,
            icon: Icons.arrow_forward,
            onPressed: () => ref.read(appRouteProvider.notifier).goTo(AppRoute.revision),
          ),
          const SizedBox(height: 8),
          AppSecondaryButton(
            label: context.l10n.quizSeePaywall,
            icon: Icons.lock_outline,
            onPressed: () {
              ref.read(paywallIntentProvider.notifier).state = PaywallIntent(
                feature: context.l10n.paywallFeatureCompetencyMapPricing,
                from: AppRoute.quiz,
              );
              ref.read(appRouteProvider.notifier).goTo(AppRoute.paywall);
            },
          ),
        ],
      ),
      child: Column(
        children: [
          AppCard(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x1A6366F1), Color(0x00000000)],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.quizHighPressureLabel,
                        style: const TextStyle(fontSize: 12, color: AppTokens.textMuted),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.l10n.quizFindSynonymsTitle,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.quizFindSynonymsBody,
                        style: const TextStyle(fontSize: 12, color: AppTokens.textSecondary, height: 1.4),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0x1A6366F1),
                    borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                    border: Border.all(color: const Color(0x336366F1)),
                  ),
                  child: const Icon(Icons.timer_outlined, color: Color(0xFFC7D2FE)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            backgroundColor: AppTokens.surfaceGlass,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Pill(
                      label: context.l10n.quizStreakLabel(streak),
                      icon: Icons.bolt,
                      variant: streak > 0 ? PillVariant.success : PillVariant.muted,
                    ),
                    Pill(
                      label: context.l10n.quizPointsLabel(points),
                      icon: Icons.workspace_premium,
                      variant: PillVariant.muted,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.l10n.timeLeftLabel,
                      style: const TextStyle(fontSize: 11, color: AppTokens.textMuted),
                    ),
                    Text(
                      '${timeLeft}s',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: timeLeft <= 5 ? const Color(0xFFFDE68A) : AppTokens.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ProgressBarWidget(value: (timeLeft / 20) * 100),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0x26000000),
                    borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                    border: Border.all(color: AppTokens.borderLight),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.promptLabel,
                        style: const TextStyle(fontSize: 11, color: AppTokens.textMuted),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        current.cue,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, height: 1.3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.yourAnswerLabel,
                      style: const TextStyle(fontSize: 11, color: AppTokens.textMuted),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: answerController,
                      minLines: 3,
                      maxLines: 3,
                      onChanged: (value) => answer = value,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0x26000000),
                        hintText: context.l10n.quizAnswerHint,
                        hintStyle: const TextStyle(fontSize: 13, color: AppTokens.textMuted),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                          borderSide: BorderSide(color: AppTokens.borderLight),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                          borderSide: BorderSide(color: AppTokens.borderLight),
                        ),
                      ),
                      style: const TextStyle(fontSize: 13, color: AppTokens.textPrimary, height: 1.4),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => submit(current),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                          ),
                          child: Center(
                            child: Text(
                              context.l10n.submitLabel,
                              style: const TextStyle(fontWeight: FontWeight.w600, color: AppTokens.zinc950),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            answer = current.good;
                            answerController.text = current.good;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: AppTokens.surfaceMuted,
                            borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                            border: Border.all(color: AppTokens.borderLight),
                          ),
                          child: Center(
                            child: Text(
                              context.l10n.showBestAnswerLabel,
                              style: const TextStyle(fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (result != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: result!.ok ? const Color(0x1A10B981) : const Color(0x1AF59E0B),
                      borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                      border: Border.all(
                        color: result!.ok ? const Color(0x3310B981) : const Color(0x33F59E0B),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  result!.ok ? context.l10n.quizCorrectLabel : context.l10n.quizUpgradeNeededLabel,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  result!.msg,
                                  style: const TextStyle(fontSize: 12, color: AppTokens.textSecondary, height: 1.3),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  context.l10n.srsReturnLabel(nextReview),
                                  style: const TextStyle(fontSize: 11, color: AppTokens.textMuted),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: next,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppTokens.surfaceMuted,
                                  borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                                  border: Border.all(color: AppTokens.borderLight),
                                ),
                                child: Text(
                                  context.l10n.nextLabel,
                                  style: const TextStyle(fontSize: 12, color: AppTokens.textPrimary),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          context.l10n.hapticSimulationLabel(
                            result!.haptic == 'correct' ? context.l10n.hapticMicroBounce : context.l10n.hapticPulse,
                          ),
                          style: const TextStyle(fontSize: 11, color: AppTokens.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x14000000), Color(0x00000000)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.quizWhyThisMattersTitle,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                ),
                const SizedBox(height: 6),
                Text(
                  context.l10n.quizWhyThisMattersBody,
                  style: const TextStyle(fontSize: 12, color: AppTokens.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void submit(QuizPrompt current) {
    if (answer.trim().isEmpty) return;
    final lower = answer.toLowerCase();
    final hits = current.synonyms.where((syn) => lower.contains(syn.toLowerCase())).length;
    final ok = hits >= (current.synonyms.length * 0.6).floor().clamp(2, current.synonyms.length);
    final feedback = ref.read(learningContentResolverProvider).quizFeedback();
    setState(() {
      if (ok) {
        result = QuizResult(
          ok: true,
          msg: feedback.correctMessage,
          haptic: feedback.correctHaptic,
        );
        streak += 1;
        points += 16;
      } else {
        result = QuizResult(
          ok: false,
          msg: feedback.notQuiteMessage,
          haptic: feedback.notQuiteHaptic,
        );
        streak = 0;
        points = (points - 8).clamp(0, 999);
      }
    });
  }

  void next() {
    final promptCount = ref.read(learningContentResolverProvider).quizPrompts().length;
    setState(() {
      result = null;
      answer = '';
      answerController.clear();
      timeLeft = 20;
      promptIdx = (promptIdx + 1) % promptCount;
    });
  }
}

class QuizResult {
  const QuizResult({required this.ok, required this.msg, required this.haptic});

  final bool ok;
  final String msg;
  final String haptic;
}
