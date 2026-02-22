import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:teardrop/src/data/preset_data.dart';
import 'package:teardrop/src/data/models/preset_collection.dart';
import 'package:teardrop/src/theme.dart';

class PresetTab extends StatelessWidget {
  const PresetTab({super.key});

  @override
  Widget build(BuildContext context) {
    final collections = PresetData.collections;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.water_drop_rounded,
                color: TearDropTheme.primary, size: 22),
            const SizedBox(width: 8),
            Text(
              'Teary',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TearDropTheme.textPrimary,
                    letterSpacing: -0.5,
                  ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              '오늘은 어떤 감정으로\n눈물을 흘려볼까요?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TearDropTheme.textPrimary,
                    height: 1.35,
                  ),
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
          ...List.generate(collections.length, (index) {
            final collection = collections[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PresetCard(collection: collection),
            )
                .animate()
                .fadeIn(delay: (100 + index * 80).ms, duration: 400.ms)
                .slideY(begin: 0.05);
          }),
        ],
      ),
    );
  }
}

class _PresetCard extends StatelessWidget {
  const _PresetCard({required this.collection});
  final PresetCollection collection;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => context.go('/home/presets/${collection.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: TearDropTheme.backgroundLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  collection.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      collection.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: TearDropTheme.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      collection.subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: TearDropTheme.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: TearDropTheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${collection.videoIds.length}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: TearDropTheme.primary,
                      ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right_rounded,
                  color: TearDropTheme.textSecondary.withValues(alpha: 0.5),
                  size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
