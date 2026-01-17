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
import '../../../core/ui/toasts.dart';
import '../../../core/i18n/l10n_ext.dart';
import '../../../core/learning/learning_content_resolver.dart';
import '../../monetization/logic/entitlements.dart';
import '../widgets/audio_visualizer.dart';
import '../widgets/toast_stream.dart';

class SpeakingScreen extends ConsumerStatefulWidget {
  const SpeakingScreen({super.key});

  @override
  ConsumerState<SpeakingScreen> createState() => _SpeakingScreenState();
}

class _SpeakingScreenState extends ConsumerState<SpeakingScreen> {
  bool isSpeaking = false;
  String transcript = '';
  List<ToastMessage> toasts = [];
  TierUpgrade? upgrade;
  Timer? transcriptTimer;
  Timer? speakingStopTimer;

  @override
  void initState() {
    super.initState();
    ref.listen<AsyncValue<ToastMessage?>>(toastStreamProvider, (previous, next) {
      final message = next.asData?.value;
      if (message != null) {
        setState(() => toasts = [message, ...toasts].take(8).toList());
      }
    });
  }

  @override
  void dispose() {
    transcriptTimer?.cancel();
    speakingStopTimer?.cancel();
    super.dispose();
  }

  void startSpeaking() {
    setState(() {
      transcript = '';
      upgrade = null;
      isSpeaking = true;
    });
    ref.read(speakingActiveProvider.notifier).state = true;

    final resolver = ref.read(learningContentResolverProvider);
    final currentCluster = resolver.detectIntentCluster(transcript);
    final candidates = resolver.speakingSeedCandidates(currentCluster);
    final seed = resolver.pickRandomSeed(candidates);
    var idx = 0;
    transcriptTimer?.cancel();
    transcriptTimer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
      idx += 1;
      setState(() {
        transcript = seed.substring(0, (transcript.length + 6).clamp(0, seed.length));
      });
      if (idx > 70) timer.cancel();
    });

    speakingStopTimer?.cancel();
    speakingStopTimer = Timer(const Duration(milliseconds: 7200), stopSpeaking);
  }

  void stopSpeaking() {
    setState(() => isSpeaking = false);
    ref.read(speakingActiveProvider.notifier).state = false;
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    final hasPremium = ref.watch(hasPremiumProvider);
    final resolver = ref.watch(learningContentResolverProvider);

    final currentCluster = resolver.detectIntentCluster(transcript);
    final scoreValue = resolver.computeSophisticationScore(transcript);

    final professionalism = scoreValue >= 78
        ? (label: context.l10n.professionalismExecutive, icon: Icons.workspace_premium, variant: PillVariant.success)
        : scoreValue >= 56
            ? (label: context.l10n.professionalismProfessional, icon: Icons.verified_user_outlined, variant: PillVariant.muted)
            : (label: context.l10n.professionalismSafe, icon: Icons.warning_amber_rounded, variant: PillVariant.warn);

    final pool = resolver.clusterContent(currentCluster);
    final prompt = resolver.speakingPrompt();

    return Stack(
      children: [
        ToastOverlay(items: toasts, onClear: (id) => setState(() => toasts = toasts.where((t) => t.id != id).toList())),
        ScreenShell(
          title: context.l10n.speakingTitle,
          left: const BackButtonWidget(),
          right: Pill(
            label: hasPremium ? context.l10n.premiumCoachLabel : context.l10n.coachLockedLabel,
            icon: hasPremium ? Icons.mic : Icons.lock_outline,
            variant: hasPremium ? PillVariant.success : PillVariant.warn,
          ),
          footer: Column(
            children: [
              AppPrimaryButton(
                label: context.l10n.speakingContinueToQuiz,
                icon: Icons.arrow_forward,
                onPressed: () {
                  ref.read(modeProvider.notifier).state = AppMode.focus;
                  ref.read(appRouteProvider.notifier).goTo(AppRoute.quiz);
                },
              ),
              const SizedBox(height: 8),
              AppSecondaryButton(
                label: context.l10n.speakingJumpToBattleCard,
                icon: Icons.arrow_forward,
                onPressed: () => ref.read(appRouteProvider.notifier).goTo(AppRoute.revision),
              ),
            ],
          ),
          child: Column(
            children: [
              AppCard(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x1AF43F5E), Color(0x00000000)],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.liveBriefingPromptLabel,
                            style: const TextStyle(fontSize: 12, color: AppTokens.textMuted),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            prompt.primary,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            prompt.secondary,
                            style: const TextStyle(fontSize: 12, color: AppTokens.textSecondary, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0x1AF43F5E),
                        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                        border: Border.all(color: const Color(0x33F43F5E)),
                      ),
                      child: const Icon(Icons.bolt, color: Color(0xFFFCA5A5)),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.voiceWaveformLabel,
                              style: const TextStyle(fontSize: 11, color: AppTokens.textMuted),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              context.l10n.audioVisualizerLabel,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Pill(
                          label: '${professionalism.label} • $scoreValue/100',
                          icon: professionalism.icon,
                          variant: professionalism.variant,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AudioVisualizer(active: isSpeaking),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: isSpeaking ? null : startSpeaking,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSpeaking ? AppTokens.surfaceMuted : Colors.white,
                                borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                                border: Border.all(color: AppTokens.borderLight),
                              ),
                              child: Center(
                                child: Text(
                                  isSpeaking ? context.l10n.listeningLabel : context.l10n.startSpeakingLabel,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isSpeaking ? AppTokens.textMuted : AppTokens.zinc950,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (!hasPremium) {
                                ref.read(paywallIntentProvider.notifier).state = PaywallIntent(
                                  feature: context.l10n.paywallFeatureTier3LiveCoach,
                                  from: AppRoute.speaking,
                                );
                                ref.read(appRouteProvider.notifier).goTo(AppRoute.paywall);
                                return;
                              }
                              stopSpeaking();
                              final up = resolver.generateTierUpgrade(currentCluster);
                              final upgradeTitle = resolver.upgradeToastTitle();
                              final upgradeBody = resolver.upgradeToastBody();
                              setState(() {
                                upgrade = up;
                                toasts = [
                                  ToastMessage(
                                    id: '${DateTime.now().millisecondsSinceEpoch}-upgrade',
                                    type: ToastType.tip,
                                    title: upgradeTitle,
                                    body: upgradeBody,
                                  ),
                                  ...toasts,
                                ];
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
                                  hasPremium
                                      ? context.l10n.generateUpgradeLabel
                                      : context.l10n.unlockTier3PremiumLabel,
                                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AppCard(
                backgroundColor: const Color(0x1A000000),
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
                              context.l10n.streamingTranscriptLabel,
                              style: const TextStyle(fontSize: 11, color: AppTokens.textMuted),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              context.l10n.whatYoureSayingLabel,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Pill(
                          label: context.l10n.intentPillLabel(resolver.clusterLabel(currentCluster)),
                          icon: Icons.layers_outlined,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      constraints: const BoxConstraints(minHeight: 64),
                      child: Text(
                        transcript.isEmpty
                            ? context.l10n.speakingEmptyTranscriptHint
                            : '$transcript${isSpeaking ? '|' : ''}',
                        style: TextStyle(
                          fontSize: 12,
                          color: transcript.isEmpty ? AppTokens.textMuted : AppTokens.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.l10n.sophisticationScoreLabel,
                          style: const TextStyle(fontSize: 11, color: AppTokens.textMuted),
                        ),
                        Text(
                          '$scoreValue/100',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ProgressBarWidget(value: scoreValue.toDouble()),
                    const SizedBox(height: 6),
                    Text(
                      context.l10n.speakingScoreExplanation,
                      style: const TextStyle(fontSize: 11, color: AppTokens.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AppCard(
                backgroundColor: AppTokens.surfaceGlass,
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
                              context.l10n.tierUpgradesLabel,
                              style: const TextStyle(fontSize: 11, color: AppTokens.textMuted),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              context.l10n.executiveRewritePathLabel,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Pill(
                          label: context.l10n.ahaMomentLabel,
                          icon: Icons.workspace_premium,
                          variant: PillVariant.success,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (upgrade == null)
                      Text(
                        hasPremium
                            ? context.l10n.generateTier3Helper
                            : context.l10n.tier3LockedHelper,
                        style: const TextStyle(fontSize: 12, color: AppTokens.textSecondary, height: 1.4),
                      )
                    else ...[
                      _UpgradeBlock(label: context.l10n.tier2ProfessionalLabel, text: upgrade!.tier2),
                      const SizedBox(height: 8),
                      if (hasPremium)
                        _UpgradeBlock(
                          label: context.l10n.tier3ExecutiveLabel,
                          text: upgrade!.tier3,
                          strong: true,
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0x1AF59E0B),
                            borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                            border: Border.all(color: const Color(0x33F59E0B)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.l10n.tier3ExecutiveLockedLabel,
                                      style: const TextStyle(fontSize: 11, color: Color(0xFFFDE68A)),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '“${upgrade!.tier3}”',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFFFDE68A),
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  ref.read(paywallIntentProvider.notifier).state = PaywallIntent(
                                    feature: context.l10n.paywallFeatureTier3Rewrite,
                                    from: AppRoute.speaking,
                                  );
                                  ref.read(appRouteProvider.notifier).goTo(AppRoute.paywall);
                                },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                                    ),
                                  child: Text(
                                    context.l10n.unlockLabel,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTokens.zinc950),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        upgrade!.rationale,
                        style: const TextStyle(fontSize: 11, color: AppTokens.textMuted),
                      ),
                    ],
                    const SizedBox(height: 12),
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
                            context.l10n.suggestedConnectorsLabel,
                            style: const TextStyle(fontSize: 11, color: AppTokens.textMuted),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: pool.connectors
                                .map(
                                  (connector) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppTokens.surfaceMuted,
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(color: AppTokens.borderLight),
                                    ),
                                    child: Text(
                                      connector,
                                      style: const TextStyle(fontSize: 11, color: AppTokens.textSecondary),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UpgradeBlock extends StatelessWidget {
  const _UpgradeBlock({required this.label, required this.text, this.strong = false});

  final String label;
  final String text;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final color = strong ? const Color(0x1A10B981) : AppTokens.surfaceGlass;
    final border = strong ? const Color(0x3310B981) : AppTokens.borderLight;
    final textColor = strong ? const Color(0xFFD1FAE5) : AppTokens.textSecondary;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppTokens.textMuted)),
          const SizedBox(height: 4),
          Text(
            '“$text”',
            style: TextStyle(fontSize: 12, color: textColor, height: 1.3),
          ),
        ],
      ),
    );
  }
}
