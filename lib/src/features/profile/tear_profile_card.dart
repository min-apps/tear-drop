import 'package:flutter/material.dart';
import 'package:teardrop/src/data/models/app_user.dart';
import 'package:teardrop/src/data/services/tear_profile_service.dart';
import 'package:teardrop/src/theme.dart';

class TearProfileCard extends StatelessWidget {
  const TearProfileCard({super.key, required this.user});
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final tearType = TearProfileService.deriveTearType(user);
    final tearEmoji = TearProfileService.deriveTearEmoji(user);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
        child: Column(
          children: [
            Text(
              tearEmoji,
              style: const TextStyle(fontSize: 52),
            ),
            const SizedBox(height: 12),
            Text(
              tearType,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TearDropTheme.textPrimary,
                  ),
            ),
            const SizedBox(height: 8),
            if (user.totalReactions > 0)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: TearDropTheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.water_drop_rounded,
                        size: 16, color: TearDropTheme.primary),
                    const SizedBox(width: 4),
                    Text(
                      '평균 ${user.averageTearRating.toStringAsFixed(1)}',
                      style:
                          Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: TearDropTheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
