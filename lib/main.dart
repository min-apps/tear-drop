import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teardrop/firebase_options.dart';
import 'package:teardrop/src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase init failed (using placeholder config): $e');
  }
  runApp(
    const ProviderScope(
      child: TearDropApp(),
    ),
  );
}
