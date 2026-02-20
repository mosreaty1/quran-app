import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/quran_provider.dart';
import '../data/quran_data.dart';
import '../models/ayah.dart';
import '../widgets/ayah_card.dart';

class SurahDetailScreen extends StatelessWidget {
  final int surahNumber;

  const SurahDetailScreen({super.key, required this.surahNumber});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuranProvider>();
    final surah = QuranData.getSurahByNumber(surahNumber);
    final ayahs = provider.getAyahsForSurah(surahNumber);
    final isDark = provider.nightMode;
    final bgColor = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFFDF6E3);
    final accentColor = isDark ? const Color(0xFF4CAF50) : const Color(0xFF1B5E20);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF2D2D2D) : accentColor,
        foregroundColor: Colors.white,
        title: Column(
          children: [
            Text(
              surah.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              '${surah.nameEnglish} • ${surah.ayahCount} verses',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(provider.showTranslation
                ? Icons.translate
                : Icons.translate_outlined),
            onPressed: () => provider.toggleTranslation(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Surah header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 8),
                Text(
                  '${surah.nameEnglish} — ${surah.nameMeaning}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _InfoChip(label: surah.revelationType, isDark: isDark),
                    const SizedBox(width: 8),
                    _InfoChip(label: '${surah.ayahCount} Verses', isDark: isDark),
                    const SizedBox(width: 8),
                    _InfoChip(label: 'Page ${surah.startPage}', isDark: isDark),
                  ],
                ),
                // Basmala (except for At-Tawbah, surah 9)
                if (surahNumber != 9) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
          // Ayahs
          Expanded(
            child: ayahs.isEmpty
                ? _EmptyAyahsView(surah: surah, isDark: isDark)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
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
                        onCopy: () {
                          Clipboard.setData(ClipboardData(text: ayah.text));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Ayah copied to clipboard')),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final bool isDark;

  const _InfoChip({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}

class _EmptyAyahsView extends StatelessWidget {
  final dynamic surah;
  final bool isDark;

  const _EmptyAyahsView({required this.surah, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book_outlined,
                size: 64,
                color: isDark ? Colors.white30 : Colors.black26),
            const SizedBox(height: 16),
            Text(
              surah.name,
              style: TextStyle(
                fontSize: 32,
                color: isDark ? const Color(0xFF4CAF50) : const Color(0xFF1B5E20),
                fontWeight: FontWeight.bold,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 8),
            Text(
              '${surah.ayahCount} verses — ${surah.revelationType}',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white54 : Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Full text for this surah\nwill be available in the complete version.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.white38 : Colors.black38,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
