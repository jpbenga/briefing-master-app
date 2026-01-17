enum AppRoute {
  welcome,
  onboarding,
  upload,
  priming,
  speaking,
  quiz,
  revision,
  paywall,
  premium,
}

extension AppRouteLabel on AppRoute {
  String get label {
    switch (this) {
      case AppRoute.welcome:
        return 'Welcome';
      case AppRoute.onboarding:
        return 'Onboarding';
      case AppRoute.upload:
        return 'Upload';
      case AppRoute.priming:
        return 'Priming';
      case AppRoute.speaking:
        return 'Speaking';
      case AppRoute.quiz:
        return 'Quiz';
      case AppRoute.revision:
        return 'Revision';
      case AppRoute.paywall:
        return 'Paywall';
      case AppRoute.premium:
        return 'Premium';
    }
  }
}

class PaywallIntent {
  const PaywallIntent({required this.feature, required this.from});

  final String feature;
  final AppRoute from;
}
