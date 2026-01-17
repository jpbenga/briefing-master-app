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

class RevisionScreen extends ConsumerWidget {
  const RevisionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final template =
        'Net-net: ${profile.dashboardMetric}. We’ve identified the primary drivers, and we’re executing a mitigation plan now. My recommendation is to stabilize the trend within 2 weeks, while preserving customer trust. I’ll confirm corrective actions and a revised timeline within the hour.';

    return ScreenShell(
      title: 'Battle Card',
      left: const BackButtonWidget(),
      right: const Pill(label: 'Stage 4/4', icon: Icons.workspace_premium, variant: PillVariant.success),
      footer: Column(
        children: [
          AppPrimaryButton(
            label: 'Unlock Competency Map',
            icon: Icons.lock_outline,
            onPressed: () {
              ref.read(paywallIntentProvider.notifier).state = const PaywallIntent(
                feature: 'Competency Map + Pricing',
                from: AppRoute.revision,
              );
              ref.read(appRouteProvider.notifier).goTo(AppRoute.paywall);
            },
          ),
          const SizedBox(height: 8),
          AppSecondaryButton(
            label: 'Preview Premium Experience',
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
              children: const [
                Text('Mission-ready anchor', style: TextStyle(fontSize: 12, color: AppTokens.textMuted)),
                SizedBox(height: 4),
                Text(
                  'Your executive briefing — in one card.',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                ),
                SizedBox(height: 8),
                Text(
                  'This is your “meeting cheat sheet.” It compresses clarity + tone + commitment.',
                  style: TextStyle(fontSize: 12, color: AppTokens.textSecondary, height: 1.4),
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
                        const Text('Context', style: TextStyle(fontSize: 11, color: AppTokens.textMuted)),
                        const SizedBox(height: 2),
                        Text(
                          '${profile.role} @ ${profile.company}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Pill(
                      label: profile.hydrated ? 'Hydrated' : 'Demo',
                      icon: Icons.verified_user_outlined,
                      variant: profile.hydrated ? PillVariant.success : PillVariant.warn,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Expanded(child: _MiniMetric(label: 'Clarity', value: '82')),
                    SizedBox(width: 8),
                    Expanded(child: _MiniMetric(label: 'Tone', value: '76')),
                    SizedBox(width: 8),
                    Expanded(child: _MiniMetric(label: 'Commitment', value: '88')),
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
                      const Text(
                        'Prefilled executive template (RAG-aware)',
                        style: TextStyle(fontSize: 11, color: AppTokens.textMuted),
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
                        child: const Center(
                          child: Text(
                            'Export cheat sheet',
                            style: TextStyle(fontWeight: FontWeight.w600, color: AppTokens.zinc950),
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
                        child: const Center(
                          child: Text(
                            'Practice again',
                            style: TextStyle(fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Haptic simulation: ✔ subtle confirmation pulse on export.',
                  style: TextStyle(fontSize: 11, color: AppTokens.textMuted),
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Retention loop',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                ),
                SizedBox(height: 6),
                Text(
                  'Reward (executive rewrite) → investment (save/export) → habit (streak) → LTV.',
                  style: TextStyle(fontSize: 12, color: AppTokens.textSecondary, height: 1.4),
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
