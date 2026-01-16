# The Briefing Master (Flutter)

Base architecture Flutter pour le projet **The Briefing Master**. Cette structure pose les fondations pour une application mobile temps réel avec des modules clairs et évolutifs.

## Structure

```
lib/
  app/
    app.dart            # Configuration de l'app (theme, routes)
    router.dart         # Définition des routes
  core/
    di/                 # Dépendances (injection, services partagés)
    theme/              # Thèmes et styles globaux
    widgets/            # Widgets partagés
  features/
    home/
      presentation/
        home_screen.dart
        widgets/
```

## Démarrage rapide

```bash
flutter pub get
flutter run
```
