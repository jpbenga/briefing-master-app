import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../features/home/presentation/home_screen.dart';
import 'router.dart';

class BriefingMasterApp extends StatelessWidget {
  const BriefingMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Briefing Master',
      theme: AppTheme.light(),
      onGenerateRoute: AppRouter.onGenerateRoute,
      home: const HomeScreen(),
    );
  }
}
