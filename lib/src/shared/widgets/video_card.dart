import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:teardrop/src/theme.dart';

class VideoCard extends StatelessWidget {
  const VideoCard({
    super.key,
    required this.youtubeId,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
    this.onLongPress,
  });

  final String youtubeId;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  String get _thumbnailUrl =>
      'https://img.youtube.com/vi/$youtubeId/hqdefault.jpg';

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Row(
          children: [
            SizedBox(
              width: 120,
              height: 80,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: _thumbnailUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: TearDropTheme.backgroundLight,
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: TearDropTheme.backgroundLight,
                      child: const Center(
                        child: Icon(Icons.videocam_outlined,
                            color: TearDropTheme.textSecondary, size: 24),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: TearDropTheme.textPrimary,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: TearDropTheme.textSecondary,
                              fontSize: 11,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (trailing != null) ...[
              trailing!,
              const SizedBox(width: 12),
            ],
          ],
        ),
      ),
    );
  }
}
