import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/quran.dart' as quran;
import '../providers/quran_provider.dart';
import '../models/ayah.dart';
import '../data/quran_data.dart';
import '../themes/app_theme.dart';

class MushafPageWidget extends StatelessWidget {
  final int pageNumber;

  const MushafPageWidget({super.key, required this.pageNumber});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuranProvider>();
    final isDark = provider.nightMode;
    final bg = isDark ? MushafColors.nightBg : MushafColors.parchment;
    final border = isDark ? MushafColors.nightBorder : MushafColors.gold;

    return Container(
      color: bg,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? MushafColors.nightSurface : MushafColors.parchment,
            border: Border.all(color: border, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.4 : 0.12),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _PageHeader(pageNumber: pageNumber, isDark: isDark),
              _InnerBorder(isDark: isDark),
              Expanded(
                child: _PageBody(
                  pageNumber: pageNumber,
                  isDark: isDark,
                  provider: provider,
                ),
              ),
              _InnerBorder(isDark: isDark),
              _PageFooter(pageNumber: pageNumber, isDark: isDark),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Page Header (Surah name left / Juz right) ────────────────────────────────
class _PageHeader extends StatelessWidget {
  final int pageNumber;
  final bool isDark;
  const _PageHeader({required this.pageNumber, required this.isDark});

  @override
  Widget build(BuildContext context) {
    String surahName = '';
    String juzLabel = '';
    try {
      final data = quran.getPageData(pageNumber);
      if (data.isNotEmpty) {
        final surahNum = data.first['surah'] as int;
        surahName = QuranData.getSurahByNumber(surahNum).name;
        final juz = quran.getJuzNumber(surahNum, data.first['start'] as int);
        juzLabel = 'الجزء $juz';
      }
    } catch (_) {}

    final textColor =
        isDark ? MushafColors.nightText : MushafColors.inkMedium;
    final accentColor = isDark ? MushafColors.gold : MushafColors.green;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(isDark ? 0.12 : 0.08),
        border: Border(
          bottom: BorderSide(
            color: isDark ? MushafColors.nightBorder : MushafColors.goldLight,
            width: 0.8,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            juzLabel,
            style: GoogleFonts.amiri(
              fontSize: 13,
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
            textDirection: TextDirection.rtl,
          ),
          Text(
            surahName,
            style: GoogleFonts.amiri(
              fontSize: 13,
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}

// ─── Inner decorative border line ─────────────────────────────────────────────
class _InnerBorder extends StatelessWidget {
  final bool isDark;
  const _InnerBorder({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.transparent, MushafColors.gold.withOpacity(0.4), Colors.transparent]
              : [Colors.transparent, MushafColors.gold, Colors.transparent],
        ),
      ),
    );
  }
}

// ─── Page Body ────────────────────────────────────────────────────────────────
class _PageBody extends StatelessWidget {
  final int pageNumber;
  final bool isDark;
  final QuranProvider provider;

  const _PageBody({
    required this.pageNumber,
    required this.isDark,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final ayahs = provider.getAyahsForPage(pageNumber);

    if (ayahs.isEmpty) {
      return _EmptyPage(pageNumber: pageNumber, isDark: isDark);
    }

    // Group ayahs by surah for rendering surah banners
    final List<Widget> widgets = [];
    int? lastSurah;

    for (final ayah in ayahs) {
      if (ayah.surahNumber != lastSurah) {
        // New surah starts on this page
        if (ayah.ayahNumber == 1) {
          widgets.add(_SurahBanner(
            surahNumber: ayah.surahNumber,
            isDark: isDark,
          ));
        }
        lastSurah = ayah.surahNumber;
      }
      widgets.add(_AyahText(
        ayah: ayah,
        isDark: isDark,
        fontSize: provider.fontSize,
        showTranslation: provider.showTranslation,
        isBookmarked: provider.isBookmarked(ayah.surahNumber, ayah.ayahNumber),
        onBookmark: () {
          if (provider.isBookmarked(ayah.surahNumber, ayah.ayahNumber)) {
            provider.removeBookmark(ayah.surahNumber, ayah.ayahNumber);
          } else {
            provider.addBookmark(ayah.surahNumber, ayah.ayahNumber);
          }
        },
      ));
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      children: widgets,
    );
  }
}

// ─── Surah Banner ─────────────────────────────────────────────────────────────
class _SurahBanner extends StatelessWidget {
  final int surahNumber;
  final bool isDark;

  const _SurahBanner({required this.surahNumber, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final surah = QuranData.getSurahByNumber(surahNumber);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          // Gold divider line
          Row(children: [
            Expanded(child: Divider(color: MushafColors.gold.withOpacity(0.6), thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Icon(Icons.star, color: MushafColors.gold, size: 10),
            ),
            Expanded(child: Divider(color: MushafColors.gold.withOpacity(0.6), thickness: 1)),
          ]),
          const SizedBox(height: 4),
          // Surah title banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1A3A1A), const Color(0xFF0D2A0D)]
                    : [MushafColors.green, MushafColors.greenLight],
              ),
              border: Border.all(color: MushafColors.gold, width: 1),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Column(
              children: [
                // Surah name
                Text(
                  surah.name,
                  style: GoogleFonts.amiri(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  '${surah.nameEnglish}  •  ${surah.revelationType}  •  ${surah.ayahCount} آية',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                // Basmala (not for Surah 9)
                if (surahNumber != 9) ...[
                  const SizedBox(height: 6),
                  const Divider(color: Colors.white24, thickness: 0.5),
                  const SizedBox(height: 4),
                  const Text(
                    'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFDAA643),
                    ),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(children: [
            Expanded(child: Divider(color: MushafColors.gold.withOpacity(0.6), thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Icon(Icons.star, color: MushafColors.gold, size: 10),
            ),
            Expanded(child: Divider(color: MushafColors.gold.withOpacity(0.6), thickness: 1)),
          ]),
        ],
      ),
    );
  }
}

// ─── Ayah Text ────────────────────────────────────────────────────────────────
class _AyahText extends StatelessWidget {
  final Ayah ayah;
  final bool isDark;
  final double fontSize;
  final bool showTranslation;
  final bool isBookmarked;
  final VoidCallback onBookmark;

  const _AyahText({
    required this.ayah,
    required this.isDark,
    required this.fontSize,
    required this.showTranslation,
    required this.isBookmarked,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? MushafColors.nightText : MushafColors.inkDark;
    final transColor = isDark
        ? MushafColors.nightText.withOpacity(0.65)
        : MushafColors.inkLight;
    final verseNumColor = isDark ? MushafColors.gold : MushafColors.gold;

    return GestureDetector(
      onLongPress: onBookmark,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 1),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        decoration: BoxDecoration(
          color: isBookmarked
              ? MushafColors.gold.withOpacity(isDark ? 0.12 : 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Arabic verse text with inline verse number marker
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: '${ayah.text} ',
                    style: GoogleFonts.amiri(
                      fontSize: fontSize,
                      color: textColor,
                      height: 2.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: _VerseNumberBadge(
                      number: ayah.ayahNumber,
                      color: verseNumColor,
                      isDark: isDark,
                    ),
                  ),
                ]),
                textAlign: TextAlign.justify,
              ),
            ),
            // Translation (collapsible)
            if (showTranslation && ayah.translation.isNotEmpty) ...[
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.only(right: 4, bottom: 2),
                child: Text(
                  '${ayah.ayahNumber}. ${ayah.translation}',
                  style: GoogleFonts.notoSans(
                    fontSize: fontSize * 0.48,
                    color: transColor,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Verse Number Badge ────────────────────────────────────────────────────────
class _VerseNumberBadge extends StatelessWidget {
  final int number;
  final Color color;
  final bool isDark;

  const _VerseNumberBadge(
      {required this.number, required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.5),
        color: color.withOpacity(isDark ? 0.15 : 0.1),
      ),
      child: Center(
        child: Text(
          _toArabicNumerals(number),
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.bold,
          ),
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }

  String _toArabicNumerals(int n) {
    const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return n.toString().split('').map((c) {
      final i = western.indexOf(c);
      return i >= 0 ? arabic[i] : c;
    }).join();
  }
}

// ─── Page Footer ──────────────────────────────────────────────────────────────
class _PageFooter extends StatelessWidget {
  final int pageNumber;
  final bool isDark;
  const _PageFooter({required this.pageNumber, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = isDark ? MushafColors.gold.withOpacity(0.7) : MushafColors.gold;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _dot(color),
          const SizedBox(width: 8),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 1.5),
              color: color.withOpacity(0.1),
            ),
            child: Center(
              child: Text(
                '$pageNumber',
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _dot(color),
        ],
      ),
    );
  }

  Widget _dot(Color c) => Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: c,
          borderRadius: BorderRadius.circular(1),
        ),
        transform: Matrix4.rotationZ(0.785398), // 45 degrees = diamond shape
      );
}

// ─── Empty Page ───────────────────────────────────────────────────────────────
class _EmptyPage extends StatelessWidget {
  final int pageNumber;
  final bool isDark;
  const _EmptyPage({required this.pageNumber, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book_outlined,
              size: 64, color: isDark ? Colors.white12 : Colors.black12),
          const SizedBox(height: 16),
          Text(
            'صفحة $pageNumber',
            style: GoogleFonts.amiri(
              fontSize: 22,
              color: isDark ? Colors.white30 : Colors.black26,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}
