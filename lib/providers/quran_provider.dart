import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/surah.dart';
import '../models/ayah.dart';
import '../models/bookmark.dart';
import '../data/quran_data.dart';
import '../data/ayah_data.dart';

class QuranProvider extends ChangeNotifier {
  int _currentPage = 1;
  int _currentSurah = 1;
  bool _showTranslation = false;
  bool _nightMode = false;
  double _fontSize = 24.0;
  List<Bookmark> _bookmarks = [];
  String _searchQuery = '';
  List<Ayah> _searchResults = [];

  int get currentPage => _currentPage;
  int get currentSurah => _currentSurah;
  bool get showTranslation => _showTranslation;
  bool get nightMode => _nightMode;
  double get fontSize => _fontSize;
  List<Bookmark> get bookmarks => _bookmarks;
  String get searchQuery => _searchQuery;
  List<Ayah> get searchResults => _searchResults;

  List<Surah> get surahs => QuranData.surahs;

  List<Ayah> getAyahsForSurah(int surahNumber) {
    return AyahData.getAyahsForSurah(surahNumber);
  }

  List<Ayah> getAyahsForPage(int page) {
    return AyahData.getAyahsForPage(page);
  }

  int get totalPages => 604;

  void navigateToPage(int page) {
    if (page >= 1 && page <= totalPages) {
      _currentPage = page;
      final ayahs = getAyahsForPage(page);
      if (ayahs.isNotEmpty) {
        _currentSurah = ayahs.first.surahNumber;
      }
      notifyListeners();
      _saveLastPosition();
    }
  }

  void navigateToSurah(int surahNumber) {
    final surah = QuranData.getSurahByNumber(surahNumber);
    _currentSurah = surahNumber;
    _currentPage = surah.startPage;
    notifyListeners();
    _saveLastPosition();
  }

  void toggleTranslation() {
    _showTranslation = !_showTranslation;
    notifyListeners();
  }

  void toggleNightMode() {
    _nightMode = !_nightMode;
    notifyListeners();
    _saveSettings();
  }

  void setFontSize(double size) {
    _fontSize = size.clamp(16.0, 40.0);
    notifyListeners();
    _saveSettings();
  }

  void addBookmark(int surahNumber, int ayahNumber) {
    final surah = QuranData.getSurahByNumber(surahNumber);
    final key = '$surahNumber:$ayahNumber';
    if (!_bookmarks.any((b) => b.key == key)) {
      _bookmarks.add(Bookmark(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        surahName: surah.name,
        savedAt: DateTime.now(),
      ));
      notifyListeners();
      _saveBookmarks();
    }
  }

  void removeBookmark(int surahNumber, int ayahNumber) {
    final key = '$surahNumber:$ayahNumber';
    _bookmarks.removeWhere((b) => b.key == key);
    notifyListeners();
    _saveBookmarks();
  }

  bool isBookmarked(int surahNumber, int ayahNumber) {
    final key = '$surahNumber:$ayahNumber';
    return _bookmarks.any((b) => b.key == key);
  }

  void search(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _searchResults = [];
    } else {
      _searchResults = AyahData.searchAyahs(query);
    }
    notifyListeners();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _nightMode = prefs.getBool('nightMode') ?? false;
    _fontSize = prefs.getDouble('fontSize') ?? 24.0;
    _showTranslation = prefs.getBool('showTranslation') ?? false;
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
