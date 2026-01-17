import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/ui/buttons.dart';
import '../../../core/ui/cards.dart';
import '../../../core/ui/pills.dart';
import '../../../core/ui/screen_shell.dart';
import '../../../core/i18n/l10n_ext.dart';

class PremiumPreviewScreen extends ConsumerWidget {
  const PremiumPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenShell(
      title: context.l10n.premiumPreviewTitle,
      left: const BackButtonWidget(),
      right: Pill(label: context.l10n.premiumLabel, icon: Icons.workspace_premium, variant: PillVariant.success),
      footer: Column(
        children: [
          AppPrimaryButton(
            label: context.l10n.premiumPreviewStartAnother,
            icon: Icons.arrow_forward,
            onPressed: () => ref.read(appRouteProvider.notifier).goTo(AppRoute.priming),
          ),
          const SizedBox(height: 8),
          AppSecondaryButton(
            label: context.l10n.premiumPreviewBackToPaywall,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.premiumPreviewMagicLabel,
                  style: const TextStyle(fontSize: 12, color: AppTokens.textMuted),
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.premiumPreviewMagicTitle,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.premiumPreviewMagicBody,
                  style: const TextStyle(fontSize: 12, color: AppTokens.textSecondary, height: 1.4),
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
                          context.l10n.premiumModulesLabel,
                          style: const TextStyle(fontSize: 11, color: AppTokens.textMuted),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          context.l10n.premiumBriefingLibraryTitle,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Pill(label: context.l10n.featureFirstLabel, icon: Icons.layers_outlined),
                  ],
                ),
                const SizedBox(height: 10),
                _LibraryItem(
                  title: context.l10n.libraryItemCrisisTitle,
                  tag: context.l10n.libraryItemOneShotTag,
                  desc: context.l10n.libraryItemCrisisDesc,
                ),
                const SizedBox(height: 8),
                _LibraryItem(
                  title: context.l10n.libraryItemInterviewTitle,
                  tag: context.l10n.libraryItemOneShotTag,
                  desc: context.l10n.libraryItemInterviewDesc,
                ),
                const SizedBox(height: 8),
                _LibraryItem(
                  title: context.l10n.libraryItemStandupTitle,
                  tag: context.l10n.premiumLabel,
                  desc: context.l10n.libraryItemStandupDesc,
                ),
                const SizedBox(height: 8),
                _LibraryItem(
                  title: context.l10n.libraryItemNegotiationTitle,
                  tag: context.l10n.premiumLabel,
                  desc: context.l10n.libraryItemNegotiationDesc,
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
                Text(
                  context.l10n.premiumRetentionTitle,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                ),
                const SizedBox(height: 6),
                Text(
                  context.l10n.premiumRetentionBody,
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
