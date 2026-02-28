import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teardrop/src/data/models/app_user.dart';
import 'package:teardrop/src/data/preset_data.dart';
import 'package:teardrop/src/data/repositories/user_repository.dart';
import 'package:teardrop/src/data/services/analytics_service.dart';
import 'package:teardrop/src/data/services/tear_profile_service.dart';
import 'package:teardrop/src/features/auth/auth_providers.dart';
import 'package:teardrop/src/features/feed/category_preference.dart';
import 'package:teardrop/src/features/profile/savings_card.dart';
import 'package:teardrop/src/features/profile/tear_profile_card.dart';
import 'package:teardrop/src/theme.dart';

final _userProvider = StreamProvider<AppUser?>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(null);
  return UserRepository().watchUser(user.uid);
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    try {
      AnalyticsService().logProfileViewed();
    } catch (_) {}

    final userAsync = ref.watch(_userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 프로필'),
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (user) {
          if (user == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_outline_rounded,
                      size: 56, color: TearDropTheme.textSecondary.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text(
                    '로그인이 필요합니다',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: TearDropTheme.textSecondary,
                        ),
                  ),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: Column(
              children: [
                TearProfileCard(user: user),
                const SizedBox(height: 12),
                _StatsRow(user: user),
                const SizedBox(height: 12),
                SavingsCard(user: user),
                const SizedBox(height: 12),
                _CategorySetting(),
                if (user.emotionTagCounts.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _EmotionDistribution(tagCounts: user.emotionTagCounts),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.user});
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
          icon: Icons.play_circle_outline_rounded,
          value: '${user.totalVideosWatched}',
          label: '시청',
        ),
        const SizedBox(width: 8),
        _StatCard(
          icon: Icons.water_drop_outlined,
          value: '${user.totalReactions}',
          label: '반응',
        ),
        const SizedBox(width: 8),
        _StatCard(
          icon: Icons.calendar_today_outlined,
          value: _daysSinceJoined(user),
          label: '일차',
        ),
      ].map((w) => w is SizedBox ? w : Expanded(child: w)).toList(),
    );
  }

  String _daysSinceJoined(AppUser user) {
    final days = DateTime.now().difference(user.createdAt).inDays + 1;
    return '$days';
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          children: [
            Icon(icon, color: TearDropTheme.primary, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TearDropTheme.textPrimary,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: TearDropTheme.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmotionDistribution extends StatelessWidget {
  const _EmotionDistribution({required this.tagCounts});
  final Map<String, int> tagCounts;

  @override
  Widget build(BuildContext context) {
    final distribution = TearProfileService.getEmotionDistribution(tagCounts);
    final sorted = distribution.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '감정 분포',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TearDropTheme.textPrimary,
                  ),
            ),
            const SizedBox(height: 16),
            ...sorted.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 36,
                        child: Text(entry.key,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: TearDropTheme.textSecondary,
                                    )),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: entry.value,
                            backgroundColor: TearDropTheme.border,
                            color: TearDropTheme.primary,
                            minHeight: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 36,
                        child: Text(
                          '${(entry.value * 100).toInt()}%',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: TearDropTheme.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _CategorySetting extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catPref = ref.watch(categoryPreferenceProvider);
    final savedId = catPref.valueOrNull;

    final collection = savedId != null
        ? PresetData.collections
            .where((c) => c.id == savedId)
            .firstOrNull
        : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '영상 카테고리',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TearDropTheme.textPrimary,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: PresetData.collections.map((c) {
                final isSelected = c.id == savedId;
                return ChoiceChip(
                  label: Text('${c.emoji} ${c.title}'),
                  selected: isSelected,
                  onSelected: (_) {
                    ref
                        .read(categoryPreferenceProvider.notifier)
                        .save(c.id);
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '${c.emoji} ${c.title} 카테고리로 변경했어요'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  selectedColor:
                      TearDropTheme.primary.withValues(alpha: 0.15),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? TearDropTheme.primary
                        : TearDropTheme.textSecondary,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                );
              }).toList(),
            ),
            if (collection != null) ...[
              const SizedBox(height: 8),
              Text(
                collection.subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: TearDropTheme.textSecondary,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
