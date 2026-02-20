import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/quran_provider.dart';
import '../themes/app_theme.dart';
import 'surah_detail_screen.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuranProvider>();
    final isDark = provider.nightMode;
    final bg = isDark ? MushafColors.nightBg : MushafColors.parchment;
    final textColor = isDark ? MushafColors.nightText : MushafColors.inkDark;
    final bookmarks = provider.bookmarks;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor:
            isDark ? MushafColors.nightSurface : MushafColors.green,
        foregroundColor: Colors.white,
        title: Text(
          'المحفوظات',
          style: GoogleFonts.amiri(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          if (bookmarks.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white70),
              tooltip: 'مسح الكل',
              onPressed: () => _confirmClear(context, provider),
            ),
        ],
      ),
      body: bookmarks.isEmpty
          ? _EmptyBookmarks(isDark: isDark)
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: bookmarks.length,
              itemBuilder: (context, i) {
                final bm = bookmarks[i];
                return Dismissible(
                  key: Key(bm.key),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red.shade700,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) =>
                      provider.removeBookmark(bm.surahNumber, bm.ayahNumber),
                  child: InkWell(
                    onTap: () {
                      provider.navigateToSurah(bm.surahNumber);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SurahDetailScreen(surahNumber: bm.surahNumber),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? MushafColors.nightSurface
                            : Colors.white,
                        border: Border.all(
                          color: MushafColors.gold.withOpacity(0.4),
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Gold bookmark icon
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: MushafColors.gold.withOpacity(0.12),
                              border: Border.all(
                                  color: MushafColors.gold, width: 1.5),
                            ),
                            child: const Icon(Icons.bookmark,
                                color: MushafColors.gold, size: 22),
                          ),
                          const SizedBox(width: 12),
                          // Surah info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      bm.surahName,
                                      style: GoogleFonts.amiri(
                                        fontSize: 18,
                                        color: isDark
                                            ? MushafColors.gold
                                            : MushafColors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textDirection: TextDirection.rtl,
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: MushafColors.gold
                                            .withOpacity(0.12),
                                        borderRadius:
                                            BorderRadius.circular(4),
                                        border: Border.all(
                                            color: MushafColors.gold
                                                .withOpacity(0.3)),
                                      ),
                                      child: Text(
                                        'آية ${bm.ayahNumber}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDark
                                              ? MushafColors.gold
                                              : MushafColors.goldDark,
                                        ),
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'سورة ${bm.surahNumber}  •  آية ${bm.ayahNumber}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: textColor.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right,
                              color: textColor.withOpacity(0.3)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _confirmClear(BuildContext context, QuranProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('مسح المحفوظات'),
        content: const Text('هل تريد مسح جميع المحفوظات؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              provider.clearBookmarks();
              Navigator.pop(context);
            },
            child: const Text('مسح', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _EmptyBookmarks extends StatelessWidget {
  final bool isDark;
  const _EmptyBookmarks({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_outline,
              size: 80,
              color: isDark ? Colors.white12 : Colors.black12),
          const SizedBox(height: 16),
          Text(
            'لا توجد محفوظات',
            style: TextStyle(
                fontSize: 18,
                color: isDark ? Colors.white30 : Colors.black26),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),
          Text(
            'اضغط مطولاً على أي آية لحفظها',
            style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white24 : Colors.black26),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}
