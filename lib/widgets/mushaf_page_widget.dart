import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quran_provider.dart';
import '../models/ayah.dart';
import '../data/quran_data.dart';
import 'ayah_card.dart';

class MushafPageWidget extends StatelessWidget {
  final int pageNumber;
  final Color bgColor;
  final Color textColor;

  const MushafPageWidget({
    super.key,
    required this.pageNumber,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuranProvider>();
    final ayahs = provider.getAyahsForPage(pageNumber);
    final isDark = provider.nightMode;
    final accentColor = isDark ? const Color(0xFF4CAF50) : const Color(0xFF1B5E20);

    return Container(
      color: bgColor,
      child: Column(
        children: [
          // Surah header(s) for this page
          _buildSurahHeaders(ayahs, accentColor, isDark),
          // Page content
          Expanded(
            child: ayahs.isEmpty
                ? _buildEmptyPage(pageNumber, isDark, accentColor)
                : _buildAyahList(context, ayahs, provider, isDark),
          ),
          // Page number footer
          _buildPageFooter(pageNumber, accentColor, isDark),
        ],
      ),
    );
  }

  Widget _buildSurahHeaders(List<Ayah> ayahs, Color accentColor, bool isDark) {
    if (ayahs.isEmpty) return const SizedBox.shrink();

    final surahNumbers = <int>{};
    for (final ayah in ayahs) {
      surahNumbers.add(ayah.surahNumber);
    }

    return Column(
      children: surahNumbers.map((surahNum) {
        final surah = QuranData.getSurahByNumber(surahNum);
        final isFirstAyah = ayahs.first.ayahNumber == 1 &&
            ayahs.first.surahNumber == surahNum;

        if (!isFirstAyah) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF2D4A2D), const Color(0xFF1A2E1A)]
                  : [const Color(0xFF1B5E20), const Color(0xFF2E7D32)],
            ),
          ),
          child: Column(
            children: [
              Text(
                surah.name,
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ),
              Text(
                '${surah.nameEnglish} • ${surah.ayahCount} Verses',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              if (surah.number != 9) ...[
                const SizedBox(height: 8),
                const Text(
                  'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAyahList(
    BuildContext context,
    List<Ayah> ayahs,
    QuranProvider provider,
    bool isDark,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      itemCount: ayahs.length,
      itemBuilder: (context, index) {
        final ayah = ayahs[index];
        return AyahCard(
          ayah: ayah,
          showTranslation: provider.showTranslation,
          isBookmarked: provider.isBookmarked(ayah.surahNumber, ayah.ayahNumber),
          isDark: isDark,
          fontSize: provider.fontSize,
          onBookmark: () {
            if (provider.isBookmarked(ayah.surahNumber, ayah.ayahNumber)) {
              provider.removeBookmark(ayah.surahNumber, ayah.ayahNumber);
            } else {
              provider.addBookmark(ayah.surahNumber, ayah.ayahNumber);
            }
          },
          onCopy: () {},
        );
      },
    );
  }

  Widget _buildEmptyPage(int pageNumber, bool isDark, Color accentColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 80,
            color: isDark ? Colors.white12 : Colors.black12,
          ),
          const SizedBox(height: 16),
          Text(
            'Page $pageNumber',
            style: TextStyle(
              fontSize: 24,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Swipe to navigate pages',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white24 : Colors.black26,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageFooter(int pageNumber, Color accentColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              border: Border.all(color: accentColor, width: 1.5),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$pageNumber',
                style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
