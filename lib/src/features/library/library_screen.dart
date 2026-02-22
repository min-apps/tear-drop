import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teardrop/src/data/services/analytics_service.dart';
import 'package:teardrop/src/features/auth/auth_providers.dart';
import 'package:teardrop/src/features/library/add_link_sheet.dart';
import 'package:teardrop/src/features/library/library_providers.dart';
import 'package:teardrop/src/shared/widgets/video_card.dart';
import 'package:teardrop/src/theme.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linksAsync = ref.watch(savedLinksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('보관함'),
      ),
      body: linksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (links) {
          if (links.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0F5FF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.bookmark_outline_rounded,
                          size: 32,
                          color: TearDropTheme.textSecondary
                              .withValues(alpha: 0.5)),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '저장한 영상이 없습니다',
                      style:
                          Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: TearDropTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'YouTube 링크를 추가하거나\n영상 재생 중 북마크하세요',
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: TearDropTheme.textSecondary,
                                height: 1.4,
                              ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            itemCount: links.length,
            itemBuilder: (context, index) {
              final link = links[index];
              return Dismissible(
                key: Key(link.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: TearDropTheme.errorRed,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete_outline_rounded,
                      color: Colors.white),
                ),
                onDismissed: (_) {
                  final user = ref.read(authStateProvider).value;
                  if (user != null) {
                    ref.read(savedLinkRepositoryProvider).deleteLink(
                          user.uid,
                          link.id,
                        );
                    try {
                      AnalyticsService().logLinkDeleted(link.youtubeId);
                    } catch (_) {}
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: VideoCard(
                    youtubeId: link.youtubeId,
                    title: link.youtubeId,
                    subtitle: link.userNote,
                    trailing: link.tearRating != null
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: TearDropTheme.primary
                                  .withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.water_drop_rounded,
                                    size: 13, color: TearDropTheme.primary),
                                const SizedBox(width: 2),
                                Text('${link.tearRating}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: TearDropTheme.primary,
                                    )),
                              ],
                            ),
                          )
                        : null,
                    onTap: () {
                      context.push('/player/${link.youtubeId}');
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddLinkSheet.show(context),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
