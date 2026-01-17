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

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);

    return ScreenShell(
      title: context.l10n.onboardingTitle,
      left: const BackButtonWidget(),
      right: Pill(label: context.l10n.ftueLabel, icon: Icons.layers_outlined),
      footer: Column(
        children: [
          AppPrimaryButton(
            label: context.l10n.onboardingPersonalizeCta,
            icon: Icons.arrow_forward,
            onPressed: () => ref.read(appRouteProvider.notifier).goTo(AppRoute.upload),
          ),
          const SizedBox(height: 8),
          AppSecondaryButton(
            label: context.l10n.onboardingSkipPersonalization,
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
              children: [
                Text(
                  context.l10n.onboardingMissionLabel,
                  style: const TextStyle(fontSize: 12, color: AppTokens.textMuted),
                ),
                const SizedBox(height: 6),
                Text(
                  context.l10n.onboardingMissionTitle,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.onboardingMissionBody,
                  style: const TextStyle(fontSize: 12, color: AppTokens.textSecondary, height: 1.4),
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
              children: [
                Text(
                  context.l10n.onboardingEndowmentTitle,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                ),
                const SizedBox(height: 6),
                Text(
                  context.l10n.onboardingEndowmentBody,
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

class _OnboardingGrid extends StatelessWidget {
  const _OnboardingGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _OnboardCard(
                icon: Icons.forum_outlined,
                title: context.l10n.onboardingCardCoachTitle,
                body: context.l10n.onboardingCardCoachBody,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _OnboardCard(
                icon: Icons.bar_chart_outlined,
                title: context.l10n.onboardingCardScoreTitle,
                body: context.l10n.onboardingCardScoreBody,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _OnboardCard(
                icon: Icons.bolt_outlined,
                title: context.l10n.onboardingCardHookTitle,
                body: context.l10n.onboardingCardHookBody,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _OnboardCard(
                icon: Icons.verified_user_outlined,
                title: context.l10n.onboardingCardPrivateTitle,
                body: context.l10n.onboardingCardPrivateBody,
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
