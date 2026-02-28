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
  late List<String> _videoIds;
  late int _currentIndex;
  late YoutubePlayerController _ytController;
  DateTime? _watchStart;

  @override
  void initState() {
    super.initState();
    _videoIds = widget.videoIds ?? [widget.youtubeId];
    _currentIndex =
        _videoIds.indexOf(widget.youtubeId).clamp(0, _videoIds.length - 1);
    _loadVideo(_currentIndex);
  }

  @override
  void dispose() {
    _ytController.close();
    super.dispose();
  }

  void _loadVideo(int index) {
    final videoId = _videoIds[index];

    _ytController = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: false,
        playsInline: true,
        origin: 'https://www.youtube-nocookie.com',
      ),
    );

    _watchStart = DateTime.now();

    try {
      AnalyticsService().logVideoStarted(videoId);
    } catch (_) {}
  }

  int get _watchDurationSec {
    if (_watchStart == null) return 0;
    return DateTime.now().difference(_watchStart!).inSeconds;
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
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: YoutubePlayer(controller: _ytController),
                  ),
                ),
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
                  icon:
                      const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
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
