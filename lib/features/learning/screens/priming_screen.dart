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
import '../widgets/flip_card.dart';
import 'learning_data.dart';

class PrimingScreen extends ConsumerStatefulWidget {
  const PrimingScreen({super.key});

  @override
  ConsumerState<PrimingScreen> createState() => _PrimingScreenState();
}

class _PrimingScreenState extends ConsumerState<PrimingScreen> {
  String cluster = 'Sharing bad news';

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    final pool = semanticPools[cluster]!;

    return ScreenShell(
      title: 'Cognitive Priming',
      left: const BackButtonWidget(),
      right: const Pill(label: 'Stage 1/4', icon: Icons.auto_awesome, variant: PillVariant.muted),
      footer: Column(
        children: [
          AppPrimaryButton(
            label: 'Enter Focus Mode (Speaking)',
            icon: Icons.mic,
            onPressed: () {
              ref.read(modeProvider.notifier).state = AppMode.adrenaline;
              ref.read(appRouteProvider.notifier).goTo(AppRoute.speaking);
            },
          ),
          const SizedBox(height: 8),
          AppSecondaryButton(
            label: 'Skip to Quiz (demo)',
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
                      const Text('Scenario', style: TextStyle(fontSize: 12, color: AppTokens.textMuted)),
                      const SizedBox(height: 4),
                      Text(
                        baseScenario['title']!,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        baseScenario['description']!,
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
                        const Text('Intent cluster', style: TextStyle(fontSize: 12, color: AppTokens.textMuted)),
                        const SizedBox(height: 4),
                        Text(
                          cluster,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    DropdownButton<String>(
                      value: cluster,
                      items: semanticPools.keys
                          .map((key) => DropdownMenuItem(value: key, child: Text(key)))
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
                      child: _PrimeCard(title: 'Power Verbs', items: List<String>.from(pool['powerVerbs'] as List)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _PrimeCard(title: 'Connectors', items: List<String>.from(pool['connectors'] as List)),
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
                  children: const [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tri-tier vocabulary', style: TextStyle(fontSize: 12, color: AppTokens.textMuted)),
                        SizedBox(height: 2),
                        Text(
                          'Flip cards to prime executive phrasing.',
                          style: TextStyle(fontSize: 12, color: AppTokens.textSecondary),
                        ),
                      ],
                    ),
                    Pill(label: 'Tiers', icon: Icons.layers_outlined),
                  ],
                ),
                const SizedBox(height: 12),
                FlipCardWidget(
                  tier: 'Tier 1',
                  subtitle: 'Safe / Functional',
                  front: List<String>.from(pool['tier1'] as List).first,
                  back: List<String>.from(pool['tier2'] as List).first,
                ),
                const SizedBox(height: 8),
                FlipCardWidget(
                  tier: 'Tier 2',
                  subtitle: 'Professional / Fluent',
                  front: List<String>.from(pool['tier2'] as List)[1],
                  back: List<String>.from(pool['tier3'] as List)[1],
                ),
                const SizedBox(height: 8),
                FlipCardWidget(
                  tier: 'Tier 3',
                  subtitle: 'Executive / Persuasive',
                  front: List<String>.from(pool['tier3'] as List).first,
                  back: 'Now commit: timeline + impact + mitigation.',
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Priming psychology',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                ),
                SizedBox(height: 6),
                Text(
                  'We reduce cognitive load by preloading patterns (verbs + connectors). This turns “thinking” into “reflex.” Better reflex → less anxiety → higher performance flow.',
                  style: TextStyle(fontSize: 12, color: AppTokens.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Pill(
                label: profile.hydrated ? 'Hydrated: ${profile.role}' : 'Not hydrated',
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
