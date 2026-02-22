import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teardrop/src/data/models/saved_link.dart';
import 'package:teardrop/src/shared/constants/firestore_paths.dart';
import 'package:uuid/uuid.dart';

class SavedLinkRepository {
  SavedLinkRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  static const _uuid = Uuid();

  Stream<List<SavedLink>> watchSavedLinks(String uid) {
    return _firestore
        .collection(FirestorePaths.savedLinks(uid))
        .orderBy('savedAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => SavedLink.fromJson(doc.data())).toList());
  }

  Future<SavedLink> addLink({
    required String uid,
    required String youtubeId,
    String? userNote,
  }) async {
    final id = _uuid.v4();
    final link = SavedLink(
      id: id,
      youtubeId: youtubeId,
      userId: uid,
      savedAt: DateTime.now(),
      userNote: userNote,
    );
    await _firestore
        .doc(FirestorePaths.savedLink(uid, id))
        .set(link.toJson());
    return link;
  }

  Future<void> deleteLink(String uid, String linkId) async {
    await _firestore.doc(FirestorePaths.savedLink(uid, linkId)).delete();
  }

  Future<void> updateTearRating(
      String uid, String linkId, int tearRating) async {
    await _firestore
        .doc(FirestorePaths.savedLink(uid, linkId))
        .update({'tearRating': tearRating});
  }
}
