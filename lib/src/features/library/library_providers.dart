import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teardrop/src/data/models/saved_link.dart';
import 'package:teardrop/src/data/repositories/saved_link_repository.dart';
import 'package:teardrop/src/features/auth/auth_providers.dart';

final savedLinkRepositoryProvider = Provider<SavedLinkRepository>((ref) {
  return SavedLinkRepository();
});

final savedLinksProvider = StreamProvider<List<SavedLink>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  final repo = ref.watch(savedLinkRepositoryProvider);
  return repo.watchSavedLinks(user.uid);
});
