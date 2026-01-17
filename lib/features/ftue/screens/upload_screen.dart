import 'dart:async';

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
import '../../../core/i18n/learning_locale_provider.dart';
import '../../../core/learning/language_catalog.dart';
import '../../monetization/logic/entitlements.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  late TextEditingController companyController;
  late TextEditingController metricController;
  late TextEditingController targetController;
  String role = '';
  bool uploading = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    companyController = TextEditingController();
    metricController = TextEditingController();
    targetController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final profile = ref.read(userProfileProvider);
    final roleOptions = _roleOptions(context);
    role = roleOptions.contains(profile.role) ? profile.role : roleOptions.first;
    companyController.text = profile.company;
    metricController.text = profile.dashboardMetric;
    targetController.text = profile.target;
    _initialized = true;
  }

  @override
  void dispose() {
    companyController.dispose();
    metricController.dispose();
    targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasPremium = ref.watch(hasPremiumProvider);
    final learningLocale = ref.watch(learningLocaleProvider);
    final learningLanguage = LanguageCatalog.byCode(learningLocale.languageCode);

    return ScreenShell(
      title: context.l10n.uploadTitle,
      left: const BackButtonWidget(),
      right: Pill(label: context.l10n.uploadRagLabel, icon: Icons.upload_file_outlined),
      footer: Column(
        children: [
          AppPrimaryButton(
            label: uploading ? context.l10n.uploadAnalyzingLabel : context.l10n.uploadHydrateCta,
            icon: Icons.upload,
            disabled: uploading,
            onPressed: () async {
              if (!hasPremium) {
                ref.read(paywallIntentProvider.notifier).state = PaywallIntent(
                  feature: context.l10n.paywallFeaturePersonalization,
                  from: AppRoute.upload,
                );
                ref.read(appRouteProvider.notifier).goTo(AppRoute.paywall);
                return;
              }

              setState(() => uploading = true);
              await Future<void>.delayed(const Duration(milliseconds: 900));
              ref.read(userProfileProvider.notifier).state = UserProfile(
                hydrated: true,
                role: role,
                company: companyController.text,
                dashboardMetric: metricController.text,
                target: targetController.text,
                language: learningLanguage?.nameEnglish ?? learningLocale.languageCode,
              );
              if (mounted) {
                setState(() => uploading = false);
                ref.read(appRouteProvider.notifier).goTo(AppRoute.priming);
              }
            },
          ),
          const SizedBox(height: 6),
          Column(
            children: [
              Text(
                context.l10n.uploadPipelineNote,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: AppTokens.textMuted),
              ),
              if (!hasPremium)
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    context.l10n.uploadLockedNote,
                    style: const TextStyle(fontSize: 11, color: Color(0xFFFDE68A)),
                  ),
                ),
            ],
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
                  context.l10n.uploadSimulationLabel,
                  style: const TextStyle(fontSize: 12, color: AppTokens.textSecondary),
                ),
                const SizedBox(height: 6),
                Text(
                  context.l10n.uploadSimulationTitle,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.uploadSimulationBody,
                  style: const TextStyle(fontSize: 12, color: AppTokens.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _Field(
            label: context.l10n.uploadRoleLabel,
            child: DropdownButtonFormField<String>(
              value: role,
              items: _roleOptions(context)
                  .map((option) => DropdownMenuItem(value: option, child: Text(option)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => role = value);
                }
              },
              dropdownColor: AppTokens.zinc900,
              decoration: _fieldDecoration(),
            ),
          ),
          const SizedBox(height: 12),
          _Field(
            label: context.l10n.uploadCompanyLabel,
            child: TextField(
              controller: companyController,
              decoration: _fieldDecoration(hintText: context.l10n.uploadCompanyHint),
              style: const TextStyle(fontSize: 13, color: AppTokens.textPrimary),
            ),
          ),
          const SizedBox(height: 12),
          _Field(
            label: context.l10n.uploadMetricLabel,
            child: TextField(
              controller: metricController,
              decoration: _fieldDecoration(hintText: context.l10n.uploadMetricHint),
              style: const TextStyle(fontSize: 13, color: AppTokens.textPrimary),
            ),
          ),
          const SizedBox(height: 12),
          _Field(
            label: context.l10n.uploadTargetLabel,
            child: TextField(
              controller: targetController,
              decoration: _fieldDecoration(hintText: context.l10n.uploadTargetHint),
              style: const TextStyle(fontSize: 13, color: AppTokens.textPrimary),
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
                  context.l10n.uploadChangesTitle,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                ),
                const SizedBox(height: 8),
                _HydrationItem(text: context.l10n.uploadChangeScenario),
                _HydrationItem(text: context.l10n.uploadChangeTier3),
                _HydrationItem(
                  text: context.l10n.uploadChangeFeedback,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 13, color: AppTokens.textMuted),
      filled: true,
      fillColor: AppTokens.surfaceMuted,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        borderSide: BorderSide(color: AppTokens.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        borderSide: BorderSide(color: AppTokens.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        borderSide: const BorderSide(color: Color(0xFF67E8F9)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  List<String> _roleOptions(BuildContext context) {
    return [
      context.l10n.roleSupportN2,
      context.l10n.roleProjectManager,
      context.l10n.roleSalesExecutive,
      context.l10n.roleEngineeringManager,
    ];
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppTokens.textMuted)),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}

class _HydrationItem extends StatelessWidget {
  const _HydrationItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 16, color: AppTokens.emerald),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: AppTokens.textSecondary, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}
