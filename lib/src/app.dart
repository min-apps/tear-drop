import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teardrop/src/app_router.dart';
import 'package:teardrop/src/theme.dart';

class TearDropApp extends ConsumerWidget {
  const TearDropApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: '천연눈물 (TearDrop)',
      debugShowCheckedModeBanner: false,
      theme: TearDropTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
