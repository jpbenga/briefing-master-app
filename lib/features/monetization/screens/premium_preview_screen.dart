import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/ui/buttons.dart';
import '../../../core/ui/cards.dart';
import '../../../core/ui/pills.dart';
import '../../../core/ui/screen_shell.dart';

class PremiumPreviewScreen extends ConsumerWidget {
  const PremiumPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenShell(
      title: 'Premium Preview',
      left: const BackButtonWidget(),
      right: const Pill(label: 'Premium', icon: Icons.workspace_premium, variant: PillVariant.success),
      footer: Column(
        children: [
          AppPrimaryButton(
            label: 'Start another briefing',
            icon: Icons.arrow_forward,
            onPressed: () => ref.read(appRouteProvider.notifier).goTo(AppRoute.priming),
          ),
          const SizedBox(height: 8),
          AppSecondaryButton(
            label: 'Back to Paywall',
            onPressed: () => ref.read(appRouteProvider.notifier).goTo(AppRoute.paywall),
          ),
        ],
      ),
      child: Column(
        children: [
          AppCard(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x1A06B6D4), Color(0x00000000)],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('What “magic” feels like', style: TextStyle(fontSize: 12, color: AppTokens.textMuted)),
                SizedBox(height: 4),
                Text(
                  'Your AI coach becomes a real-time copilot.',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                ),
                SizedBox(height: 8),
                Text(
                  'Whisper → transcription. Python → intent + sophistication scoring. NestJS → orchestration. Supabase → secure memory.',
                  style: TextStyle(fontSize: 12, color: AppTokens.textSecondary, height: 1.4),
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
                        Text('Premium modules', style: TextStyle(fontSize: 11, color: AppTokens.textMuted)),
                        SizedBox(height: 2),
                        Text(
                          'Briefing Library',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Pill(label: 'Feature-first', icon: Icons.layers_outlined),
                  ],
                ),
                const SizedBox(height: 10),
                const _LibraryItem(
                  title: 'Crisis Sprint',
                  tag: 'One-shot pack',
                  desc: 'High-pressure calls, executive rewrites, rapid SRS.',
                ),
                const SizedBox(height: 8),
                const _LibraryItem(
                  title: 'Interview Sprint',
                  tag: 'One-shot pack',
                  desc: 'STAR answers, persuasion, leadership presence.',
                ),
                const SizedBox(height: 8),
                const _LibraryItem(
                  title: 'Standup Mastery',
                  tag: 'Premium',
                  desc: 'Crisp updates, blockers, timelines, accountability.',
                ),
                const SizedBox(height: 8),
                const _LibraryItem(
                  title: 'Negotiation Room',
                  tag: 'Premium',
                  desc: 'Anchoring, framing, concessions, closing language.',
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
                  'Retention plateau strategy',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                ),
                SizedBox(height: 6),
                Text(
                  'After 2–3 weeks, motivation dips. We re-trigger with new roles, scenario packs, streak boosters, and competency milestones.',
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

class _LibraryItem extends StatelessWidget {
  const _LibraryItem({required this.title, required this.tag, required this.desc});

  final String title;
  final String tag;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTokens.surfaceMuted,
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        border: Border.all(color: AppTokens.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTokens.surfaceMuted,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppTokens.borderLight),
                ),
                child: Text(tag, style: const TextStyle(fontSize: 11, color: AppTokens.textSecondary)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(desc, style: const TextStyle(fontSize: 11, color: AppTokens.textSecondary, height: 1.4)),
        ],
      ),
    );
  }
}
