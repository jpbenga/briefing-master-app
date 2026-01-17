import 'package:briefing_master/app/app.dart';
import 'package:briefing_master/core/i18n/locale_persistence.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      LocalePersistence.uiLocaleKey: 'en',
      LocalePersistence.learningLocaleKey: 'en',
    });
  });

  testWidgets('Welcome to onboarding to paywall upgrade flow', (tester) async {
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const BriefingMasterApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sound confident in meetings — in 3 minutes/day.'), findsOneWidget);

    await tester.tap(find.text('Start a 3-minute session'));
    await tester.pumpAndSettle();

    expect(find.text('Your first win in under 2 minutes.'), findsOneWidget);

    await tester.tap(find.text('Personalize my scenarios (recommended)'));
    await tester.pumpAndSettle();

    expect(find.text('Make scenarios feel like your real job.'), findsOneWidget);

    await tester.tap(find.text('Unlock Premium to upload'));
    await tester.pumpAndSettle();

    expect(find.text('Plans & Pricing'), findsOneWidget);

    await tester.tap(find.text('Unlock Premium'));
    await tester.pumpAndSettle();

    expect(find.text('Upload & personalize'), findsOneWidget);
  });
}
