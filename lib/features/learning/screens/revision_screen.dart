import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_state.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/ui/buttons.dart';
import '../../../core/ui/cards.dart';
import '../../../core/ui/pills.dart';
import '../../../core/ui/screen_shell.dart';
import '../../../core/i18n/l10n_ext.dart';
import '../../../core/learning/learning_content_resolver.dart';

class RevisionScreen extends ConsumerWidget {
  const RevisionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final resolver = ref.watch(learningContentResolverProvider);
    final template = resolver.battleCardTemplate();

    return ScreenShell(
      title: context.l10n.revisionTitle,
      left: const BackButtonWidget(),
      right: Pill(label: context.l10n.stageLabel(4, 4), icon: Icons.workspace_premium, variant: PillVariant.success),
      footer: Column(
        children: [
          AppPrimaryButton(
            label: context.l10n.revisionUnlockCompetencyMap,
            icon: Icons.lock_outline,
            onPressed: () {
              ref.read(paywallIntentProvider.notifier).state = PaywallIntent(
                feature: context.l10n.paywallFeatureCompetencyMapPricing,
                from: AppRoute.revision,
              );
              ref.read(appRouteProvider.notifier).goTo(AppRoute.paywall);
            },
          ),
          const SizedBox(height: 8),
          AppSecondaryButton(
            label: context.l10n.revisionPreviewPremium,
            icon: Icons.arrow_forward,
            onPressed: () => ref.read(appRouteProvider.notifier).goTo(AppRoute.premium),
          ),
        ],
      ),
      child: Column(
        children: [
          AppCard(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x1A10B981), Color(0x00000000)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.revisionMissionReadyLabel,
                  style: const TextStyle(fontSize: 12, color: AppTokens.textMuted),
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.revisionBriefingTitle,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.revisionBriefingBody,
                  style: const TextStyle(fontSize: 12, color: AppTokens.textSecondary, height: 1.4),
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
                          context.l10n.revisionContextLabel,
                          style: const TextStyle(fontSize: 11, color: AppTokens.textMuted),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${profile.role} @ ${profile.company}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Pill(
                      label: profile.hydrated ? context.l10n.hydratedBadgeLabel : context.l10n.demoBadgeLabel,
                      icon: Icons.verified_user_outlined,
                      variant: profile.hydrated ? PillVariant.success : PillVariant.warn,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _MiniMetric(label: context.l10n.metricClarityLabel, value: '82')),
                    const SizedBox(width: 8),
                    Expanded(child: _MiniMetric(label: context.l10n.metricToneLabel, value: '76')),
                    const SizedBox(width: 8),
                    Expanded(child: _MiniMetric(label: context.l10n.metricCommitmentLabel, value: '88')),
                  ],
                ),
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
                        context.l10n.revisionPrefilledTemplateLabel,
                        style: const TextStyle(fontSize: 11, color: AppTokens.textMuted),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '“$template”',
                        style: const TextStyle(fontSize: 12, color: AppTokens.textSecondary, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                        ),
                        child: Center(
                          child: Text(
                            context.l10n.revisionExportCheatSheet,
                            style: const TextStyle(fontWeight: FontWeight.w600, color: AppTokens.zinc950),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppTokens.surfaceMuted,
                          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                          border: Border.all(color: AppTokens.borderLight),
                        ),
                        child: Center(
                          child: Text(
                            context.l10n.revisionPracticeAgain,
                            style: const TextStyle(fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.revisionHapticSimulation,
                  style: const TextStyle(fontSize: 11, color: AppTokens.textMuted),
                ),
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
                  context.l10n.revisionRetentionLoopTitle,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                ),
                const SizedBox(height: 6),
                Text(
                  context.l10n.revisionRetentionLoopBody,
                  style: const TextStyle(fontSize: 12, color: AppTokens.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTokens.surfaceGlass,
        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        border: Border.all(color: AppTokens.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: AppTokens.textMuted)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
