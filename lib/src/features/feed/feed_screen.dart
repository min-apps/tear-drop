import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teardrop/src/data/preset_data.dart';
import 'package:teardrop/src/data/repositories/saved_link_repository.dart';
import 'package:teardrop/src/data/services/analytics_service.dart';
import 'package:teardrop/src/features/auth/auth_providers.dart';
import 'package:teardrop/src/features/player/tear_feedback_sheet.dart';
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
  int _currentIndex = 0;
  DateTime? _watchStart;
  bool _feedStarted = false;

  YoutubePlayerController? _activeController;

  @override
  void dispose() {
    _activeController?.close();
    super.dispose();
  }

  void _startFeed(String categoryId) {
    HapticFeedback.mediumImpact();
    setState(() {
      _selectedCategory = categoryId;
      _videoIds = PresetData.getShortVideoIds(categoryId: categoryId);
      _currentIndex = 0;
      _feedStarted = true;
    });
    _loadVideo(0);

    try {
      AnalyticsService().logPresetOpened(categoryId);
    } catch (_) {}
  }

  void _switchCategory(String? categoryId) {
    if (categoryId == _selectedCategory) return;
    _activeController?.close();
    setState(() {
      _selectedCategory = categoryId;
      _videoIds = PresetData.getShortVideoIds(categoryId: categoryId);
      _currentIndex = 0;
    });
    _loadVideo(0);
  }

  void _loadVideo(int index) {
    if (index < 0 || index >= _videoIds.length) return;

    _activeController?.close();
    _activeController = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: false,
        mute: false,
        loop: true,
        enableCaption: false,
        strictRelatedVideos: true,
        showFullscreenButton: false,
      ),
    );
    _activeController!.loadVideoById(videoId: _videoIds[index]);
    _watchStart = DateTime.now();

    try {
      AnalyticsService().logVideoStarted(_videoIds[index]);
    } catch (_) {}
  }

  int get _watchDurationSec {
    if (_watchStart == null) return 0;
    return DateTime.now().difference(_watchStart!).inSeconds;
  }

  void _onPageChanged(int index) {
    try {
      AnalyticsService().logVideoExited(
        _videoIds[_currentIndex],
        _watchDurationSec,
      );
    } catch (_) {}

    setState(() => _currentIndex = index);
    _loadVideo(index);
  }

  void _handleSwipe(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity < -300 && _currentIndex < _videoIds.length - 1) {
      HapticFeedback.lightImpact();
      _onPageChanged(_currentIndex + 1);
    } else if (velocity > 300 && _currentIndex > 0) {
      HapticFeedback.lightImpact();
      _onPageChanged(_currentIndex - 1);
    }
  }

  void _onFeedbackTap() {
    HapticFeedback.mediumImpact();
    TearFeedbackSheet.show(
      context,
      youtubeId: _videoIds[_currentIndex],
      watchDurationSec: _watchDurationSec,
    );
  }

  Future<void> _onBookmark() async {
    HapticFeedback.lightImpact();
    final user = ref.read(authStateProvider).value;
    if (user == null) return;
    try {
      await SavedLinkRepository().addLink(
        uid: user.uid,
        youtubeId: _videoIds[_currentIndex],
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('보관함에 저장했습니다'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      try {
        AnalyticsService().logLinkSaved(_videoIds[_currentIndex]);
      } catch (_) {}
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_feedStarted) {
      return _CategoryPicker(onSelect: _startFeed);
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
      body: Stack(
        children: [
          // Video player (touch-disabled so Flutter handles all gestures)
          if (_activeController != null)
            Positioned.fill(
              child: _ActiveVideoPage(
                controller: _activeController!,
                videoId: _videoIds[_currentIndex],
              ),
            )
          else
            Positioned.fill(
              child: _ThumbnailPage(videoId: _videoIds[_currentIndex]),
            ),

          // Full-screen swipe gesture detector
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragEnd: _handleSwipe,
              child: const SizedBox.expand(),
            ),
          ),

          // Category chips (top) — above gesture layer, tappable
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 0,
            right: 0,
            child: _CategoryChips(
              selected: _selectedCategory,
              onChanged: _switchCategory,
            ),
          ),

          // Side action buttons (right) — above gesture layer, tappable
          Positioned(
            right: 12,
            bottom: MediaQuery.of(context).padding.bottom + 80,
            child: _SideActions(
              onBookmark: _onBookmark,
              onFeedback: _onFeedbackTap,
            ),
          ),

          // Video info (bottom) — display only, pass through touches
          Positioned(
            left: 16,
            right: 72,
            bottom: MediaQuery.of(context).padding.bottom + 80,
            child: IgnorePointer(
              child: _VideoInfo(videoId: _videoIds[_currentIndex]),
            ),
          ),

          // Video position indicator
          Positioned(
            left: 16,
            bottom: MediaQuery.of(context).padding.bottom + 60,
            child: IgnorePointer(
              child: Text(
                '${_currentIndex + 1} / ${_videoIds.length}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Category Picker — shown before feed starts
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
// Feed components
// ============================================================

class _ActiveVideoPage extends StatelessWidget {
  const _ActiveVideoPage({
    required this.controller,
    required this.videoId,
  });
  final YoutubePlayerController controller;
  final String videoId;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: IgnorePointer(
            child: YoutubePlayerScaffold(
              controller: controller,
              aspectRatio: 9 / 16,
              builder: (context, player) => player,
            ),
          ),
        ),
      ),
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

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.selected,
    required this.onChanged,
  });
  final String? selected;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final categories =
        PresetData.collections.map((c) => (c.id, '${c.emoji} ${c.title}'));

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final (id, label) = categories.elementAt(index);
          final isSelected = id == selected;
          return GestureDetector(
            onTap: () => onChanged(id),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.black : Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SideActions extends StatelessWidget {
  const _SideActions({
    required this.onBookmark,
    required this.onFeedback,
  });
  final VoidCallback onBookmark;
  final VoidCallback onFeedback;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ActionButton(
          icon: Icons.water_drop_rounded,
          label: '평가',
          onTap: onFeedback,
        ),
        const SizedBox(height: 20),
        _ActionButton(
          icon: Icons.bookmark_add_outlined,
          label: '저장',
          onTap: onBookmark,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoInfo extends StatelessWidget {
  const _VideoInfo({required this.videoId});
  final String videoId;

  @override
  Widget build(BuildContext context) {
    final meta = PresetData.getVideoMeta(videoId);
    if (meta == null) return const SizedBox.shrink();

    final durationMin = meta.durationSeconds ~/ 60;
    final durationSec = meta.durationSeconds % 60;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          meta.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              meta.channel,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$durationMin:${durationSec.toString().padLeft(2, '0')}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
