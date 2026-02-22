# Teary (천연눈물)

> **Published as "Teary"** | Internal codebase name: TearDrop

**Digital Prescription for Dry Eyes** - 안구건조증을 위한 디지털 처방전

감동적인 YouTube 영상으로 자연스러운 눈물을 유도하는 앱입니다.

## Platforms

- iOS (15.0+)
- Android (API 23+)
- Web (Firebase Hosting)

## Setup

### Prerequisites

- Flutter SDK (stable channel)
- CocoaPods (`brew install cocoapods`)
- Firebase CLI (`npm install -g firebase-tools`)
- FlutterFire CLI (`dart pub global activate flutterfire_cli`)

### Firebase

Firebase project: `teary-app` (tangza@gmail.com)

- Firestore: asia-northeast3 (Seoul)
- Auth: Anonymous, Google, Email
- Hosting: `teary-app.web.app`

```bash
# Firebase config is already generated in:
# - lib/firebase_options.dart
# - android/app/google-services.json
# - ios/Runner/GoogleService-Info.plist

# Deploy Firestore rules
firebase deploy --only firestore:rules --project teary-app

# Deploy web
flutter build web --release && firebase deploy --only hosting --project teary-app
```

### Development

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d <device>
```

### Testing

```bash
flutter analyze    # Static analysis
flutter test       # Unit + widget tests
```

## Architecture

```
lib/
├── main.dart                          # Entry point + Firebase init
├── firebase_options.dart              # Firebase config (generated)
└── src/
    ├── app.dart                       # TearDropApp widget
    ├── app_router.dart                # GoRouter with ShellRoute
    ├── theme.dart                     # Theme constants
    ├── features/
    │   ├── auth/                      # Anonymous auth service + providers
    │   ├── home/                      # Bottom nav shell, preset tab/detail
    │   ├── player/                    # Video player + tear feedback sheet
    │   ├── library/                   # Saved links + add link sheet
    │   ├── profile/                   # Tear profile + stats
    │   └── onboarding/                # Landing screen
    ├── data/
    │   ├── models/                    # freezed models (AppUser, Video, etc.)
    │   ├── repositories/              # Firestore CRUD
    │   ├── services/                  # Analytics, TearProfile
    │   └── preset_data.dart           # Hardcoded preset collections
    └── shared/
        ├── widgets/                   # Reusable widgets
        ├── constants/                 # Firestore paths, analytics events, emotion tags
        └── extensions/                # YouTube URL parser
```

### Key Decisions

| Decision | Choice | Why |
|----------|--------|-----|
| State management | Riverpod (manual, no codegen) | Simple for solo dev |
| Models | freezed + json_serializable | Firestore serialization |
| Auth | Anonymous first | Zero friction |
| Presets | Hardcoded in app | Simplest start |
| Navigation | GoRouter ShellRoute | Independent tab stacks |

## Deployment

### iOS (TestFlight)
```bash
cd ios && fastlane beta
```

### Android (Play Store Internal)
```bash
cd android && fastlane beta
```

### Web (Firebase Hosting)
```bash
flutter build web --release
firebase deploy --only hosting --project teary-app
```

### CI/CD
GitHub Actions on push to `main`: analyze → test → build web → deploy.
