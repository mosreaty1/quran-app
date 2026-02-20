class Ayah {
  final int surahNumber;
  final int ayahNumber;
  final String text;
  final String translation;
  final int page;
  final int juz;

  const Ayah({
    required this.surahNumber,
    required this.ayahNumber,
    required this.text,
    required this.translation,
    required this.page,
    required this.juz,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      surahNumber: json['surahNumber'],
      ayahNumber: json['ayahNumber'],
      text: json['text'],
      translation: json['translation'],
      page: json['page'],
      juz: json['juz'],
    );
  }

  Map<String, dynamic> toJson() => {
        'surahNumber': surahNumber,
        'ayahNumber': ayahNumber,
        'text': text,
        'translation': translation,
        'page': page,
        'juz': juz,
      };

  String get key => '$surahNumber:$ayahNumber';
}
