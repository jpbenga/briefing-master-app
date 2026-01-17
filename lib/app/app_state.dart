import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/routing/routes.dart';
import '../core/theme/tokens.dart';

class UserProfile {
  const UserProfile({
    required this.hydrated,
    required this.role,
    required this.company,
    required this.dashboardMetric,
    required this.target,
    required this.language,
  });

  final bool hydrated;
  final String role;
  final String company;
  final String dashboardMetric;
  final String target;
  final String language;

  UserProfile copyWith({
    bool? hydrated,
    String? role,
    String? company,
    String? dashboardMetric,
    String? target,
    String? language,
  }) {
    return UserProfile(
      hydrated: hydrated ?? this.hydrated,
      role: role ?? this.role,
      company: company ?? this.company,
      dashboardMetric: dashboardMetric ?? this.dashboardMetric,
      target: target ?? this.target,
      language: language ?? this.language,
    );
  }

  static const UserProfile defaultProfile = UserProfile(
    hydrated: false,
    role: 'Support N2',
    company: 'Northstar Systems',
    dashboardMetric: 'Q3 revenue down 20%',
    target: 'Sound like an Executive in crisis calls',
    language: 'English',
  );
}

final userProfileProvider = StateProvider<UserProfile>((ref) => UserProfile.defaultProfile);

final modeProvider = StateProvider<AppMode>((ref) => AppMode.deepWork);

final paywallIntentProvider = StateProvider<PaywallIntent?>((ref) => null);
