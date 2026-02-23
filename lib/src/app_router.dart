import 'package:go_router/go_router.dart';
import 'package:teardrop/src/features/feed/feed_screen.dart';
import 'package:teardrop/src/features/home/home_screen.dart';
import 'package:teardrop/src/features/library/library_screen.dart';
import 'package:teardrop/src/features/onboarding/landing_screen.dart';
import 'package:teardrop/src/features/player/player_screen.dart';
import 'package:teardrop/src/features/profile/profile_screen.dart';

class AppRoutes {
  static const String landing = '/';
  static const String home = '/home';
  static const String feed = '/home/feed';
  static const String library = '/home/library';
  static const String profile = '/home/profile';
  static const String player = '/player';
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.landing,
    routes: [
      GoRoute(
        path: AppRoutes.landing,
        builder: (context, state) => const LandingScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => HomeScreen(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.feed,
            builder: (context, state) => const FeedScreen(),
          ),
          GoRoute(
            path: AppRoutes.library,
            builder: (context, state) => const LibraryScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      // Redirect /home to /home/feed
      GoRoute(
        path: AppRoutes.home,
        redirect: (context, state) => AppRoutes.feed,
      ),
      GoRoute(
        path: '${AppRoutes.player}/:youtubeId',
        builder: (context, state) {
          final youtubeId = state.pathParameters['youtubeId']!;
          final videoIds = state.extra as List<String>?;
          return PlayerScreen(
            youtubeId: youtubeId,
            videoIds: videoIds,
          );
        },
      ),
    ],
  );
}
