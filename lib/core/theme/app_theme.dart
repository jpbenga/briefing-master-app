import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tokens.dart';

class AppTheme {
  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppTokens.background,
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: AppTokens.textPrimary,
        displayColor: AppTokens.textPrimary,
      ),
      colorScheme: base.colorScheme.copyWith(
        surface: AppTokens.background,
        primary: Colors.white,
        secondary: AppTokens.cyan,
      ),
      dividerColor: AppTokens.borderLight,
    );
  }
}
