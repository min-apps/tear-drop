import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teardrop/src/app_router.dart';
import 'package:teardrop/src/data/video_repository.dart';
import 'package:teardrop/src/widgets/responsive_center.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

/// State for current video index
final currentVideoIndexProvider = StateProvider<int>((ref) => 0);

/// Therapy Player Screen - Vertical swipe PageView with centered Shorts.
class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({super.key});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  late PageController _pageController;
  late List<YoutubePlayerController> _controllers;
  final List<String> _videoIds = VideoRepository.getSadShortsIds();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _controllers = _videoIds.map((id) {
      return YoutubePlayerController(
        params: YoutubePlayerParams(
          showControls: true,
          mute: false,
          loop: false,
          enableCaption: false,
          strictRelatedVideos: true,
          showFullscreenButton: true,
        ),
      );
    }).toList();
    _controllers.first.loadVideoById(videoId: _videoIds.first);
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.close();
    }
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    ref.read(currentVideoIndexProvider.notifier).state = index;
    _controllers[index].loadVideoById(videoId: _videoIds[index]);
  }

  void _onDidYouCry() {
    debugPrint('눈물 효과 확인 - User reported crying');
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentVideoIndexProvider);
    final currentVideoId = _videoIds[currentIndex];
    final thumbnailUrl =
        VideoRepository.getThumbnailUrlFallback(currentVideoId);

    return Scaffold(
      body: Stack(
        children: [
          // Layer 1: Background (blurred gradient or thumbnail)
          _buildBackground(thumbnailUrl),
          // Layer 2: Centered PageView
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
                  return _VideoPlayerTile(
                    controller: _controllers[index],
                  );
                },
              ),
            ),
          ),
          // Layer 3: Feedback overlay button
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: _FeedbackButton(onPressed: _onDidYouCry),
            ),
          ),
          // Back button
          Positioned(
            top: 16,
            left: 16,
            child: IconButton(
              onPressed: () => context.go(AppRoutes.landing),
              icon: const Icon(Icons.arrow_back_ios_new),
              color: Colors.white,
              style: IconButton.styleFrom(
                backgroundColor: Colors.black26,
              ),
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
            Color(0xFF0D47A1),
            Color(0xFF1565C0),
            Color(0xFF42A5F5),
            Color(0xFFE3F2FD),
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
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1565C0).withOpacity(0.4),
                  Colors.black.withOpacity(0.3),
                ],
              ),
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
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
              child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.favorite, color: Colors.red.shade400, size: 20),
              const SizedBox(width: 8),
              Text(
                'Did you cry? (눈물 효과 확인)',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1565C0),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
