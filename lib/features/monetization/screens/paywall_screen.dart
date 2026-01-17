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
import '../logic/entitlements.dart';

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final intent = ref.watch(paywallIntentProvider);
    final origin = intent?.from ?? AppRoute.priming;
    final feature = intent?.feature ?? 'Premium features';

    void completePurchase(PlanType plan) {
      ref.read(planProvider.notifier).state = plan;
      ref.read(paywallIntentProvider.notifier).state = null;
      ref.read(appRouteProvider.notifier).goTo(origin);
    }

    final map = [
      {'skill': 'Tone authority', 'l1': 42.0, 'l3': 86.0},
      {'skill': 'Structured briefing', 'l1': 48.0, 'l3': 90.0},
      {'skill': 'Metrics storytelling', 'l1': 39.0, 'l3': 84.0},
      {'skill': 'Handling objections', 'l1': 36.0, 'l3': 82.0},
    ];

    final plans = [
      _PlanCardData(
        tag: 'Free',
        title: 'Starter',
        price: '€0',
        cadence: 'forever',
        highlight: false,
        perks: [
          '1 scenario (Self-intro)',
          'Tier 1→2 suggestions',
          'Basic synonym quiz',
          'Limited streak tracking',
        ],
        cta: 'Keep training (Free)',
        onSelect: () => completePurchase(PlanType.free),
      ),
      _PlanCardData(
        tag: 'Most Popular',
        title: 'Premium',
        price: '€12.99',
        cadence: '/month',
        highlight: true,
        perks: [
          'Full briefing library (Crisis, Standups, Negotiation)',
          'Real-time coach (streaming tips)',
          'Dashboard OCR + RAG personalization',
          'Tier 3 executive rewrites',
          'SRS mastery scheduling',
        ],
        cta: 'Unlock Premium',
        onSelect: () => completePurchase(PlanType.premium),
      ),
      _PlanCardData(
        tag: 'One-shot',
        title: 'Crisis Sprint Pack',
        price: '€19.99',
        cadence: 'one-time',
        highlight: false,
        perks: [
          '7-day high-pressure sprint',
          'Executive rewrite templates',
          'Rapid quiz drills',
          'Interview/Crisis variants',
        ],
        cta: 'Buy Sprint Pack',
        onSelect: () => completePurchase(PlanType.sprint),
      ),
    ];

    return ScreenShell(
      title: 'Paywall',
      left: const BackButtonWidget(),
      right: GestureDetector(
        onTap: () => completePurchase(PlanType.premium),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0x1AF59E0B),
            borderRadius: BorderRadius.circular(AppTokens.radiusMd),
            border: Border.all(color: const Color(0x33F59E0B)),
          ),
          child: const Row(
            children: [
              Icon(Icons.workspace_premium, size: 16, color: Color(0xFFFDE68A)),
              SizedBox(width: 6),
              Text('Upgrade', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFFDE68A))),
            ],
          ),
        ),
      ),
      footer: Column(
        children: [
          AppPrimaryButton(
            label: 'Unlock Premium',
            icon: Icons.workspace_premium,
            onPressed: () => completePurchase(PlanType.premium),
          ),
          const SizedBox(height: 8),
          AppSecondaryButton(
            label: 'Not now',
            onPressed: () => ref.read(appRouteProvider.notifier).goTo(origin),
          ),
        ],
      ),
      child: Column(
        children: [
          AppCard(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x1AF59E0B), Color(0x00000000)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Paywall • Unlock', style: TextStyle(fontSize: 12, color: AppTokens.textMuted)),
                const SizedBox(height: 4),
                Text(
                  'Feature requested: $feature',
                  style: const TextStyle(fontSize: 12, color: Color(0xFFFDE68A)),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Every Tier 1 meeting costs authority.',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Don’t just “speak English.” Speak leadership. Unlock Tier 3 language, live coaching, and personalized scenarios from your real metrics.',
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
                        Text('Your current level', style: TextStyle(fontSize: 11, color: AppTokens.textMuted)),
                        SizedBox(height: 2),
                        Text(
                          'Tier 1–2 (inconsistent)',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Target requirement', style: TextStyle(fontSize: 11, color: AppTokens.textMuted)),
                        SizedBox(height: 2),
                        Text(
                          'Tier 3 (executive)',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  children: map
                      .map(
                        (row) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0x26000000),
                              borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                              border: Border.all(color: AppTokens.borderLight),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      row['skill'] as String,
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                    ),
                                    const Text('L1→L3', style: TextStyle(fontSize: 11, color: AppTokens.textMuted)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Current', style: TextStyle(fontSize: 10, color: AppTokens.textMuted)),
                                          const SizedBox(height: 4),
                                          ProgressBarWidget(value: row['l1'] as double),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Required', style: TextStyle(fontSize: 10, color: AppTokens.textMuted)),
                                          const SizedBox(height: 4),
                                          ProgressBarWidget(value: row['l3'] as double),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Loss aversion: every meeting at Tier 1 leaks credibility.',
                                  style: TextStyle(fontSize: 11, color: AppTokens.textMuted),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Choose your upgrade',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Pricing built to maximize activation + LTV.',
                          style: TextStyle(fontSize: 12, color: AppTokens.textSecondary),
                        ),
                      ],
                    ),
                    Pill(label: 'Pricing', icon: Icons.workspace_premium, variant: PillVariant.muted),
                  ],
                ),
                const SizedBox(height: 12),
                Column(children: plans.map(_PlanCard.new).toList()),
                const SizedBox(height: 8),
                const Text(
                  'Secure purchase flow (placeholder). In production: Stripe / RevenueCat + Supabase entitlements.',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Premium unlocks',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _Benefit(
                        icon: Icons.workspace_premium,
                        title: 'Full briefing library',
                        body: 'Crisis, standups, negotiations, leadership updates.',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _Benefit(
                        icon: Icons.upload_file_outlined,
                        title: 'Dashboard OCR + RAG',
                        body: 'Scenarios built from your real metrics.',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _Benefit(
                        icon: Icons.mic,
                        title: 'Live coach',
                        body: 'Streaming feedback with executive polish.',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _Benefit(
                        icon: Icons.bolt,
                        title: 'Retention engine',
                        body: 'Streaks, SRS mastery, role-based packs.',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCardData {
  const _PlanCardData({
    required this.tag,
    required this.title,
    required this.price,
    required this.cadence,
    required this.highlight,
    required this.perks,
    required this.cta,
    required this.onSelect,
  });

  final String tag;
  final String title;
  final String price;
  final String cadence;
  final bool highlight;
  final List<String> perks;
  final String cta;
  final VoidCallback onSelect;
}

class _PlanCard extends StatelessWidget {
  const _PlanCard(this.data);

  final _PlanCardData data;

  @override
  Widget build(BuildContext context) {
    final cardColor = data.highlight ? const Color(0x1AF59E0B) : AppTokens.surfaceGlass;
    final border = data.highlight ? const Color(0x33F59E0B) : AppTokens.borderLight;
    final tagColor = data.highlight ? const Color(0x1AF59E0B) : AppTokens.surfaceMuted;
    final tagText = data.highlight ? const Color(0xFFFDE68A) : AppTokens.textSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: tagColor,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: border),
                          ),
                          child: Text(
                            data.tag,
                            style: TextStyle(fontSize: 11, color: tagText),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          data.title,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          data.price,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(width: 6),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            data.cadence,
                            style: const TextStyle(fontSize: 12, color: AppTokens.textMuted),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: data.onSelect,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: data.highlight ? Colors.white : AppTokens.surfaceMuted,
                    borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                    border: Border.all(color: AppTokens.borderLight),
                  ),
                  child: Text(
                    data.cta,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: data.highlight ? AppTokens.zinc950 : AppTokens.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: data.perks
                .map(
                  (perk) => SizedBox(
                    width: 150,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle, size: 16, color: AppTokens.emerald),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            perk,
                            style: const TextStyle(fontSize: 11, color: AppTokens.textSecondary, height: 1.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          if (data.highlight)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                '★ Best value: unlock Tier 3 rewrites + real-time coaching + personalization.',
                style: TextStyle(fontSize: 11, color: AppTokens.textMuted),
              ),
            ),
        ],
      ),
    );
  }
}

class _Benefit extends StatelessWidget {
  const _Benefit({required this.icon, required this.title, required this.body});

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
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
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
