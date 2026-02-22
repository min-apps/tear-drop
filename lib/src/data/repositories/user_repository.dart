import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teardrop/src/data/models/app_user.dart';
import 'package:teardrop/src/shared/constants/firestore_paths.dart';

class UserRepository {
  UserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<AppUser?> getUser(String uid) async {
    final doc = await _firestore.doc(FirestorePaths.user(uid)).get();
    if (!doc.exists) return null;
    return AppUser.fromJson(doc.data()!);
  }

  Stream<AppUser?> watchUser(String uid) {
    return _firestore.doc(FirestorePaths.user(uid)).snapshots().map((snap) {
      if (!snap.exists) return null;
      return AppUser.fromJson(snap.data()!);
    });
  }

  Future<void> incrementVideosWatched(String uid) async {
    await _firestore.doc(FirestorePaths.user(uid)).update({
      'totalVideosWatched': FieldValue.increment(1),
      'lastActiveAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateAfterReaction(
    String uid, {
    required int tearRating,
    required List<String> emotionTags,
    required double newAverageRating,
    required int newTotalReactions,
  }) async {
    final updates = <String, dynamic>{
      'totalReactions': newTotalReactions,
      'averageTearRating': newAverageRating,
      'lastActiveAt': FieldValue.serverTimestamp(),
    };
    for (final tag in emotionTags) {
      updates['emotionTagCounts.$tag'] = FieldValue.increment(1);
    }
    await _firestore.doc(FirestorePaths.user(uid)).update(updates);
  }
}
