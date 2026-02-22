# Teary (TearDrop)

## Branding
- **Published name**: Teary (App Store, Play Store, web)
- **Internal codebase name**: TearDrop (package name: `teardrop`, all source code references)
- **Bundle IDs**: `com.tangza.teary` (iOS & Android)
- **Firebase project**: `teary-app`

## Project Overview
Flutter app — "Digital Prescription for Dry Eyes" (안구건조증을 위한 디지털 처방전). Plays emotional YouTube videos to induce natural tears.

## Firebase
- **Project ID**: `teary-app`
- **Account**: tangza@gmail.com
- **Firestore**: asia-northeast3 (Seoul)
- **Auth**: Anonymous, Google, Email enabled
- **Hosting**: `teary-app.web.app`

## Architecture
- **State**: Riverpod (manual, no codegen)
- **Models**: freezed + json_serializable (run `dart run build_runner build --delete-conflicting-outputs` after model changes)
- **Navigation**: GoRouter ShellRoute with 3-tab bottom nav
- **Auth**: Anonymous sign-in on "Start Therapy" button

## Key Files
- `lib/main.dart` — Entry point, Firebase init
- `lib/firebase_options.dart` — Firebase config (DO NOT manually edit; use `flutterfire configure`)
- `lib/src/app_router.dart` — All routes
- `lib/src/data/preset_data.dart` — Hardcoded video collections
- `lib/src/data/models/` — freezed data models
- `firestore.rules` — Firestore security rules
- `firebase.json` — Firebase hosting config

## Commands
```bash
flutter pub get                                    # Install deps
dart run build_runner build --delete-conflicting-outputs  # Codegen
flutter analyze                                    # Lint
flutter test                                       # Tests
flutter run -d <device>                            # Run
firebase deploy --only firestore:rules --project teary-app  # Deploy rules
flutter build web && firebase deploy --only hosting --project teary-app  # Deploy web
```

## Platform Targets
- iOS: 15.0+
- Android: minSdk 23, compileSdk 36
- Web: Firebase Hosting
