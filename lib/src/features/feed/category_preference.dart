import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kCategoryKey = 'selected_category';

final categoryPreferenceProvider =
    StateNotifierProvider<CategoryPreferenceNotifier, AsyncValue<String?>>(
  (ref) => CategoryPreferenceNotifier(),
);

class CategoryPreferenceNotifier extends StateNotifier<AsyncValue<String?>> {
  CategoryPreferenceNotifier() : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = AsyncValue.data(prefs.getString(_kCategoryKey));
  }

  Future<void> save(String categoryId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCategoryKey, categoryId);
    state = AsyncValue.data(categoryId);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kCategoryKey);
    state = const AsyncValue.data(null);
  }
}
