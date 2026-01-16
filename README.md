# The Briefing Master (Flutter)

Base architecture Flutter pour le projet **The Briefing Master**. Cette structure pose les fondations pour une application mobile temps réel avec des modules clairs et évolutifs.

## Principes d'architecture

- **Modularité stricte** : chaque domaine métier reste isolé derrière des interfaces publiques (pas d'import direct entre modules).
- **i18n d'abord** : tout texte visible par l'utilisateur doit utiliser des clés de traduction.
- **Flux événementiels** : les actions majeures publient des événements de domaine plutôt que des appels directs.
- **Performance mobile** : animations à 60fps, gestion audio/WebRTC optimisée et composants légers.

## Blueprint architectural (hybride AI-native)

### Objectifs clés

- Expérience mobile fluide (60fps) avec rendu Impeller et visualisation audio.
- Personnalisation profonde via données réelles (CV + dashboards).
- Orchestration temps réel avec faible latence (WebSocket + gRPC).
- Modularité stricte par domaines pour éviter le couplage.

### Stack cible (hybride)

- **Flutter** (mobile client) : UI/UX temps réel, VAD local, offline-first.
- **NestJS** (API Gateway) : orchestration, règles métier, WebSocket.
- **Python** (service IA) : RAG, parsing Excel/PDF, analyse sémantique.
- **Supabase** (PostgreSQL) : Auth, RLS, stockage, pgvector.

### Répartition des responsabilités

- **Supabase (Commodity Layer)** : Auth, persistence, realtime, RLS, vector store.
- **NestJS (Business Layer)** : validation, orchestration, events de domaine, quotas.
- **Python (Intelligence Layer)** : parsing, chunking, embeddings, scoring linguistique.

### Frontend Flutter

- **State management** : Riverpod (providers composables, AsyncValue).
- **Structure** : organisation par features (feature-first) avec API publique minimale.
- **Audio** : VAD local, visualisation via shaders compatibles Impeller.
- **Offline-first** : cache local (Isar/Hive) pour révisions et contenus pédagogiques.

### Backend NestJS (Modular Monolith DDD)

- **Domaines** : Simulation, Pedagogy, Content, IAM/Profile, Analytics.
- **Découplage** : communication inter-domaines par événements (ex. MeetingConcluded).
- **Protocoles** :
  - Flutter ↔ NestJS : WebSocket (Socket.io) pour flux temps réel.
  - NestJS ↔ Python : gRPC (contrats Protobuf).

### Service IA Python (RAG)

- **Ingestion** : extraction texte (PDF/Excel) avec parsing sémantique.
- **Chunking** : segmentation contextuelle (par rôles, sections, tableaux).
- **Vectorisation** : embeddings (OpenAI ou HF) et stockage pgvector.
- **Analyse** : scoring PREP, professionnalisme, feedback linguistique.

### Données & i18n

- **Contenu dynamique** : JSONB pour champs traduits (title_i18n, description_i18n).
- **RLS** : isolation stricte par user_id sur documents et embeddings.
- **Hybrid search** : full-text + pgvector avec score fusionné (RRF).

### Flux critiques (exemples)

- **Upload CV/Excel** : Flutter → Supabase Storage → webhook NestJS → job BullMQ → Python RAG → Supabase pgvector.
- **Session temps réel** : Flutter WebSocket → NestJS → gRPC Python → feedback streaming vers client.

### Contraintes non négociables

- Pas d'import direct entre modules métiers.
- Aucun texte user-facing sans clé i18n.
- Sécurité by design (JWT Supabase, RLS, stockage privé).
- Détection d'activité vocale locale pour réduire latence et coût.

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
