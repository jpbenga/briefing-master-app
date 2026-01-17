import 'package:flutter/material.dart';

import '../routing/routes.dart';

enum AppMode { deepWork, adrenaline, focus }

class AppModeStyle {
  const AppModeStyle({
    required this.badgeColor,
    required this.glowGradient,
  });

  final Color badgeColor;
  final LinearGradient glowGradient;
}

class AppTokens {
  static const fontFamilyFallback =
      'Inter, ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial';

  static const double radiusSm = 16;
  static const double radiusMd = 20;
  static const double radiusLg = 24;

  static const double padding = 16;
  static const double paddingSm = 12;
  static const double paddingXs = 8;

  static const Color background = Color(0xFF09090B);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceGlass = Color(0x1AFFFFFF);
  static const Color surfaceMuted = Color(0x0DFFFFFF);
  static const Color textPrimary = Color(0xFFEDEDED);
  static const Color textSecondary = Color(0xB3FFFFFF);
  static const Color textMuted = Color(0x80FFFFFF);
  static const Color borderLight = Color(0x1AFFFFFF);
  static const Color borderDark = Color(0x14000000);

  static const Color emerald = Color(0xFF34D399);
  static const Color amber = Color(0xFFF59E0B);
  static const Color rose = Color(0xFFF43F5E);
  static const Color indigo = Color(0xFF6366F1);
  static const Color cyan = Color(0xFF22D3EE);
  static const Color sky = Color(0xFF38BDF8);
  static const Color teal = Color(0xFF14B8A6);

  static const Color zinc950 = Color(0xFF09090B);
  static const Color zinc900 = Color(0xFF18181B);

  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x38000000),
    blurRadius: 30,
    offset: Offset(0, 10),
  );

  static const BoxShadow softShadow = BoxShadow(
    color: Color(0x1F000000),
    blurRadius: 30,
    offset: Offset(0, 10),
  );

  static const LinearGradient topGlow = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x14FFFFFF), Color(0x00000000)],
  );

  static const LinearGradient screenOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x14000000), Color(0x00000000)],
  );

  static const Map<AppMode, AppModeStyle> modes = {
    AppMode.deepWork: AppModeStyle(
      badgeColor: Color(0xFF27272A),
      glowGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x1AFFFFFF), Color(0x0DFFFFFF), Color(0x00000000)],
      ),
    ),
    AppMode.adrenaline: AppModeStyle(
      badgeColor: Color(0x33F43F5E),
      glowGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x33FB7185), Color(0x1AF59E0B), Color(0x00000000)],
      ),
    ),
    AppMode.focus: AppModeStyle(
      badgeColor: Color(0x336366F1),
      glowGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x336366F1), Color(0x1A22D3EE), Color(0x00000000)],
      ),
    ),
  };

  static LinearGradient routeAura(AppRoute route) {
    switch (route) {
      case AppRoute.welcome:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x40FFFFFF), Color(0x1A6366F1), Color(0x00000000)],
        );
      case AppRoute.onboarding:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x3322D3EE), Color(0x0DFFFFFF), Color(0x00000000)],
        );
      case AppRoute.upload:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x4022D3EE), Color(0x1A6366F1), Color(0x00000000)],
        );
      case AppRoute.priming:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x4022D3EE), Color(0x00000000), Color(0x00000000)],
        );
      case AppRoute.speaking:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x40FB7185), Color(0x1AF59E0B), Color(0x00000000)],
        );
      case AppRoute.quiz:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x406366F1), Color(0x1A22D3EE), Color(0x00000000)],
        );
      case AppRoute.revision:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x4010B981), Color(0x00000000), Color(0x00000000)],
        );
      case AppRoute.paywall:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x40F59E0B), Color(0x00000000), Color(0x00000000)],
        );
      case AppRoute.premium:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x40FCD34D), Color(0x1A67E8F9), Color(0x00000000)],
        );
    }
  }

  static LinearGradient routeAccentLine(AppRoute route) {
    switch (route) {
      case AppRoute.welcome:
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xCC06B6D4), Color(0x806366F1), Color(0x00000000)],
        );
      case AppRoute.onboarding:
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xB306B6D4), Color(0x6640C4FF), Color(0x00000000)],
        );
      case AppRoute.upload:
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xCC06B6D4), Color(0x806366F1), Color(0x00000000)],
        );
      case AppRoute.priming:
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xCC06B6D4), Color(0x00000000), Color(0x00000000)],
        );
      case AppRoute.speaking:
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xCCF43F5E), Color(0x80F59E0B), Color(0x00000000)],
        );
      case AppRoute.quiz:
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xCC6366F1), Color(0x8022D3EE), Color(0x00000000)],
        );
      case AppRoute.revision:
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xCC10B981), Color(0x7342CFCB), Color(0x00000000)],
        );
      case AppRoute.paywall:
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xCCF59E0B), Color(0x734A2C02), Color(0x00000000)],
        );
      case AppRoute.premium:
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xCCFCD34D), Color(0x7367E8F9), Color(0x00000000)],
        );
    }
  }
}
