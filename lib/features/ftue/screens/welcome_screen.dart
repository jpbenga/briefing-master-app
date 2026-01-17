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
import '../../../core/i18n/ui_locale_provider.dart';
import '../../../core/i18n/learning_locale_provider.dart';
import '../../../core/learning/language_catalog.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenShell(
      title: context.l10n.welcomeTitle,
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
      right: const _LocaleSelectors(),
      footer: Column(
        children: [
          AppPrimaryButton(
            label: context.l10n.welcomeStartCta,
            icon: Icons.arrow_forward,
            onPressed: () {
              ref.read(modeProvider.notifier).state = AppMode.deepWork;
              ref.read(appRouteProvider.notifier).goTo(AppRoute.onboarding);
            },
          ),
          const SizedBox(height: 8),
          AppSecondaryButton(
            label: context.l10n.welcomeViewPaywall,
            icon: Icons.lock_outline,
            onPressed: () {
              ref.read(modeProvider.notifier).state = AppMode.deepWork;
              ref.read(paywallIntentProvider.notifier).state = PaywallIntent(
                feature: context.l10n.paywallFeatureCompetencyMapPricing,
                from: AppRoute.welcome,
              );
              ref.read(appRouteProvider.notifier).goTo(AppRoute.paywall);
            },
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.welcomeFooterTagline,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: AppTokens.textMuted),
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.welcomeHeroTitle,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTokens.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            context.l10n.welcomeHeroSubtitle,
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
                Row(
                  children: [
                    Expanded(child: _MiniStat(title: context.l10n.miniStatSophistication, value: '+38', hint: context.l10n.miniStatTierUpgrades)),
                    const SizedBox(width: 8),
                    Expanded(child: _MiniStat(title: context.l10n.miniStatFillerControl, value: '-62%', hint: context.l10n.miniStatHesitations)),
                    const SizedBox(width: 8),
                    Expanded(child: _MiniStat(title: context.l10n.miniStatLtvDriver, value: context.l10n.miniStatStreak, hint: context.l10n.miniStatDopamineLoop)),
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
              children: [
                Text(
                  context.l10n.welcomeAdvantageLabel,
                  style: const TextStyle(fontSize: 12, color: AppTokens.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.welcomeAdvantageTitle,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.welcomeAdvantageBody,
                  style: const TextStyle(fontSize: 12, color: AppTokens.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ModeButton(
                  label: context.l10n.modeDeepWork,
                  onTap: () => ref.read(modeProvider.notifier).state = AppMode.deepWork,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ModeButton(
                  label: context.l10n.modeAdrenaline,
                  onTap: () => ref.read(modeProvider.notifier).state = AppMode.adrenaline,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ModeButton(
                  label: context.l10n.modeFocus,
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

class _LocaleSelectors extends ConsumerWidget {
  const _LocaleSelectors();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiLocale = ref.watch(uiLocaleProvider);
    final learningLocale = ref.watch(learningLocaleProvider);
    final languages = LanguageCatalog.supported;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Pill(
          label: context.l10n.privateRlsLabel,
          icon: Icons.verified_user_outlined,
        ),
        const SizedBox(height: 6),
        _LocaleDropdown(
          label: context.l10n.appLanguageLabel,
          value: uiLocale.languageCode,
          onChanged: (value) {
            if (value != null) {
              ref.read(uiLocaleProvider.notifier).updateLocale(Locale(value));
            }
          },
          items: languages.map(_languageLabel).toList(),
        ),
        const SizedBox(height: 6),
        _LocaleDropdown(
          label: context.l10n.learningLanguageLabel,
          value: learningLocale.languageCode,
          onChanged: (value) {
            if (value != null) {
              ref.read(learningLocaleProvider.notifier).updateLocale(Locale(value));
            }
          },
          items: languages.map(_languageLabel).toList(),
        ),
      ],
    );
  }

  DropdownMenuItem<String> _languageLabel(LearningLanguage language) {
    final label = [
      if (language.flagEmoji != null) language.flagEmoji,
      language.nameNative,
    ].join(' ');
    return DropdownMenuItem<String>(
      value: language.code,
      child: Text(label),
    );
  }
}

class _LocaleDropdown extends StatelessWidget {
  const _LocaleDropdown({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.items,
  });

  final String label;
  final String value;
  final ValueChanged<String?> onChanged;
  final List<DropdownMenuItem<String>> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppTokens.surfaceMuted,
        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        border: Border.all(color: AppTokens.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: AppTokens.textMuted)),
          DropdownButton<String>(
            value: value,
            isDense: true,
            items: items,
            onChanged: onChanged,
            dropdownColor: AppTokens.zinc900,
            style: const TextStyle(fontSize: 11, color: AppTokens.textPrimary),
            underline: const SizedBox.shrink(),
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
