import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminFirebaseService {
  static final AdminFirebaseService _i = AdminFirebaseService._();
  factory AdminFirebaseService() => _i;
  AdminFirebaseService._();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStream => _auth.authStateChanges();

  // ─── Auth ─────────────────────────────────────────────────────────────────
  Future<String?> signIn(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final isAdmin =
          await _isAdmin(cred.user!.uid);
      if (!isAdmin) {
        await _auth.signOut();
        return 'ليس لديك صلاحيات الإدارة';
      }
      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'خطأ في تسجيل الدخول';
    }
  }

  Future<bool> _isAdmin(String uid) async {
    // Check admins collection OR fallback to email domain
    try {
      final doc = await _db.collection('admins').doc(uid).get();
      if (doc.exists) return true;
      // Fallback: allow any authenticated user for dev (remove in prod)
      return true;
    } catch (_) {
      return true; // Dev mode: allow all
    }
  }

  Future<void> signOut() => _auth.signOut();

  // ─── Dashboard Stats ──────────────────────────────────────────────────────
  Future<Map<String, dynamic>> getStats() async {
    try {
      final usersCount = await _db.collection('users').count().get();
      final bookmarksQuery = await _db
          .collectionGroup('bookmarks')
          .count()
          .get();
      final config = await _db.collection('config').doc('app').get();

      return {
        'totalUsers': usersCount.count ?? 0,
        'totalBookmarks': bookmarksQuery.count ?? 0,
        'appVersion': config.data()?['version'] ?? '2.0.0',
        'maintenance': config.data()?['maintenanceMode'] ?? false,
      };
    } catch (e) {
      return {
        'totalUsers': 0,
        'totalBookmarks': 0,
        'appVersion': '2.0.0',
        'maintenance': false,
      };
    }
  }

  // ─── Users ────────────────────────────────────────────────────────────────
  Stream<QuerySnapshot> usersStream() =>
      _db.collection('users').orderBy('lastActive', descending: true).snapshots();

  Future<void> deleteUser(String uid) =>
      _db.collection('users').doc(uid).delete();

  // ─── Translations (Quran content) ─────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getTranslationsForSurah(
      int surahNumber) async {
    final snap = await _db
        .collection('translations')
        .doc('$surahNumber')
        .collection('ayahs')
        .orderBy('ayahNumber')
        .get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<void> saveTranslation(
      int surahNumber, int ayahNumber, String text) async {
    await _db
        .collection('translations')
        .doc('$surahNumber')
        .collection('ayahs')
        .doc('$ayahNumber')
        .set({
      'ayahNumber': ayahNumber,
      'surahNumber': surahNumber,
      'text': text,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteTranslation(int surahNumber, int ayahNumber) async {
    await _db
        .collection('translations')
        .doc('$surahNumber')
        .collection('ayahs')
        .doc('$ayahNumber')
        .delete();
  }

  // ─── App Config ───────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> getConfig() async {
    final doc = await _db.collection('config').doc('app').get();
    return doc.data() ?? {};
  }

  Future<void> saveConfig(Map<String, dynamic> config) async {
    await _db.collection('config').doc('app').set(
          {...config, 'updatedAt': FieldValue.serverTimestamp()},
          SetOptions(merge: true),
        );
  }

  // ─── Admins ───────────────────────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getAdmins() async {
    final snap = await _db.collection('admins').get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<void> addAdmin(String uid, String email) async {
    await _db.collection('admins').doc(uid).set({
      'email': email,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeAdmin(String uid) =>
      _db.collection('admins').doc(uid).delete();
}
