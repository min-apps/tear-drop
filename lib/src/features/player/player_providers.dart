import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentVideoIdProvider = StateProvider<String?>((ref) => null);
final watchStartTimeProvider = StateProvider<DateTime?>((ref) => null);
