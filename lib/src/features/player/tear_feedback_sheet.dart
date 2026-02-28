import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teardrop/src/data/repositories/tear_reaction_repository.dart';
import 'package:teardrop/src/data/repositories/user_repository.dart';
import 'package:teardrop/src/data/services/analytics_service.dart';
import 'package:teardrop/src/data/services/tear_profile_service.dart';
import 'package:teardrop/src/features/auth/auth_providers.dart';
import 'package:teardrop/src/shared/widgets/tear_rating_widget.dart';

class TearFeedbackSheet extends ConsumerStatefulWidget {
  const TearFeedbackSheet({
    super.key,
    required this.youtubeId,
    required this.watchDurationSec,
    this.categoryId,
    this.isReplay = false,
  });

  final String youtubeId;
  final int watchDurationSec;
  final String? categoryId;
  final bool isReplay;

  static Future<void> show(
    BuildContext context, {
    required String youtubeId,
    required int watchDurationSec,
    String? categoryId,
    bool isReplay = false,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => TearFeedbackSheet(
        youtubeId: youtubeId,
        watchDurationSec: watchDurationSec,
        categoryId: categoryId,
        isReplay: isReplay,
      ),
    );
  }

  @override
  ConsumerState<TearFeedbackSheet> createState() => _TearFeedbackSheetState();
}

class _TearFeedbackSheetState extends ConsumerState<TearFeedbackSheet> {
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '눈물이 났나요?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
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
          if (_submitting)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: CircularProgressIndicator(color: Colors.white),
            )
          else
            TearRatingWidget(
              rating: null,
              onChanged: _submit,
            ),
          SizedBox(height: 24 + MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Future<void> _submit(int tearRating) async {
    HapticFeedback.mediumImpact();
    setState(() => _submitting = true);
    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) return;

      // Auto-derive emotion tag from category context
      final autoTags = <String>[];
      if (widget.categoryId != null) {
        autoTags.add(widget.categoryId!);
      }

      final reactionRepo = TearReactionRepository();
      final userRepo = UserRepository();

      await reactionRepo.addReaction(
        uid: user.uid,
        youtubeId: widget.youtubeId,
        tearRating: tearRating,
        emotionTags: autoTags,
        watchDurationSec: widget.watchDurationSec,
        isReplay: widget.isReplay,
      );

      final currentUser = await userRepo.getUser(user.uid);
      if (currentUser != null) {
        final newAvg = TearProfileService.computeNewAverage(
          currentUser.averageTearRating,
          currentUser.totalReactions,
          tearRating,
        );
        await userRepo.updateAfterReaction(
          user.uid,
          tearRating: tearRating,
          emotionTags: autoTags,
          newAverageRating: newAvg,
          newTotalReactions: currentUser.totalReactions + 1,
        );
      }

      try {
        AnalyticsService().logFeedbackSubmitted(
          widget.youtubeId,
          tearRating,
          autoTags,
        );
      } catch (_) {}

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${TearRatingWidget.labelFor(tearRating)} — 기록했어요!'),
            duration: const Duration(seconds: 2),
            backgroundColor: const Color(0xFF1E293B),
          ),
        );
      }
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
}
