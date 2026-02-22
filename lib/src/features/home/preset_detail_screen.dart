import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:teardrop/src/data/preset_data.dart';
import 'package:teardrop/src/data/services/analytics_service.dart';
import 'package:teardrop/src/shared/widgets/video_card.dart';
import 'package:teardrop/src/theme.dart';

class PresetDetailScreen extends StatelessWidget {
  const PresetDetailScreen({super.key, required this.presetId});
  final String presetId;

  @override
  Widget build(BuildContext context) {
    final collection = PresetData.getById(presetId);
    if (collection == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('컬렉션을 찾을 수 없습니다')),
      );
    }

    try {
      AnalyticsService().logPresetOpened(presetId);
    } catch (_) {}

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(collection.emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(collection.title),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: TearDropTheme.backgroundLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        collection.subtitle,
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: TearDropTheme.textSecondary,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${collection.videoIds.length}개 영상',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: TearDropTheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ],
                  ),
                ),
                FilledButton.tonal(
                  onPressed: () {
                    if (collection.videoIds.isNotEmpty) {
                      context.push(
                        '/player/${collection.videoIds.first}',
                        extra: collection.videoIds,
                      );
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: TearDropTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_arrow_rounded, size: 18),
                      SizedBox(width: 4),
                      Text('전체 재생'),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms),
          // Video list
          ...List.generate(collection.videoIds.length, (index) {
            final videoId = collection.videoIds[index];
            final meta = PresetData.getVideoMeta(videoId);
            final videoTitle = meta?.title ?? '${collection.title} #${index + 1}';
            final videoSubtitle = meta?.channel ?? videoId;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: VideoCard(
                youtubeId: videoId,
                title: videoTitle,
                subtitle: videoSubtitle,
                onTap: () {
                  context.push(
                    '/player/$videoId',
                    extra: collection.videoIds,
                  );
                },
              ),
            )
                .animate()
                .fadeIn(delay: (80 + index * 60).ms, duration: 350.ms);
          }),
        ],
      ),
    );
  }
}
