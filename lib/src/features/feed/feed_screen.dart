import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teardrop/src/data/preset_data.dart';
import 'package:teardrop/src/data/services/analytics_service.dart';
import 'package:teardrop/src/features/feed/category_preference.dart';
import 'package:teardrop/src/shared/widgets/tear_rating_widget.dart';
import 'package:teardrop/src/theme.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  List<String> _videoIds = [];
  String? _selectedCategory;
  int _currentVideoIndex = 0;
  DateTime? _watchStart;
  bool _feedStarted = false;
  final Set<String> _savedIds = {};
  final Map<String, int> _ratings = {};

  final PageController _pageController = PageController();
  YoutubePlayerController? _ytController;

  /// PageView layout: [Video 0] [Feedback 0] [Video 1] [Feedback 1] ...
  int get _totalPages => _videoIds.length * 2;
  int _videoIndexFromPage(int page) => page ~/ 2;
  bool _isVideoPage(int page) => page.isEven;

  @override
  void dispose() {
    _pageController.dispose();
    _ytController?.close();
    super.dispose();
  }

  void _startFeed(String categoryId, {bool save = true}) {
    HapticFeedback.mediumImpact();
    if (save) {
      ref.read(categoryPreferenceProvider.notifier).save(categoryId);
    }
    setState(() {
      _selectedCategory = categoryId;
      _videoIds = PresetData.getShortVideoIds(categoryId: categoryId);
      _currentVideoIndex = 0;
      _feedStarted = true;
    });
    _loadVideo(0);

    try {
      AnalyticsService().logPresetOpened(categoryId);
    } catch (_) {}
  }

  void _ensureController() {
    if (_ytController != null) return;
    _ytController = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: false,
        showFullscreenButton: false,
        playsInline: true,
        loop: true,
        origin: 'https://www.youtube-nocookie.com',
      ),
    );
  }

  void _loadVideo(int videoIndex) {
    if (videoIndex < 0 || videoIndex >= _videoIds.length) return;

    final videoId = _videoIds[videoIndex];

    // Reuse the same controller — don't close & recreate.
    // Creating new WKWebViews repeatedly fails to load the YouTube API.
    _ensureController();
    _ytController!.loadVideoById(videoId: videoId);

    // Retry: if not playing after 4s, try playVideo() explicitly
    Future.delayed(const Duration(seconds: 4), () {
      if (_ytController == null || _currentVideoIndex != videoIndex) return;
      if (_ytController!.value.playerState != PlayerState.playing) {
        _ytController!.playVideo();
      }
    });

    // Retry: if still not playing after 8s, re-load the video
    Future.delayed(const Duration(seconds: 8), () {
      if (_ytController == null || _currentVideoIndex != videoIndex) return;
      if (_ytController!.value.playerState != PlayerState.playing) {
        _ytController!.loadVideoById(videoId: videoId);
      }
    });

    _watchStart = DateTime.now();

    try {
      AnalyticsService().logVideoStarted(videoId);
    } catch (_) {}
  }

  int get _watchDurationSec {
    if (_watchStart == null) return 0;
    return DateTime.now().difference(_watchStart!).inSeconds;
  }

  void _onPageChanged(int pageIndex) {
    final videoIndex = _videoIndexFromPage(pageIndex);
    final isVideo = _isVideoPage(pageIndex);

    if (isVideo && videoIndex != _currentVideoIndex) {
      try {
        AnalyticsService().logVideoExited(
          _videoIds[_currentVideoIndex],
          _watchDurationSec,
        );
      } catch (_) {}

      setState(() => _currentVideoIndex = videoIndex);
      _loadVideo(videoIndex);
    } else if (!isVideo) {
      setState(() {});
    }
  }

  void _onRatingSelected(String videoId, int rating) {
    HapticFeedback.mediumImpact();
    setState(() => _ratings[videoId] = rating);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${TearRatingWidget.labelFor(rating)} — 기록했어요!'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF1E293B),
      ),
    );

    try {
      AnalyticsService().logFeedbackSubmitted(
        videoId,
        rating,
        _selectedCategory != null ? [_selectedCategory!] : [],
      );
    } catch (_) {}
  }

  void _onBookmark(String videoId) {
    HapticFeedback.lightImpact();
    final alreadySaved = _savedIds.contains(videoId);

    setState(() {
      if (alreadySaved) {
        _savedIds.remove(videoId);
      } else {
        _savedIds.add(videoId);
      }
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(alreadySaved ? '보관함에서 삭제했습니다' : '보관함에 저장했습니다'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF1E293B),
      ),
    );

    try {
      AnalyticsService().logLinkSaved(videoId);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final catPref = ref.watch(categoryPreferenceProvider);

    if (!_feedStarted) {
      return catPref.when(
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (_, __) => _CategoryPicker(onSelect: _startFeed),
        data: (saved) {
          if (saved != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!_feedStarted && mounted) {
                _startFeed(saved, save: false);
              }
            });
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return _CategoryPicker(onSelect: _startFeed);
        },
      );
    }
    return _buildFeed();
  }

  Widget _buildFeed() {
    if (_videoIds.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('영상을 불러올 수 없습니다')),
      );
    }

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: _onPageChanged,
        itemCount: _totalPages,
        itemBuilder: (context, pageIndex) {
          final videoIndex = _videoIndexFromPage(pageIndex);
          final videoId = _videoIds[videoIndex];

          if (_isVideoPage(pageIndex)) {
            if (videoIndex == _currentVideoIndex &&
                _ytController != null) {
              return _VideoPage(
                controller: _ytController!,
                videoId: videoId,
              );
            }
            return _ThumbnailPage(videoId: videoId);
          } else {
            return _FeedbackPage(
              videoId: videoId,
              rating: _ratings[videoId],
              isSaved: _savedIds.contains(videoId),
              onRatingSelected: (r) => _onRatingSelected(videoId, r),
              onBookmark: () => _onBookmark(videoId),
              isLast: videoIndex == _videoIds.length - 1,
            );
          }
        },
      ),
    );
  }
}

// ============================================================
// Category Picker
// ============================================================
class _CategoryPicker extends StatelessWidget {
  const _CategoryPicker({required this.onSelect});
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final collections = PresetData.collections;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.water_drop_rounded,
                  size: 36, color: TearDropTheme.secondary),
              const SizedBox(height: 16),
              Text(
                '어떤 감정으로\n눈물을 흘려볼까요?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '카테고리를 선택하면 바로 영상이 재생됩니다',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white54,
                    ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    itemCount: collections.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.6,
                    ),
                    itemBuilder: (context, index) {
                      final c = collections[index];
                      final shortCount = PresetData.getShortVideoIds(
                              categoryId: c.id)
                          .length;
                      return _CategoryCard(
                        emoji: c.emoji,
                        title: c.title,
                        subtitle: c.subtitle,
                        videoCount: shortCount,
                        onTap: () => onSelect(c.id),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: bottomPad + 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.videoCount,
    required this.onTap,
  });
  final String emoji;
  final String title;
  final String subtitle;
  final int videoCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 24)),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$videoCount편',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white38, fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Video Page — full-screen YouTube player, NO overlays
// ============================================================

class _VideoPage extends StatelessWidget {
  const _VideoPage({
    required this.controller,
    required this.videoId,
  });
  final YoutubePlayerController controller;
  final String videoId;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: YoutubePlayer(controller: controller),
    );
  }
}

class _ThumbnailPage extends StatelessWidget {
  const _ThumbnailPage({required this.videoId});
  final String videoId;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg',
            fit: BoxFit.cover,
            errorWidget: (_, __, ___) => CachedNetworkImage(
              imageUrl: 'https://img.youtube.com/vi/$videoId/hqdefault.jpg',
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
          Container(color: Colors.black.withValues(alpha: 0.3)),
          const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Feedback Page — between videos
// ============================================================

class _FeedbackPage extends StatelessWidget {
  const _FeedbackPage({
    required this.videoId,
    required this.rating,
    required this.isSaved,
    required this.onRatingSelected,
    required this.onBookmark,
    required this.isLast,
  });
  final String videoId;
  final int? rating;
  final bool isSaved;
  final ValueChanged<int> onRatingSelected;
  final VoidCallback onBookmark;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final meta = PresetData.getVideoMeta(videoId);
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              if (meta != null) ...[
                Text(
                  meta.title,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  meta.channel,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 13,
                  ),
                ),
              ],

              const SizedBox(height: 32),

              const Text(
                '눈물이 났나요?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '탭 한 번이면 끝!',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),

              TearRatingWidget(
                rating: rating,
                onChanged: onRatingSelected,
              ),

              const SizedBox(height: 24),

              GestureDetector(
                onTap: onBookmark,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withValues(alpha: isSaved ? 0.15 : 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white
                          .withValues(alpha: isSaved ? 0.3 : 0.1),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSaved
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_add_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isSaved ? '보관함에 저장됨' : '보관함에 저장',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 2),

              if (!isLast)
                Padding(
                  padding: EdgeInsets.only(bottom: bottomPad + 16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.keyboard_arrow_up_rounded,
                        color: Colors.white.withValues(alpha: 0.3),
                        size: 28,
                      ),
                      Text(
                        '위로 스와이프하면 다음 영상',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.3),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Padding(
                  padding: EdgeInsets.only(bottom: bottomPad + 16),
                  child: Text(
                    '마지막 영상이에요',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3),
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
