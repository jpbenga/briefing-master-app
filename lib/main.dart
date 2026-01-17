import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Ajoute ceci
import 'package:supabase_flutter/supabase_flutter.dart'; // Ajoute ceci
import 'package:briefing_master/app/app.dart';
import 'package:briefing_master/core/i18n/locale_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 1. Charger les variables d'environnement
    await dotenv.load(fileName: ".env");

    // 2. Initialiser Supabase
    await Supabase.initialize(
      url: dotenv.get('SUPABASE_URL'),
      anonKey: dotenv.get('SUPABASE_ANON_KEY'),
    );

    final prefs = await SharedPreferences.getInstance();

    runApp(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const BriefingMasterApp(),
      ),
    );
  }, (error, stack) {
    debugPrint('Erreur de lancement: $error');
  });
}