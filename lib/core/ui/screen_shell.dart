import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';
import '../../core/routing/app_router.dart';
import '../../core/routing/routes.dart';
import '../../features/monetization/logic/entitlements.dart';
import '../i18n/l10n_ext.dart';
import '../theme/tokens.dart';
import 'pills.dart';

class ScreenShell extends ConsumerWidget {
  const ScreenShell({
    super.key,
    required this.title,
    required this.child,
    this.left,
    this.right,
    this.footer,
  });

  final String title;
  final Widget child;
  final Widget? left;
  final Widget? right;
  final Widget? footer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Column(
          children: [
            _TopBar(title: title, left: left, right: right),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                child: child,
              ),
            ),
          ],
        ),
        if (footer != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xB3000000), Color(0x00000000)],
                ),
              ),
              child: footer,
            ),
          ),
      ],
    );
  }
}

class _TopBar extends ConsumerWidget {
  const _TopBar({required this.title, this.left, this.right});

  final String title;
  final Widget? left;
  final Widget? right;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(modeProvider);
    final route = ref.watch(currentRouteProvider);
    final hasPremium = ref.watch(hasPremiumProvider);
    final modeLabel = switch (mode) {
      AppMode.deepWork => context.l10n.modeDeepWork,
      AppMode.adrenaline => context.l10n.modeAdrenaline,
      AppMode.focus => context.l10n.modeFocus,
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (left != null) left!,
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTokens.textPrimary,
                    ),
                  ),
                  Text(
                    context.l10n.modeLabel(modeLabel),
                    style: const TextStyle(fontSize: 11, color: AppTokens.textMuted),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              if (right != null) right!,
              Padding(
                padding: EdgeInsets.only(left: right != null ? 8 : 0),
                child: Pill(
                  label: hasPremium ? context.l10n.planPremiumLabel : context.l10n.planFreeLabel,
                  icon: hasPremium ? Icons.workspace_premium : Icons.lock_outline,
                  variant: hasPremium ? PillVariant.success : PillVariant.muted,
                ),
              ),
              if (!hasPremium && route != AppRoute.paywall && route != AppRoute.premium)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: GestureDetector(
                    onTap: () {
                      ref.read(paywallIntentProvider.notifier).state = PaywallIntent(
                            feature: context.l10n.paywallFeatureUpgrade,
                            from: route,
                          );
                      ref.read(appRouteProvider.notifier).goTo(AppRoute.paywall);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0x1AF59E0B),
                        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                        border: Border.all(color: const Color(0x33F59E0B)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.lock_outline, size: 16, color: Color(0xFFFDE68A)),
                          SizedBox(width: 6),
                          _UpgradeLabel(),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UpgradeLabel extends StatelessWidget {
  const _UpgradeLabel();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.upgradeLabel,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFFDE68A)),
    );
  }
}

class BackButtonWidget extends ConsumerWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => ref.read(appRouteProvider.notifier).back(),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppTokens.surfaceMuted,
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
          border: Border.all(color: AppTokens.borderLight),
        ),
        child: const Icon(Icons.arrow_back, size: 18, color: AppTokens.textPrimary),
      ),
    );
  }
}

class AccentPill extends StatelessWidget {
  const AccentPill({super.key, required this.label, required this.icon, this.variant = PillVariant.muted});

  final String label;
  final IconData icon;
  final PillVariant variant;

  @override
  Widget build(BuildContext context) {
    return Pill(label: label, icon: icon, variant: variant);
  }
}
