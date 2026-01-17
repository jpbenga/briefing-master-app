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
  String role = 'Support N2';
  bool uploading = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider);
    role = profile.role;
    companyController = TextEditingController(text: profile.company);
    metricController = TextEditingController(text: profile.dashboardMetric);
    targetController = TextEditingController(text: profile.target);
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

    return ScreenShell(
      title: 'Personalization',
      left: const BackButtonWidget(),
      right: const Pill(label: 'RAG Upload', icon: Icons.upload_file_outlined),
      footer: Column(
        children: [
          AppPrimaryButton(
            label: uploading ? 'Analyzing… Hydrating context' : 'Upload & Hydrate My Context',
            icon: Icons.upload,
            disabled: uploading,
            onPressed: () async {
              if (!hasPremium) {
                ref.read(paywallIntentProvider.notifier).state = PaywallIntent(
                  feature: 'Personalization (CV/Dashboard RAG)',
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
                language: 'English',
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
              const Text(
                'Simulated pipeline: Supabase Storage → NestJS gateway → Python RAG → pgvector',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: AppTokens.textMuted),
              ),
              if (!hasPremium)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    'Locked in Free. Upgrade to unlock personalization.',
                    style: TextStyle(fontSize: 11, color: Color(0xFFFDE68A)),
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
              children: const [
                Text('Upload simulation', style: TextStyle(fontSize: 12, color: AppTokens.textSecondary)),
                SizedBox(height: 6),
                Text(
                  'Make the app feel like it already “knows your career.”',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                ),
                SizedBox(height: 8),
                Text(
                  'This is not a form — it’s an investment trigger. The moment you input your reality, your brain commits.',
                  style: TextStyle(fontSize: 12, color: AppTokens.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _Field(
            label: 'Your role',
            child: DropdownButtonFormField<String>(
              value: role,
              items: const [
                DropdownMenuItem(value: 'Support N2', child: Text('Support N2')),
                DropdownMenuItem(value: 'Project Manager', child: Text('Project Manager')),
                DropdownMenuItem(value: 'Sales Executive', child: Text('Sales Executive')),
                DropdownMenuItem(value: 'Engineering Manager', child: Text('Engineering Manager')),
              ],
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
            label: 'Company context',
            child: TextField(
              controller: companyController,
              decoration: _fieldDecoration(hintText: 'e.g., Northstar Systems'),
              style: const TextStyle(fontSize: 13, color: AppTokens.textPrimary),
            ),
          ),
          const SizedBox(height: 12),
          _Field(
            label: 'Dashboard metric (high-stakes reality)',
            child: TextField(
              controller: metricController,
              decoration: _fieldDecoration(hintText: 'e.g., Q3 revenue down 20%'),
              style: const TextStyle(fontSize: 13, color: AppTokens.textPrimary),
            ),
          ),
          const SizedBox(height: 12),
          _Field(
            label: 'Your target identity',
            child: TextField(
              controller: targetController,
              decoration: _fieldDecoration(hintText: 'e.g., Sound like an Executive in crisis calls'),
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
                const Text(
                  'What changes after hydration?',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                ),
                const SizedBox(height: 8),
                _HydrationItem(text: 'Scenarios reference your role, your metrics, your pressure.'),
                _HydrationItem(text: 'Tier 3 rewrites adopt executive tone aligned to your domain.'),
                _HydrationItem(
                  text: 'Feedback becomes contextual, not generic. Higher perceived value → higher conversion.',
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
