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

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);

    return ScreenShell(
      title: 'Onboarding',
      left: const BackButtonWidget(),
      right: const Pill(label: 'FTUE', icon: Icons.layers_outlined),
      footer: Column(
        children: [
          AppPrimaryButton(
            label: 'Personalize (CV / Dashboard)',
            icon: Icons.arrow_forward,
            onPressed: () => ref.read(appRouteProvider.notifier).goTo(AppRoute.upload),
          ),
          const SizedBox(height: 8),
          AppSecondaryButton(
            label: 'Skip personalization (demo)',
            onPressed: () {
              ref.read(userProfileProvider.notifier).state = profile.copyWith(hydrated: false);
              ref.read(appRouteProvider.notifier).goTo(AppRoute.priming);
            },
          ),
        ],
      ),
      child: Column(
        children: [
          AppCard(
            backgroundColor: AppTokens.surfaceGlass,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Your mission', style: TextStyle(fontSize: 12, color: AppTokens.textMuted)),
                SizedBox(height: 6),
                Text(
                  'Sound credible under pressure — without overthinking.',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                ),
                SizedBox(height: 8),
                Text(
                  'We build a neural shortcut: your brain learns executive phrasing as a reflex.',
                  style: TextStyle(fontSize: 12, color: AppTokens.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const _OnboardingGrid(),
          const SizedBox(height: 12),
          AppCard(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x1A06B6D4), Color(0x00000000)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Endowment Effect',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                ),
                SizedBox(height: 6),
                Text(
                  'Uploading your CV/dashboard makes the product feel already “yours.” Your brain values what it invests in — leading to higher activation and LTV.',
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

class _OnboardingGrid extends StatelessWidget {
  const _OnboardingGrid();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _OnboardCard(
                icon: Icons.forum_outlined,
                title: 'Real-time coach',
                body: 'Streaming feedback while you speak — tone, structure, fillers.',
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _OnboardCard(
                icon: Icons.bar_chart_outlined,
                title: 'Sophistication Score',
                body: 'No binary grading. We measure executive polish + clarity.',
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _OnboardCard(
                icon: Icons.bolt_outlined,
                title: 'Hook Model',
                body: 'Triggers → action → reward → investment → retention loop.',
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _OnboardCard(
                icon: Icons.verified_user_outlined,
                title: 'Private by design',
                body: 'Your documents are isolated via RLS (multi-tenant security).',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OnboardCard extends StatelessWidget {
  const _OnboardCard({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: AppTokens.surfaceGlass,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTokens.surfaceMuted,
              borderRadius: BorderRadius.circular(AppTokens.radiusMd),
              border: Border.all(color: AppTokens.borderLight),
            ),
            child: Icon(icon, size: 16, color: AppTokens.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: const TextStyle(fontSize: 11, color: AppTokens.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }
}
