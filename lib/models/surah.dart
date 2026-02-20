class Surah {
  final int number;
  final String name;
  final String nameEnglish;
  final String nameMeaning;
  final int ayahCount;
  final String revelationType;
  final int startPage;

  const Surah({
    required this.number,
    required this.name,
    required this.nameEnglish,
    required this.nameMeaning,
    required this.ayahCount,
    required this.revelationType,
    required this.startPage,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'],
      name: json['name'],
      nameEnglish: json['nameEnglish'],
      nameMeaning: json['nameMeaning'],
      ayahCount: json['ayahCount'],
      revelationType: json['revelationType'],
      startPage: json['startPage'],
    );
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'name': name,
        'nameEnglish': nameEnglish,
        'nameMeaning': nameMeaning,
        'ayahCount': ayahCount,
        'revelationType': revelationType,
        'startPage': startPage,
      };
}
