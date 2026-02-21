# 천연눈물 (TearDrop)

**Digital Prescription for Dry Eyes** - 안구건조증을 위한 디지털 처방전

플랫폼: MacBook PC Browser (Chrome/Safari) & Mobile Web

## 실행 방법

```bash
# 프로젝트 초기화 (최초 1회, web 폴더 생성)
flutter create . --platforms=web

# 의존성 설치
flutter pub get

# 웹 런치 (Chrome)
flutter run -d chrome

# 또는 빌드
flutter build web
```

## 프로젝트 구조

```
lib/
├── main.dart                 # 앱 진입점, 테마, GoRouter
├── src/
│   ├── app_router.dart       # 라우팅 설정
│   ├── data/
│   │   └── video_repository.dart   # YouTube Shorts ID 목록 (Mock)
│   ├── screens/
│   │   ├── landing_screen.dart     # 랜딩 (Start Therapy)
│   │   └── player_screen.dart     # 치료 플레이어 (세로 스와이프)
│   └── widgets/
│       └── responsive_center.dart # 데스크톱/모바일 반응형 레이아웃
```

## 비디오 교체

`lib/src/data/video_repository.dart`의 `sadShortsIds`를 실제 슬픈 YouTube Shorts ID로 교체하세요.
