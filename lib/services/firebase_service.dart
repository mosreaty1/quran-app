import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/bookmark.dart';

/// Central Firebase service for the Quran app.
/// Handles authentication, bookmarks sync, and Quran translation data.
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ─── Auth ────────────────────────────────────────────────────────────────
  User? get currentUser => _auth.currentUser;
  bool get isSignedIn => _auth.currentUser != null;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> signInAnonymously() async {
    try {
      return await _auth.signInAnonymously();
    } catch (e) {
      return null;
    }
  }

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async => _auth.signOut();

  // ─── User Document ────────────────────────────────────────────────────────
  Future<void> createUserDocIfNeeded() async {
    final user = _auth.currentUser;
    if (user == null) return;
    final doc = _db.collection('users').doc(user.uid);
    final snap = await doc.get();
    if (!snap.exists) {
      await doc.set({
        'uid': user.uid,
        'email': user.email ?? '',
        'displayName': user.displayName ?? 'Anonymous',
        'createdAt': FieldValue.serverTimestamp(),
        'lastActive': FieldValue.serverTimestamp(),
        'isAnonymous': user.isAnonymous,
      });
    } else {
      await doc.update({'lastActive': FieldValue.serverTimestamp()});
    }
  }

  // ─── User Settings ────────────────────────────────────────────────────────
  Future<void> saveUserSettings(Map<String, dynamic> settings) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _db.collection('users').doc(user.uid).set(
          {'settings': settings, 'lastActive': FieldValue.serverTimestamp()},
          SetOptions(merge: true),
        );
  }

  Future<Map<String, dynamic>?> loadUserSettings() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final snap = await _db.collection('users').doc(user.uid).get();
    if (!snap.exists) return null;
    return (snap.data()?['settings'] as Map<String, dynamic>?);
  }

  // ─── Bookmarks ────────────────────────────────────────────────────────────
  Future<List<Bookmark>> loadBookmarks() async {
    final user = _auth.currentUser;
    if (user == null) return [];
    final snap = await _db
        .collection('users')
        .doc(user.uid)
        .collection('bookmarks')
        .orderBy('savedAt', descending: true)
        .get();
    return snap.docs.map((d) => Bookmark.fromJson(d.data())).toList();
  }

  Future<void> addBookmark(Bookmark bookmark) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _db
        .collection('users')
        .doc(user.uid)
        .collection('bookmarks')
        .doc(bookmark.key)
        .set(bookmark.toJson());
  }

  Future<void> removeBookmark(String key) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _db
        .collection('users')
        .doc(user.uid)
        .collection('bookmarks')
        .doc(key)
        .delete();
  }

  // ─── Translations (managed from admin) ───────────────────────────────────
  Future<String?> getTranslation(int surahNumber, int ayahNumber) async {
    try {
      final doc = await _db
          .collection('translations')
          .doc('$surahNumber')
          .collection('ayahs')
          .doc('$ayahNumber')
          .get();
      return doc.data()?['text'] as String?;
    } catch (_) {
      return null;
    }
  }

  /// Batch upload translations for a surah (used by admin dashboard)
  Future<void> uploadSurahTranslations(
      int surahNumber, Map<int, String> translations) async {
    final batch = _db.batch();
    final col = _db
        .collection('translations')
        .doc('$surahNumber')
        .collection('ayahs');
    for (final entry in translations.entries) {
      batch.set(col.doc('${entry.key}'), {
        'ayahNumber': entry.key,
        'text': entry.value,
        'surahNumber': surahNumber,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  // ─── Admin ────────────────────────────────────────────────────────────────
  Future<bool> isAdmin(String uid) async {
    final doc = await _db.collection('admins').doc(uid).get();
    return doc.exists;
  }

  Future<Map<String, dynamic>> getAdminStats() async {
    try {
      final users = await _db.collection('users').count().get();
      final admins = await _db.collection('admins').count().get();
      final statsDoc = await _db.collection('config').doc('app').get();
      return {
        'totalUsers': users.count ?? 0,
        'totalAdmins': admins.count ?? 0,
        'version': statsDoc.data()?['version'] ?? '2.0.0',
        'maintenanceMode': statsDoc.data()?['maintenanceMode'] ?? false,
      };
    } catch (_) {
      return {'totalUsers': 0, 'totalAdmins': 0, 'version': '2.0.0', 'maintenanceMode': false};
    }
  }

  Future<List<Map<String, dynamic>>> getUsers({int limit = 50}) async {
    final snap = await _db
        .collection('users')
        .orderBy('lastActive', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map((d) => d.data()).toList();
  }

  Future<void> updateAppConfig(Map<String, dynamic> config) async {
    await _db.collection('config').doc('app').set(config, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getAppConfig() async {
    final doc = await _db.collection('config').doc('app').get();
    return doc.data();
  }
}
