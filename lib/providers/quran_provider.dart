import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran/quran.dart' as quran;
import '../models/surah.dart';
import '../models/ayah.dart';
import '../models/bookmark.dart';
import '../data/quran_data.dart';
import '../services/firebase_service.dart';

class QuranProvider extends ChangeNotifier {
  int _currentPage = 1;
  int _currentSurah = 1;
  bool _showTranslation = true;
  bool _nightMode = false;
  double _fontSize = 26.0;
  List<Bookmark> _bookmarks = [];
  String _searchQuery = '';
  List<Ayah> _searchResults = [];
  bool _isLoading = false;

  // Firebase service (optional – works offline too)
  final _firebase = FirebaseService();

  int get currentPage => _currentPage;
  int get currentSurah => _currentSurah;
  bool get showTranslation => _showTranslation;
  bool get nightMode => _nightMode;
  double get fontSize => _fontSize;
  List<Bookmark> get bookmarks => List.unmodifiable(_bookmarks);
  String get searchQuery => _searchQuery;
  List<Ayah> get searchResults => List.unmodifiable(_searchResults);
  bool get isLoading => _isLoading;
  int get totalPages => quran.totalPagesCount;
  List<Surah> get surahs => QuranData.surahs;

  // ─── Quran Data (using quran package for full Arabic text) ───────────────

  /// Get all ayahs for a given page using the quran package.
  List<Ayah> getAyahsForPage(int page) {
    try {
      final pageData = quran.getPageData(page);
      final List<Ayah> ayahs = [];
      for (final entry in pageData) {
        final surahNum = entry['surah'] as int;
        final startAyah = entry['start'] as int;
        final endAyah = entry['end'] as int;
        for (int a = startAyah; a <= endAyah; a++) {
          ayahs.add(_buildAyah(surahNum, a));
        }
      }
      return ayahs;
    } catch (e) {
      return [];
    }
  }

  /// Get all ayahs for a surah using the quran package.
  List<Ayah> getAyahsForSurah(int surahNumber) {
    try {
      final count = quran.getVerseCount(surahNumber);
      return List.generate(
        count,
        (i) => _buildAyah(surahNumber, i + 1),
      );
    } catch (e) {
      return [];
    }
  }

  Ayah _buildAyah(int surahNumber, int ayahNumber) {
    final text = quran.getVerse(surahNumber, ayahNumber, verseEndSymbol: true);
    final page = quran.getPageNumber(surahNumber, ayahNumber);
    final juz = quran.getJuzNumber(surahNumber, ayahNumber);
    // Use built-in Saheeh International translation (all 6236 ayahs included)
    String translation = '';
    try {
      translation = quran.getVerseTranslation(surahNumber, ayahNumber);
    } catch (_) {}
    return Ayah(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      text: text,
      translation: translation,
      page: page,
      juz: juz,
    );
  }

  // ─── Navigation ──────────────────────────────────────────────────────────
  void navigateToPage(int page) {
    if (page >= 1 && page <= totalPages) {
      _currentPage = page;
      try {
        final data = quran.getPageData(page);
        if (data.isNotEmpty) _currentSurah = data.first['surah'] as int;
      } catch (_) {}
      notifyListeners();
      _saveLastPosition();
    }
  }

  void navigateToSurah(int surahNumber) {
    _currentSurah = surahNumber;
    try {
      _currentPage = quran.getPageNumber(surahNumber, 1);
    } catch (_) {
      _currentPage = QuranData.getSurahByNumber(surahNumber).startPage;
    }
    notifyListeners();
    _saveLastPosition();
  }

  // ─── Settings ─────────────────────────────────────────────────────────────
  void toggleTranslation() {
    _showTranslation = !_showTranslation;
    notifyListeners();
    _saveSettings();
  }

  void toggleNightMode() {
    _nightMode = !_nightMode;
    notifyListeners();
    _saveSettings();
  }

  void setFontSize(double size) {
    _fontSize = size.clamp(18.0, 42.0);
    notifyListeners();
    _saveSettings();
  }

  // ─── Bookmarks ─────────────────────────────────────────────────────────────
  void addBookmark(int surahNumber, int ayahNumber) {
    final surahName = QuranData.getSurahByNumber(surahNumber).name;
    final key = '$surahNumber:$ayahNumber';
    if (!_bookmarks.any((b) => b.key == key)) {
      final bm = Bookmark(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        surahName: surahName,
        savedAt: DateTime.now(),
      );
      _bookmarks.add(bm);
      notifyListeners();
      _saveBookmarks();
      // Sync to Firebase if signed in
      _firebase.addBookmark(bm).catchError((_) {});
    }
  }

  void removeBookmark(int surahNumber, int ayahNumber) {
    final key = '$surahNumber:$ayahNumber';
    _bookmarks.removeWhere((b) => b.key == key);
    notifyListeners();
    _saveBookmarks();
    _firebase.removeBookmark(key).catchError((_) {});
  }

  bool isBookmarked(int surahNumber, int ayahNumber) =>
      _bookmarks.any((b) => b.key == '$surahNumber:$ayahNumber');

  void clearBookmarks() {
    _bookmarks.clear();
    notifyListeners();
    _saveBookmarks();
  }

  // ─── Search ───────────────────────────────────────────────────────────────
  void search(String query) {
    _searchQuery = query;
    if (query.trim().isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    final q = query.trim().toLowerCase();
    final results = <Ayah>[];
    for (int s = 1; s <= 114; s++) {
      try {
        final count = quran.getVerseCount(s);
        for (int a = 1; a <= count; a++) {
          final text = quran.getVerse(s, a);
          String translation = '';
          try {
            translation = quran.getVerseTranslation(s, a);
          } catch (_) {}
          if (text.contains(q) || translation.toLowerCase().contains(q)) {
            results.add(_buildAyah(s, a));
            if (results.length >= 100) break;
          }
        }
      } catch (_) {}
      if (results.length >= 100) break;
    }
    _searchResults = results;
    notifyListeners();
  }

  // ─── Persistence ──────────────────────────────────────────────────────────
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _nightMode = prefs.getBool('nightMode') ?? false;
    _fontSize = prefs.getDouble('fontSize') ?? 26.0;
    _showTranslation = prefs.getBool('showTranslation') ?? true;
    _currentPage = prefs.getInt('lastPage') ?? 1;
    _currentSurah = prefs.getInt('lastSurah') ?? 1;

    final bookmarksJson = prefs.getStringList('bookmarks') ?? [];
    _bookmarks = bookmarksJson
        .map((s) => Bookmark.fromJson(jsonDecode(s)))
        .toList();

    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('nightMode', _nightMode);
    await prefs.setDouble('fontSize', _fontSize);
    await prefs.setBool('showTranslation', _showTranslation);
  }

  Future<void> _saveLastPosition() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastPage', _currentPage);
    await prefs.setInt('lastSurah', _currentSurah);
  }

  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _bookmarks.map((b) => jsonEncode(b.toJson())).toList();
    await prefs.setStringList('bookmarks', list);
  }
}
