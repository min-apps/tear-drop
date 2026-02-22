import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teardrop/src/data/repositories/saved_link_repository.dart';
import 'package:teardrop/src/data/services/analytics_service.dart';
import 'package:teardrop/src/features/auth/auth_providers.dart';
import 'package:teardrop/src/features/player/tear_feedback_sheet.dart';
import 'package:teardrop/src/theme.dart';
import 'package:teardrop/src/shared/widgets/responsive_center.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({
    super.key,
    required this.youtubeId,
    this.videoIds,
  });

  final String youtubeId;
  final List<String>? videoIds;

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  late PageController _pageController;
  late List<YoutubePlayerController> _controllers;
  late List<String> _videoIds;
  late int _currentIndex;
  DateTime? _watchStart;

  @override
  void initState() {
    super.initState();
    _videoIds = widget.videoIds ?? [widget.youtubeId];
    _currentIndex = _videoIds.indexOf(widget.youtubeId).clamp(0, _videoIds.length - 1);
    _pageController = PageController(initialPage: _currentIndex);

    _controllers = _videoIds.map((_) {
      return YoutubePlayerController(
        params: const YoutubePlayerParams(
          showControls: true,
          mute: false,
          loop: false,
          enableCaption: false,
          strictRelatedVideos: true,
          showFullscreenButton: true,
        ),
      );
    }).toList();

    _controllers[_currentIndex].loadVideoById(videoId: _videoIds[_currentIndex]);
    _watchStart = DateTime.now();

    try {
      AnalyticsService().logVideoStarted(_videoIds[_currentIndex]);
    } catch (_) {}
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.close();
    }
    _pageController.dispose();
    super.dispose();
  }

  int get _watchDurationSec {
    if (_watchStart == null) return 0;
    return DateTime.now().difference(_watchStart!).inSeconds;
  }

  void _onPageChanged(int index) {
    // Log exit for previous video
    try {
      AnalyticsService().logVideoExited(
        _videoIds[_currentIndex],
        _watchDurationSec,
      );
    } catch (_) {}

    setState(() => _currentIndex = index);
    _controllers[index].loadVideoById(videoId: _videoIds[index]);
    _watchStart = DateTime.now();

    try {
      AnalyticsService().logVideoStarted(_videoIds[index]);
    } catch (_) {}
  }

  void _onFeedbackTap() {
    TearFeedbackSheet.show(
      context,
      youtubeId: _videoIds[_currentIndex],
      watchDurationSec: _watchDurationSec,
    );
  }

  Future<void> _onBookmark() async {
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
    final thumbnailUrl =
        'https://img.youtube.com/vi/${_videoIds[_currentIndex]}/hqdefault.jpg';

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(thumbnailUrl),
          SafeArea(
            child: ResponsiveCenter(
              maxWidth: 500,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                onPageChanged: _onPageChanged,
                itemCount: _videoIds.length,
                itemBuilder: (context, index) {
                  return _VideoPlayerTile(controller: _controllers[index]);
                },
              ),
            ),
          ),
          // Top bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    try {
                      AnalyticsService().logVideoExited(
                        _videoIds[_currentIndex],
                        _watchDurationSec,
                      );
                    } catch (_) {}
                    context.pop();
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                IconButton(
                  onPressed: _onBookmark,
                  icon: const Icon(Icons.bookmark_add_outlined, size: 20),
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
              ],
            ),
          ),
          // Feedback button
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: _FeedbackButton(onPressed: _onFeedbackTap),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(String thumbnailUrl) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E293B),
            Color(0xFF1E3A5F),
            Color(0xFF1E40AF),
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            thumbnailUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(color: Colors.black.withValues(alpha: 0.25)),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoPlayerTile extends StatelessWidget {
  const _VideoPlayerTile({required this.controller});
  final YoutubePlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: AspectRatio(
        aspectRatio: 9 / 16,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: YoutubePlayerScaffold(
            controller: controller,
            aspectRatio: 9 / 16,
            builder: (context, player) => player,
          ),
        ),
      ),
    );
  }
}

class _FeedbackButton extends StatelessWidget {
  const _FeedbackButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.water_drop_rounded,
                  color: TearDropTheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                '눈물 평가하기',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TearDropTheme.primary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
