import '../models/ayah.dart';

class AyahData {
  static final List<Ayah> _allAyahs = _buildAyahs();

  static List<Ayah> _buildAyahs() {
    final List<Ayah> ayahs = [];

    // Surah 1 - Al-Fatihah
    final fatihah = [
      ['بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ', 'In the name of Allah, the Entirely Merciful, the Especially Merciful.'],
      ['ٱلۡحَمۡدُ لِلَّهِ رَبِّ ٱلۡعَٰلَمِينَ', 'All praise is due to Allah, Lord of the worlds -'],
      ['ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ', 'The Entirely Merciful, the Especially Merciful,'],
      ['مَٰلِكِ يَوۡمِ ٱلدِّينِ', 'Sovereign of the Day of Recompense.'],
      ['إِيَّاكَ نَعۡبُدُ وَإِيَّاكَ نَسۡتَعِينُ', 'It is You we worship and You we ask for help.'],
      ['ٱهۡدِنَا ٱلصِّرَٰطَ ٱلۡمُسۡتَقِيمَ', 'Guide us to the straight path -'],
      ['صِرَٰطَ ٱلَّذِينَ أَنۡعَمۡتَ عَلَيۡهِمۡ غَيۡرِ ٱلۡمَغۡضُوبِ عَلَيۡهِمۡ وَلَا ٱلضَّآلِّينَ', 'The path of those upon whom You have bestowed favor, not of those who have evoked anger or of those who are astray.'],
    ];
    for (int i = 0; i < fatihah.length; i++) {
      ayahs.add(Ayah(surahNumber: 1, ayahNumber: i + 1, text: fatihah[i][0], translation: fatihah[i][1], page: 1, juz: 1));
    }

    // Surah 2 - Al-Baqarah (first 20 ayahs)
    final baqarah = [
      ['الٓمٓ', 'Alif, Lam, Meem.', 2, 1],
      ['ذَٰلِكَ ٱلۡكِتَٰبُ لَا رَيۡبَۛ فِيهِۛ هُدٗى لِّلۡمُتَّقِينَ', 'This is the Book about which there is no doubt, a guidance for those conscious of Allah -', 2, 1],
      ['ٱلَّذِينَ يُؤۡمِنُونَ بِٱلۡغَيۡبِ وَيُقِيمُونَ ٱلصَّلَوٰةَ وَمِمَّا رَزَقۡنَٰهُمۡ يُنفِقُونَ', 'Who believe in the unseen, establish prayer, and spend out of what We have provided for them,', 2, 1],
      ['وَٱلَّذِينَ يُؤۡمِنُونَ بِمَآ أُنزِلَ إِلَيۡكَ وَمَآ أُنزِلَ مِن قَبۡلِكَ وَبِٱلۡأٓخِرَةِ هُمۡ يُوقِنُونَ', 'And who believe in what has been revealed to you, and what was revealed before you, and of the Hereafter they are certain.', 2, 1],
      ['أُوْلَٰٓئِكَ عَلَىٰ هُدٗى مِّن رَّبِّهِمۡۖ وَأُوْلَٰٓئِكَ هُمُ ٱلۡمُفۡلِحُونَ', 'Those are upon guidance from their Lord, and it is those who are the successful.', 2, 1],
      ['إِنَّ ٱلَّذِينَ كَفَرُواْ سَوَآءٌ عَلَيۡهِمۡ ءَأَنذَرۡتَهُمۡ أَمۡ لَمۡ تُنذِرۡهُمۡ لَا يُؤۡمِنُونَ', 'Indeed, those who disbelieve - it is all the same for them whether you warn them or do not warn them - they will not believe.', 2, 1],
      ['خَتَمَ ٱللَّهُ عَلَىٰ قُلُوبِهِمۡ وَعَلَىٰ سَمۡعِهِمۡۖ وَعَلَىٰٓ أَبۡصَٰرِهِمۡ غِشَٰوَةٌۖ وَلَهُمۡ عَذَابٌ عَظِيمٌ', 'Allah has set a seal upon their hearts and upon their hearing, and over their vision is a veil. And for them is a great punishment.', 2, 1],
      ['وَمِنَ ٱلنَّاسِ مَن يَقُولُ ءَامَنَّا بِٱللَّهِ وَبِٱلۡيَوۡمِ ٱلۡأٓخِرِ وَمَا هُم بِمُؤۡمِنِينَ', 'And of the people are some who say, "We believe in Allah and the Last Day," but they are not believers.', 2, 1],
      ['يُخَٰدِعُونَ ٱللَّهَ وَٱلَّذِينَ ءَامَنُواْ وَمَا يَخۡدَعُونَ إِلَّآ أَنفُسَهُمۡ وَمَا يَشۡعُرُونَ', 'They deceive Allah and those who believe, but they deceive not except themselves and perceive it not.', 2, 1],
      ['فِي قُلُوبِهِم مَّرَضٌ فَزَادَهُمُ ٱللَّهُ مَرَضٗاۖ وَلَهُمۡ عَذَابٌ أَلِيمُۢ بِمَا كَانُواْ يَكۡذِبُونَ', 'In their hearts is disease, so Allah has increased their disease; and for them is a painful punishment because they habitually used to lie.', 2, 1],
    ];
    for (int i = 0; i < baqarah.length; i++) {
      ayahs.add(Ayah(
        surahNumber: 2,
        ayahNumber: i + 1,
        text: baqarah[i][0] as String,
        translation: baqarah[i][1] as String,
        page: baqarah[i][2] as int,
        juz: baqarah[i][3] as int,
      ));
    }

    // Surah 112 - Al-Ikhlas
    final ikhlas = [
      ['قُلۡ هُوَ ٱللَّهُ أَحَدٌ', 'Say, "He is Allah, the One,'],
      ['ٱللَّهُ ٱلصَّمَدُ', 'Allah, the Eternal Refuge.'],
      ['لَمۡ يَلِدۡ وَلَمۡ يُولَدۡ', 'He neither begets nor is born,'],
      ['وَلَمۡ يَكُن لَّهُۥ كُفُوًا أَحَدُۢ', 'Nor is there to Him any equivalent."'],
    ];
    for (int i = 0; i < ikhlas.length; i++) {
      ayahs.add(Ayah(surahNumber: 112, ayahNumber: i + 1, text: ikhlas[i][0], translation: ikhlas[i][1], page: 604, juz: 30));
    }

    // Surah 113 - Al-Falaq
    final falaq = [
      ['قُلۡ أَعُوذُ بِرَبِّ ٱلۡفَلَقِ', 'Say, "I seek refuge in the Lord of daybreak'],
      ['مِن شَرِّ مَا خَلَقَ', 'From the evil of that which He created'],
      ['وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ', 'And from the evil of darkness when it settles'],
      ['وَمِن شَرِّ ٱلنَّفَّٰثَٰتِ فِي ٱلۡعُقَدِ', 'And from the evil of the blowers in knots'],
      ['وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ', 'And from the evil of an envier when he envies."'],
    ];
    for (int i = 0; i < falaq.length; i++) {
      ayahs.add(Ayah(surahNumber: 113, ayahNumber: i + 1, text: falaq[i][0], translation: falaq[i][1], page: 604, juz: 30));
    }

    // Surah 114 - An-Nas
    final nas = [
      ['قُلۡ أَعُوذُ بِرَبِّ ٱلنَّاسِ', 'Say, "I seek refuge in the Lord of mankind,'],
      ['مَلِكِ ٱلنَّاسِ', 'The Sovereign of mankind,'],
      ['إِلَٰهِ ٱلنَّاسِ', 'The God of mankind,'],
      ['مِن شَرِّ ٱلۡوَسۡوَاسِ ٱلۡخَنَّاسِ', 'From the evil of the retreating whisperer -'],
      ['ٱلَّذِي يُوَسۡوِسُ فِي صُدُورِ ٱلنَّاسِ', 'Who whispers in the breasts of mankind -'],
      ['مِنَ ٱلۡجِنَّةِ وَٱلنَّاسِ', 'From among the jinn and mankind."'],
    ];
    for (int i = 0; i < nas.length; i++) {
      ayahs.add(Ayah(surahNumber: 114, ayahNumber: i + 1, text: nas[i][0], translation: nas[i][1], page: 604, juz: 30));
    }

    // Surah 36 - Ya-Sin (first 12 ayahs)
    final yasin = [
      ['يسٓ', 'Ya, Seen.', 440, 22],
      ['وَٱلۡقُرۡءَانِ ٱلۡحَكِيمِ', 'By the wise Quran.', 440, 22],
      ['إِنَّكَ لَمِنَ ٱلۡمُرۡسَلِينَ', 'Indeed you, [O Muhammad], are from among the messengers,', 440, 22],
      ['عَلَىٰ صِرَٰطٍ مُّسۡتَقِيمٍ', 'On a straight path.', 440, 22],
      ['تَنزِيلَ ٱلۡعَزِيزِ ٱلرَّحِيمِ', '[This is] a revelation of the Exalted in Might, the Merciful,', 440, 22],
      ['لِتُنذِرَ قَوۡمٗا مَّآ أُنذِرَ ءَابَآؤُهُمۡ فَهُمۡ غَٰفِلُونَ', 'That you may warn a people whose forefathers were not warned, so they are unaware.', 440, 22],
    ];
    for (int i = 0; i < yasin.length; i++) {
      ayahs.add(Ayah(
        surahNumber: 36,
        ayahNumber: i + 1,
        text: yasin[i][0] as String,
        translation: yasin[i][1] as String,
        page: yasin[i][2] as int,
        juz: yasin[i][3] as int,
      ));
    }

    // Surah 55 - Ar-Rahman (first 13 ayahs)
    final rahman = [
      ['ٱلرَّحۡمَٰنُ', 'The Most Merciful', 531, 27],
      ['عَلَّمَ ٱلۡقُرۡءَانَ', 'Taught the Quran,', 531, 27],
      ['خَلَقَ ٱلۡإِنسَٰنَ', 'Created man,', 531, 27],
      ['عَلَّمَهُ ٱلۡبَيَانَ', 'Taught him eloquence.', 531, 27],
      ['ٱلشَّمۡسُ وَٱلۡقَمَرُ بِحُسۡبَانٍ', 'The sun and the moon follow calculated courses,', 531, 27],
      ['وَٱلنَّجۡمُ وَٱلشَّجَرُ يَسۡجُدَانِ', 'And the stars and trees prostrate.', 531, 27],
      ['وَٱلسَّمَآءَ رَفَعَهَا وَوَضَعَ ٱلۡمِيزَانَ', 'And the heaven He raised and imposed the balance', 531, 27],
      ['أَلَّا تَطۡغَوۡاْ فِي ٱلۡمِيزَانِ', 'That you not transgress within the balance.', 531, 27],
      ['وَأَقِيمُواْ ٱلۡوَزۡنَ بِٱلۡقِسۡطِ وَلَا تُخۡسِرُواْ ٱلۡمِيزَانَ', 'And establish weight in justice and do not make deficient the balance.', 531, 27],
      ['وَٱلۡأَرۡضَ وَضَعَهَا لِلۡأَنَامِ', 'And the earth He laid for the creatures.', 531, 27],
      ['فَبِأَيِّ ءَالَآءِ رَبِّكُمَا تُكَذِّبَانِ', 'So which of the favors of your Lord would you deny?', 531, 27],
    ];
    for (int i = 0; i < rahman.length; i++) {
      ayahs.add(Ayah(
        surahNumber: 55,
        ayahNumber: i + 1,
        text: rahman[i][0] as String,
        translation: rahman[i][1] as String,
        page: rahman[i][2] as int,
        juz: rahman[i][3] as int,
      ));
    }

    // Surah 67 - Al-Mulk (first 10 ayahs)
    final mulk = [
      ['تَبَٰرَكَ ٱلَّذِي بِيَدِهِ ٱلۡمُلۡكُ وَهُوَ عَلَىٰ كُلِّ شَيۡءٍ قَدِيرٌ', 'Blessed is He in whose hand is dominion, and He is over all things competent -', 562, 29],
      ['ٱلَّذِي خَلَقَ ٱلۡمَوۡتَ وَٱلۡحَيَوٰةَ لِيَبۡلُوَكُمۡ أَيُّكُمۡ أَحۡسَنُ عَمَلٗاۚ وَهُوَ ٱلۡعَزِيزُ ٱلۡغَفُورُ', 'Who created death and life to test you as to which of you is best in deed - and He is the Exalted in Might, the Forgiving -', 562, 29],
      ['ٱلَّذِي خَلَقَ سَبۡعَ سَمَٰوَٰتٍ طِبَاقٗاۖ مَّا تَرَىٰ فِي خَلۡقِ ٱلرَّحۡمَٰنِ مِن تَفَٰوُتٍۖ فَٱرۡجِعِ ٱلۡبَصَرَ هَلۡ تَرَىٰ مِن فُطُورٍ', 'Who created seven heavens in layers. You do not see in the creation of the Most Merciful any inconsistency. So return your vision; do you see any breaks?', 562, 29],
      ['ثُمَّ ٱرۡجِعِ ٱلۡبَصَرَ كَرَّتَيۡنِ يَنقَلِبۡ إِلَيۡكَ ٱلۡبَصَرُ خَاسِئٗا وَهُوَ حَسِيرٌ', 'Then return your vision twice again. Your vision will return humbled while it is fatigued.', 562, 29],
      ['وَلَقَدۡ زَيَّنَّا ٱلسَّمَآءَ ٱلدُّنۡيَا بِمَصَٰبِيحَ وَجَعَلۡنَٰهَا رُجُومٗا لِّلشَّيَٰطِينِۖ وَأَعۡتَدۡنَا لَهُمۡ عَذَابَ ٱلسَّعِيرِ', 'And We have certainly beautified the nearest heaven with stars and have made them what is thrown at the devils and have prepared for them the punishment of the Blaze.', 562, 29],
    ];
    for (int i = 0; i < mulk.length; i++) {
      ayahs.add(Ayah(
        surahNumber: 67,
        ayahNumber: i + 1,
        text: mulk[i][0] as String,
        translation: mulk[i][1] as String,
        page: mulk[i][2] as int,
        juz: mulk[i][3] as int,
      ));
    }

    return ayahs;
  }

  static List<Ayah> getAyahsForSurah(int surahNumber) {
    return _allAyahs.where((a) => a.surahNumber == surahNumber).toList()
      ..sort((a, b) => a.ayahNumber.compareTo(b.ayahNumber));
  }

  static List<Ayah> getAyahsForPage(int page) {
    return _allAyahs.where((a) => a.page == page).toList()
      ..sort((a, b) {
        if (a.surahNumber != b.surahNumber) {
          return a.surahNumber.compareTo(b.surahNumber);
        }
        return a.ayahNumber.compareTo(b.ayahNumber);
      });
  }

  static List<Ayah> searchAyahs(String query) {
    final lq = query.toLowerCase();
    return _allAyahs
        .where((a) =>
            a.text.contains(query) ||
            a.translation.toLowerCase().contains(lq))
        .toList();
  }
}
