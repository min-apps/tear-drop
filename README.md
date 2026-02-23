# Teary (천연눈물)

> **Published as "Teary"** | Internal codebase name: TearDrop

**Digital Prescription for Dry Eyes** - 안구건조증을 위한 디지털 처방전

감동적인 YouTube 영상으로 자연스러운 눈물을 유도하는 앱입니다.
TikTok/YouTube Shorts 스타일로 세로 스와이프하며 짧은 감동 영상(3분 이하)을 바로 시청할 수 있습니다.

## Features

- **세로 스와이프 피드** — TikTok/Shorts 스타일 영상 피드, 앱 진입 즉시 자동 재생
- **카테고리 필터** — 감동, 이별, 동물, 가족, 희생, 음악, 영화 7개 테마
- **3분 이하 숏폼 영상** — 짧은 영상 위주로 큐레이션 (Shorts 형태 선호)
- **눈물 평가 시스템** — 4단계 행동 앵커 강도 척도 (원탭 제출)
- **눈물 프로필** — 나만의 울보 유형 분석 (감동형, 가족형 등)
- **인공눈물 절약 리포트** — 절약한 인공눈물 비용 프로젝션
- **영상 보관함** — YouTube 링크 북마크 및 직접 추가

## Platforms

- iOS (15.0+)
- Android (API 23+)
- Web — [min-apps.github.io/tear-drop](https://min-apps.github.io/tear-drop/)

## Setup

### Prerequisites

- Flutter SDK (stable channel)
- CocoaPods (`brew install cocoapods`)
- Firebase CLI (`npm install -g firebase-tools`)

### Firebase

Firebase project: `teary-app`

- Firestore: asia-northeast3 (Seoul)
- Auth: Anonymous, Google, Email
- Hosting: `teary-app.web.app`

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
    │   ├── feed/                      # TikTok-style vertical video feed
    │   ├── home/                      # Bottom nav shell
    │   ├── player/                    # Single video player + tear feedback
    │   ├── library/                   # Saved links + add link sheet
    │   ├── profile/                   # Tear profile + stats + savings
    │   └── onboarding/                # Landing screen
    ├── data/
    │   ├── models/                    # freezed models (AppUser, Video, etc.)
    │   ├── repositories/              # Firestore CRUD
    │   ├── services/                  # Analytics, TearProfile, TearSavings
    │   └── preset_data.dart           # Hardcoded video collections (3min filter)
    └── shared/
        ├── widgets/                   # Reusable widgets
        ├── constants/                 # Firestore paths, analytics events
        └── extensions/                # YouTube URL parser
```

### Key Decisions

| Decision | Choice | Why |
|----------|--------|-----|
| Video UX | TikTok-style vertical swipe | Immediate engagement, mobile-native |
| Video length | ≤ 3 minutes only | Short-form for quick emotional impact |
| State management | Riverpod (manual, no codegen) | Simple for solo dev |
| Models | freezed + json_serializable | Firestore serialization |
| Auth | Anonymous first | Zero friction |
| Navigation | GoRouter ShellRoute | Full-screen feed + tabbed sections |

## Deployment

### Web (GitHub Pages)
Automatic via GitHub Actions on push to `main`.
```
https://min-apps.github.io/tear-drop/
```

### iOS (TestFlight)
```bash
cd ios && fastlane beta
```

### Android (Play Store Internal)
```bash
cd android && fastlane beta
```

### CI/CD
GitHub Actions on push to `main`: analyze → test → build web → deploy to GitHub Pages.

## Tear Feedback Scale Design

### 4-Point Behavioral Anchor Tear Intensity Scale

사용자 부담을 최소화하면서 연구에 활용 가능한 데이터를 수집하기 위해 설계한 눈물 반응 측정 척도.

| Value | Label | Behavioral Anchor |
|-------|-------|-------------------|
| 0 | 안 남 | 눈물 반응 없음 (No tears) |
| 1 | 촉촉 | 눈에 수분감 (Eyes moistened) |
| 2 | 글썽 | 눈물이 고임 (Tears welled up) |
| 3 | 울었다 | 눈물이 흐름 (Tears flowed) |

### Design Rationale

- **Behavioral anchoring**: 각 단계가 관찰 가능한 생리적 반응에 대응. 주관적 감정이 아닌 신체 반응 강도를 측정하므로 리커트 척도(동의/비동의)보다 적합.
- **No neutral midpoint**: 눈물 반응은 점진적 강도를 가지므로 중립점이 불필요. Wong-Baker FACES Pain Scale과 동일한 설계 논리.
- **One-tap interaction**: 바텀시트에서 4개 옵션 중 하나를 탭하면 즉시 제출 + 닫힘. 별도 제출/건너뛰기 버튼 없음.
- **Category auto-tagging**: 감정 태그를 사용자에게 묻지 않고, 현재 시청 중인 카테고리(감동/이별/동물 등)를 자동으로 기록. 중복 수집 제거.

### Implicit Behavioral Signals (추가 수집, 사용자 부담 없음)

| Signal | Description | Collection |
|--------|-------------|------------|
| `watchDurationSec` | 영상 시청 시간 | 자동 |
| Completion rate | 영상 완주 여부 | watchDuration vs videoDuration |
| Skip detection | 5초 미만 시청 후 넘김 | watchDuration < 5s |
| Replay detection | 같은 영상 재시청 | `isReplay` flag |
| Feedback engagement | 평가 제출 vs 스킵 비율 | Analytics event |
