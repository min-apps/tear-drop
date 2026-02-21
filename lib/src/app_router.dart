import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teardrop/src/screens/landing_screen.dart';
import 'package:teardrop/src/screens/player_screen.dart';

/// Route paths
class AppRoutes {
  static const String landing = '/';
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
      GoRoute(
        path: AppRoutes.player,
        builder: (context, state) => const PlayerScreen(),
      ),
    ],
  );
}
