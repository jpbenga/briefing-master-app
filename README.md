# The Briefing Master (Flutter)

Base architecture Flutter pour le projet **The Briefing Master**. Cette structure pose les fondations pour une application mobile temps réel avec des modules clairs et évolutifs.

## Principes d'architecture

- **Modularité stricte** : chaque domaine métier reste isolé derrière des interfaces publiques (pas d'import direct entre modules).
- **i18n d'abord** : tout texte visible par l'utilisateur doit utiliser des clés de traduction.
- **Flux événementiels** : les actions majeures publient des événements de domaine plutôt que des appels directs.
- **Performance mobile** : animations à 60fps, gestion audio/WebRTC optimisée et composants légers.

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
