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
import '../widgets/flip_card.dart';

class PrimingScreen extends ConsumerStatefulWidget {
  const PrimingScreen({super.key});

  @override
  ConsumerState<PrimingScreen> createState() => _PrimingScreenState();
}

class _PrimingScreenState extends ConsumerState<PrimingScreen> {
  String cluster = LearningClusters.sharingBadNews;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    final resolver = ref.watch(learningContentResolverProvider);
    final pool = resolver.clusterContent(cluster);
    final scenario = resolver.scenarioForCluster(cluster);

    return ScreenShell(
      title: context.l10n.primingTitle,
      left: const BackButtonWidget(),
      right: Pill(label: context.l10n.stageLabel(1, 4), icon: Icons.auto_awesome, variant: PillVariant.muted),
      footer: Column(
        children: [
          AppPrimaryButton(
            label: context.l10n.primingEnterFocusMode,
            icon: Icons.mic,
            onPressed: () {
              ref.read(modeProvider.notifier).state = AppMode.adrenaline;
              ref.read(appRouteProvider.notifier).goTo(AppRoute.speaking);
            },
          ),
          const SizedBox(height: 8),
          AppSecondaryButton(
            label: context.l10n.primingSkipToQuiz,
            icon: Icons.arrow_forward,
            onPressed: () {
              ref.read(modeProvider.notifier).state = AppMode.focus;
              ref.read(appRouteProvider.notifier).goTo(AppRoute.quiz);
            },
          ),
        ],
      ),
      child: Column(
        children: [
          AppCard(
            backgroundColor: AppTokens.surfaceGlass,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.l10n.scenarioLabel, style: const TextStyle(fontSize: 12, color: AppTokens.textMuted)),
                      const SizedBox(height: 4),
                      Text(
                        resolver.scenarioTitle(scenario),
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        resolver.scenarioDescription(scenario),
                        style: const TextStyle(fontSize: 12, color: AppTokens.textSecondary, height: 1.4),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTokens.surfaceMuted,
                    borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                    border: Border.all(color: AppTokens.borderLight),
                  ),
                  child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFFDE68A)),
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.intentClusterLabel,
                          style: const TextStyle(fontSize: 12, color: AppTokens.textMuted),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          resolver.clusterLabel(cluster),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    DropdownButton<String>(
                      value: cluster,
                      items: resolver.availableClusters()
                          .map((key) => DropdownMenuItem(value: key, child: Text(resolver.clusterLabel(key))))
                          .toList(),
                      dropdownColor: AppTokens.zinc900,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => cluster = value);
                        }
                      },
                      style: const TextStyle(fontSize: 12, color: AppTokens.textPrimary),
                      underline: const SizedBox.shrink(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _PrimeCard(title: context.l10n.powerVerbsLabel, items: pool.powerVerbs),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _PrimeCard(title: context.l10n.connectorsLabel, items: pool.connectors),
                    ),
                  ],
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
                          context.l10n.triTierVocabularyTitle,
                          style: const TextStyle(fontSize: 12, color: AppTokens.textMuted),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          context.l10n.triTierVocabularySubtitle,
                          style: const TextStyle(fontSize: 12, color: AppTokens.textSecondary),
                        ),
                      ],
                    ),
                    Pill(label: context.l10n.tiersLabel, icon: Icons.layers_outlined),
                  ],
                ),
                const SizedBox(height: 12),
                FlipCardWidget(
                  tier: context.l10n.tierLabel(1),
                  subtitle: context.l10n.tier1Subtitle,
                  front: pool.tier1.first,
                  back: pool.tier2.first,
                ),
                const SizedBox(height: 8),
                FlipCardWidget(
                  tier: context.l10n.tierLabel(2),
                  subtitle: context.l10n.tier2Subtitle,
                  front: pool.tier2[1],
                  back: pool.tier3[1],
                ),
                const SizedBox(height: 8),
                FlipCardWidget(
                  tier: context.l10n.tierLabel(3),
                  subtitle: context.l10n.tier3Subtitle,
                  front: pool.tier3.first,
                  back: resolver.tier3BackInstruction(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x1A06B6D4), Color(0x00000000)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.primingPsychologyTitle,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                ),
                const SizedBox(height: 6),
                Text(
                  context.l10n.primingPsychologyBody,
                  style: const TextStyle(fontSize: 12, color: AppTokens.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Pill(
                label: profile.hydrated
                    ? context.l10n.hydratedLabel(profile.role)
                    : context.l10n.notHydratedLabel,
                icon: Icons.verified_user_outlined,
                variant: profile.hydrated ? PillVariant.success : PillVariant.warn,
              ),
              const SizedBox(width: 8),
              Pill(
                label: profile.dashboardMetric,
                icon: Icons.bar_chart_outlined,
                variant: PillVariant.muted,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrimeCard extends StatelessWidget {
  const _PrimeCard({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: AppTokens.surfaceGlass,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 11, color: AppTokens.textMuted)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: items
                .map((item) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTokens.surfaceMuted,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppTokens.borderLight),
                      ),
                      child: Text(item, style: const TextStyle(fontSize: 11, color: AppTokens.textSecondary)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
