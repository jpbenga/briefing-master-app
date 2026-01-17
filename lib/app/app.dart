import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/routing/app_router.dart';
import '../core/routing/routes.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/tokens.dart';
import '../core/ui/mobile_frame.dart';
import '../core/ui/transitions.dart';
import '../features/ftue/screens/onboarding_screen.dart';
import '../features/ftue/screens/upload_screen.dart';
import '../features/ftue/screens/welcome_screen.dart';
import '../features/learning/screens/priming_screen.dart';
import '../features/learning/screens/quiz_screen.dart';
import '../features/learning/screens/revision_screen.dart';
import '../features/learning/screens/speaking_screen.dart';
import '../features/monetization/screens/paywall_screen.dart';
import '../features/monetization/screens/premium_preview_screen.dart';

class BriefingMasterApp extends StatelessWidget {
  const BriefingMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Briefing Master',
      theme: AppTheme.dark(),
      home: const AppShell(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeState = ref.watch(appRouteProvider);

    return Scaffold(
      backgroundColor: AppTokens.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: MobileFrame(
            child: ScreenTransition(
              routeKey: ValueKey(routeState.route.label),
              child: _routeScreen(routeState.route),
            ),
          ),
        ),
      ),
    );
  }

  Widget _routeScreen(AppRoute route) {
    switch (route) {
      case AppRoute.welcome:
        return const WelcomeScreen();
      case AppRoute.onboarding:
        return const OnboardingScreen();
      case AppRoute.upload:
        return const UploadScreen();
      case AppRoute.priming:
        return const PrimingScreen();
      case AppRoute.speaking:
        return const SpeakingScreen();
      case AppRoute.quiz:
        return const QuizScreen();
      case AppRoute.revision:
        return const RevisionScreen();
      case AppRoute.paywall:
        return const PaywallScreen();
      case AppRoute.premium:
        return const PremiumPreviewScreen();
    }
  }
}
