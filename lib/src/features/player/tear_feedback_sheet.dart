import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teardrop/src/data/repositories/tear_reaction_repository.dart';
import 'package:teardrop/src/data/repositories/user_repository.dart';
import 'package:teardrop/src/data/services/analytics_service.dart';
import 'package:teardrop/src/data/services/tear_profile_service.dart';
import 'package:teardrop/src/features/auth/auth_providers.dart';
import 'package:teardrop/src/shared/widgets/emotion_tag_chips.dart';
import 'package:teardrop/src/shared/widgets/tear_rating_widget.dart';
import 'package:teardrop/src/theme.dart';

class TearFeedbackSheet extends ConsumerStatefulWidget {
  const TearFeedbackSheet({
    super.key,
    required this.youtubeId,
    required this.watchDurationSec,
    this.isReplay = false,
  });

  final String youtubeId;
  final int watchDurationSec;
  final bool isReplay;

  static Future<void> show(
    BuildContext context, {
    required String youtubeId,
    required int watchDurationSec,
    bool isReplay = false,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => TearFeedbackSheet(
        youtubeId: youtubeId,
        watchDurationSec: watchDurationSec,
        isReplay: isReplay,
      ),
    );
  }

  @override
  ConsumerState<TearFeedbackSheet> createState() => _TearFeedbackSheetState();
}

class _TearFeedbackSheetState extends ConsumerState<TearFeedbackSheet> {
  int _rating = 0;
  List<String> _selectedTags = [];
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '얼마나 울었나요?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TearDropTheme.textPrimary,
                ),
          ),
          const SizedBox(height: 8),
          if (_rating > 0)
            Text(
              TearRatingWidget.labelFor(_rating),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: TearDropTheme.primary,
                  ),
            ),
          const SizedBox(height: 16),
          TearRatingWidget(
            rating: _rating,
            onChanged: (r) => setState(() => _rating = r),
          ),
          const SizedBox(height: 24),
          Text(
            '어떤 감정이었나요?',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          EmotionTagChips(
            selectedTags: _selectedTags,
            onChanged: (tags) => setState(() => _selectedTags = tags),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _submitting ? null : _skip,
                  child: const Text('건너뛰기'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _rating > 0 && !_submitting ? _submit : null,
                  child: _submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('제출하기'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    HapticFeedback.mediumImpact();
    setState(() => _submitting = true);
    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) return;

      final reactionRepo = TearReactionRepository();
      final userRepo = UserRepository();

      // Save reaction
      await reactionRepo.addReaction(
        uid: user.uid,
        youtubeId: widget.youtubeId,
        tearRating: _rating,
        emotionTags: _selectedTags,
        watchDurationSec: widget.watchDurationSec,
        isReplay: widget.isReplay,
      );

      // Update user aggregates
      final currentUser = await userRepo.getUser(user.uid);
      if (currentUser != null) {
        final newAvg = TearProfileService.computeNewAverage(
          currentUser.averageTearRating,
          currentUser.totalReactions,
          _rating,
        );
        await userRepo.updateAfterReaction(
          user.uid,
          tearRating: _rating,
          emotionTags: _selectedTags,
          newAverageRating: newAvg,
          newTotalReactions: currentUser.totalReactions + 1,
        );
      }

      // Log analytics
      try {
        final analytics = AnalyticsService();
        await analytics.logFeedbackSubmitted(
            widget.youtubeId, _rating, _selectedTags);
      } catch (_) {}

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류가 발생했습니다: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _skip() {
    try {
      final analytics = AnalyticsService();
      analytics.logFeedbackSkipped(widget.youtubeId);
    } catch (_) {}
    Navigator.of(context).pop();
  }
}
