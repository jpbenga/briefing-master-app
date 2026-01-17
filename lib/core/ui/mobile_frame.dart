import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../routing/app_router.dart';
import '../theme/tokens.dart';
import '../../app/app_state.dart';
import '../i18n/l10n_ext.dart';

class MobileFrame extends ConsumerWidget {
  const MobileFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(currentRouteProvider);
    final mode = ref.watch(modeProvider);
    final accent = AppTokens.routeAura(route);
    final accentLine = AppTokens.routeAccentLine(route);
    final modeGlow = AppTokens.modes[mode]!.glowGradient;

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              alignment: Alignment.topCenter,
              child: Container(
                width: 780,
                height: 780,
                decoration: BoxDecoration(
                  gradient: modeGlow,
                  shape: BoxShape.circle,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
        Container(
          width: 390,
          constraints: const BoxConstraints(maxWidth: 420),
          child: AspectRatio(
            aspectRatio: 9 / 19,
            child: Container(
              decoration: BoxDecoration(
                color: AppTokens.background,
                borderRadius: BorderRadius.circular(AppTokens.radiusLg),
                border: Border.all(color: AppTokens.borderLight),
                boxShadow: const [AppTokens.cardShadow],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Container(color: AppTokens.background),
                  Container(decoration: const BoxDecoration(gradient: AppTokens.topGlow)),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Transform.translate(
                      offset: const Offset(0, -96),
                      child: Container(
                        width: 520,
                        height: 520,
                        decoration: BoxDecoration(
                          gradient: accent,
                          shape: BoxShape.circle,
                        ),
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: _StatusBar(),
                  ),
                  Positioned(
                    top: 40,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Container(
                          height: 2,
                          decoration: BoxDecoration(gradient: accentLine),
                        ),
                        Container(
                          height: 10,
                          decoration: const BoxDecoration(gradient: AppTokens.screenOverlay),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: child,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTokens.emerald.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                context.l10n.statusLive,
                style: const TextStyle(fontSize: 11, color: AppTokens.textMuted),
              ),
            ],
          ),
          Row(
            children: [
              Text(context.l10n.statusTime, style: const TextStyle(fontSize: 11, color: AppTokens.textMuted)),
              const SizedBox(width: 6),
              const Text('•', style: TextStyle(fontSize: 11, color: AppTokens.textMuted)),
              const SizedBox(width: 6),
              Text(context.l10n.statusNetwork, style: const TextStyle(fontSize: 11, color: AppTokens.textMuted)),
              const SizedBox(width: 6),
              const Text('•', style: TextStyle(fontSize: 11, color: AppTokens.textMuted)),
              const SizedBox(width: 6),
              Text(context.l10n.statusBattery, style: const TextStyle(fontSize: 11, color: AppTokens.textMuted)),
            ],
          ),
        ],
      ),
    );
  }
}
