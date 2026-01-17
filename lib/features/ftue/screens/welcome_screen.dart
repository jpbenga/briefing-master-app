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

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenShell(
      title: 'The Briefing Master',
      left: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppTokens.surfaceMuted,
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
          border: Border.all(color: AppTokens.borderLight),
        ),
        child: const Icon(Icons.auto_awesome, size: 18, color: Color(0xFF67E8F9)),
      ),
      right: const Pill(
        label: 'Private • RLS',
        icon: Icons.verified_user_outlined,
      ),
      footer: Column(
        children: [
          AppPrimaryButton(
            label: 'Start your Executive Upgrade',
            icon: Icons.arrow_forward,
            onPressed: () {
              ref.read(modeProvider.notifier).state = AppMode.deepWork;
              ref.read(appRouteProvider.notifier).goTo(AppRoute.onboarding);
            },
          ),
          const SizedBox(height: 8),
          AppSecondaryButton(
            label: 'View Paywall (Pricing)',
            icon: Icons.lock_outline,
            onPressed: () {
              ref.read(modeProvider.notifier).state = AppMode.deepWork;
              ref.read(paywallIntentProvider.notifier).state = const PaywallIntent(
                feature: 'Competency Map + Pricing',
                from: AppRoute.welcome,
              );
              ref.read(appRouteProvider.notifier).goTo(AppRoute.paywall);
            },
          ),
          const SizedBox(height: 8),
          const Text(
            'Frictionless onboarding • Immediate “Aha” moment • Built for retention',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: AppTokens.textMuted),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          AppCard(
            backgroundColor: AppTokens.surfaceGlass,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'From Meeting Anxiety → Performance Flow',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTokens.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Prime. Speak. Drill. Anchor. Repeat.',
                            style: TextStyle(fontSize: 12, color: AppTokens.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0x1A06B6D4),
                        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                        border: Border.all(color: const Color(0x3306B6D4)),
                      ),
                      child: const Icon(Icons.bolt, size: 18, color: Color(0xFF67E8F9)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Expanded(child: _MiniStat(title: 'Sophistication', value: '+38', hint: 'Tier upgrades')),
                    SizedBox(width: 8),
                    Expanded(child: _MiniStat(title: 'Filler control', value: '-62%', hint: 'Hesitations')),
                    SizedBox(width: 8),
                    Expanded(child: _MiniStat(title: 'LTV driver', value: 'Streak', hint: 'Dopamine loop')),
                  ],
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
              children: const [
                Text('Your unfair advantage', style: TextStyle(fontSize: 12, color: AppTokens.textSecondary)),
                SizedBox(height: 4),
                Text(
                  'Personalized training using your CV + real dashboards.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                ),
                SizedBox(height: 8),
                Text(
                  'We don’t teach “random English.” We teach your English — for your meetings, your metrics, your pressure.',
                  style: TextStyle(fontSize: 12, color: AppTokens.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ModeButton(
                  label: 'Deep Work',
                  onTap: () => ref.read(modeProvider.notifier).state = AppMode.deepWork,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ModeButton(
                  label: 'Adrenaline',
                  onTap: () => ref.read(modeProvider.notifier).state = AppMode.adrenaline,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ModeButton(
                  label: 'Focus',
                  onTap: () => ref.read(modeProvider.notifier).state = AppMode.focus,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.title, required this.value, required this.hint});

  final String title;
  final String value;
  final String hint;

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
          Text(title, style: const TextStyle(fontSize: 10, color: AppTokens.textMuted)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(hint, style: const TextStyle(fontSize: 10, color: AppTokens.textMuted)),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppTokens.surfaceMuted,
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
          border: Border.all(color: AppTokens.borderLight),
        ),
        child: Center(
          child: Text(label, style: const TextStyle(fontSize: 12, color: AppTokens.textSecondary)),
        ),
      ),
    );
  }
}
