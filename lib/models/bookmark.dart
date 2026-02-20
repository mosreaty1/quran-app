class Bookmark {
  final int surahNumber;
  final int ayahNumber;
  final String surahName;
  final DateTime savedAt;

  const Bookmark({
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahName,
    required this.savedAt,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      surahNumber: json['surahNumber'],
      ayahNumber: json['ayahNumber'],
      surahName: json['surahName'],
      savedAt: DateTime.parse(json['savedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'surahNumber': surahNumber,
        'ayahNumber': ayahNumber,
        'surahName': surahName,
        'savedAt': savedAt.toIso8601String(),
      };

  String get key => '$surahNumber:$ayahNumber';
}
