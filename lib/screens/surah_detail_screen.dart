import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/quran_provider.dart';
import '../data/quran_data.dart';
import '../themes/app_theme.dart';

class SurahDetailScreen extends StatelessWidget {
  final int surahNumber;
  const SurahDetailScreen({super.key, required this.surahNumber});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuranProvider>();
    final isDark = provider.nightMode;
    final surah = QuranData.getSurahByNumber(surahNumber);
    final ayahs = provider.getAyahsForSurah(surahNumber);
    final bg = isDark ? MushafColors.nightBg : MushafColors.parchment;
    final textColor = isDark ? MushafColors.nightText : MushafColors.inkDark;

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          // ── Collapsing header ──────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor:
                isDark ? MushafColors.nightSurface : MushafColors.green,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [const Color(0xFF0D2A0D), const Color(0xFF1A3A1A)]
                        : [MushafColors.green, MushafColors.greenLight],
                  ),
                ),
                child: Stack(
                  children: [
                    // Subtle pattern
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _PatternPainter(),
                      ),
                    ),
                    // Content
                    SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          // Gold outer ring
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: MushafColors.gold, width: 2),
                              color: Colors.white.withOpacity(0.08),
                            ),
                            child: Center(
                              child: Text(
                                '${surahNumber}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            surah.name,
                            style: GoogleFonts.amiri(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          Text(
                            surah.nameEnglish,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 14),
                          ),
                          const SizedBox(height: 10),
                          // Info chips
                          Wrap(
                            spacing: 8,
                            children: [
                              _chip(surah.revelationType,
                                  Icons.location_on_outlined),
                              _chip('${surah.ayahCount} آية', Icons.format_list_numbered),
                              _chip('Page ${surah.startPage}', Icons.book_outlined),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isDark ? Icons.wb_sunny_outlined : Icons.nightlight_outlined,
                  color: Colors.white70,
                ),
                onPressed: provider.toggleNightMode,
              ),
            ],
          ),

          // ── Basmala ───────────────────────────────────────────────────────
          if (surahNumber != 9)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: isDark
                      ? MushafColors.nightSurface
                      : Colors.white,
                  border: Border.all(color: MushafColors.gold, width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ',
                  style: GoogleFonts.amiri(
                    fontSize: 26,
                    color: isDark ? MushafColors.gold : MushafColors.green,
                    fontWeight: FontWeight.bold,
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          // ── Verses ────────────────────────────────────────────────────────
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final ayah = ayahs[index];
                final bookmarked = provider.isBookmarked(
                    ayah.surahNumber, ayah.ayahNumber);

                return GestureDetector(
                  onLongPress: () {
                    HapticFeedback.mediumImpact();
                    if (bookmarked) {
                      provider.removeBookmark(
                          ayah.surahNumber, ayah.ayahNumber);
                    } else {
                      provider.addBookmark(
                          ayah.surahNumber, ayah.ayahNumber);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(bookmarked
                            ? 'تم إزالة العلامة'
                            : 'تم حفظ الآية'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 3),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: bookmarked
                          ? MushafColors.gold.withOpacity(0.1)
                          : (isDark
                              ? MushafColors.nightSurface
                              : Colors.white),
                      border: Border.all(
                        color: bookmarked
                            ? MushafColors.gold
                            : (isDark
                                ? MushafColors.nightBorder
                                : MushafColors.goldLight.withOpacity(0.3)),
                        width: bookmarked ? 1.5 : 0.8,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Arabic text
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                text: '${ayah.text} ',
                                style: GoogleFonts.amiri(
                                  fontSize: provider.fontSize,
                                  color: textColor,
                                  height: 2.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: MushafColors.gold,
                                        width: 1.5),
                                    color: MushafColors.gold.withOpacity(0.1),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${ayah.ayahNumber}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: MushafColors.gold,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        // Translation
                        if (provider.showTranslation &&
                            ayah.translation.isNotEmpty) ...[
                          const Divider(height: 12, thickness: 0.5),
                          Text(
                            '${ayah.ayahNumber}. ${ayah.translation}',
                            style: GoogleFonts.notoSans(
                              fontSize: provider.fontSize * 0.48,
                              color: textColor.withOpacity(0.65),
                              height: 1.5,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                        // Actions row
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Clipboard.setData(
                                    ClipboardData(text: ayah.text));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('تم نسخ الآية'),
                                      duration: Duration(seconds: 1)),
                                );
                              },
                              child: Icon(Icons.copy_outlined,
                                  size: 16,
                                  color: textColor.withOpacity(0.4)),
                            ),
                            const SizedBox(width: 12),
                            InkWell(
                              onTap: () {
                                if (bookmarked) {
                                  provider.removeBookmark(
                                      ayah.surahNumber, ayah.ayahNumber);
                                } else {
                                  provider.addBookmark(
                                      ayah.surahNumber, ayah.ayahNumber);
                                }
                              },
                              child: Icon(
                                bookmarked
                                    ? Icons.bookmark
                                    : Icons.bookmark_outline,
                                size: 16,
                                color: bookmarked
                                    ? MushafColors.gold
                                    : textColor.withOpacity(0.4),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: ayahs.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _chip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 12),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    for (double x = 0; x < size.width; x += 40) {
      for (double y = 0; y < size.height; y += 40) {
        canvas.drawCircle(Offset(x, y), 14, p);
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
