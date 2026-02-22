import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teardrop/src/data/models/tear_reaction.dart';
import 'package:teardrop/src/shared/constants/firestore_paths.dart';
import 'package:uuid/uuid.dart';

class TearReactionRepository {
  TearReactionRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  static const _uuid = Uuid();

  Future<TearReaction> addReaction({
    required String uid,
    required String youtubeId,
    required int tearRating,
    required List<String> emotionTags,
    required int watchDurationSec,
    required bool isReplay,
  }) async {
    final id = _uuid.v4();
    final reaction = TearReaction(
      id: id,
      userId: uid,
      youtubeId: youtubeId,
      tearRating: tearRating,
      emotionTags: emotionTags,
      createdAt: DateTime.now(),
      watchDurationSec: watchDurationSec,
      isReplay: isReplay,
    );
    await _firestore
        .doc(FirestorePaths.reaction(uid, id))
        .set(reaction.toJson());

    // Update video stats aggregate
    await _updateVideoStats(youtubeId, tearRating);

    return reaction;
  }

  Stream<List<TearReaction>> watchReactions(String uid) {
    return _firestore
        .collection(FirestorePaths.reactions(uid))
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => TearReaction.fromJson(doc.data())).toList());
  }

  Future<List<TearReaction>> getRecentReactions(String uid,
      {int limit = 10}) async {
    final snap = await _firestore
        .collection(FirestorePaths.reactions(uid))
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
    return snap.docs
        .map((doc) => TearReaction.fromJson(doc.data()))
        .toList();
  }

  Future<void> _updateVideoStats(String youtubeId, int tearRating) async {
    final statsRef =
        _firestore.doc(FirestorePaths.videoStats(youtubeId));
    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(statsRef);
      if (snap.exists) {
        final data = snap.data()!;
        final totalViews = (data['totalViews'] as int? ?? 0) + 1;
        final oldAvg = (data['averageTearRating'] as num?)?.toDouble() ?? 0.0;
        final newAvg =
            (oldAvg * (totalViews - 1) + tearRating) / totalViews;
        tx.update(statsRef, {
          'totalViews': totalViews,
          'averageTearRating': newAvg,
        });
      } else {
        tx.set(statsRef, {
          'youtubeId': youtubeId,
          'totalViews': 1,
          'averageTearRating': tearRating.toDouble(),
        });
      }
    });
  }
}
