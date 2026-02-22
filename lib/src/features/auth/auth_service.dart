import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teardrop/src/data/models/app_user.dart';
import 'package:teardrop/src/shared/constants/firestore_paths.dart';

class AuthService {
  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User> signInAnonymously() async {
    final credential = await _auth.signInAnonymously();
    final user = credential.user!;

    // Create user doc if first time
    final userDoc =
        _firestore.doc(FirestorePaths.user(user.uid));
    final snapshot = await userDoc.get();
    if (!snapshot.exists) {
      final now = DateTime.now();
      final appUser = AppUser(
        uid: user.uid,
        createdAt: now,
        lastActiveAt: now,
      );
      await userDoc.set(appUser.toJson());
    }

    return user;
  }

  Future<void> updateLastActive() async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _firestore.doc(FirestorePaths.user(user.uid)).update({
      'lastActiveAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
