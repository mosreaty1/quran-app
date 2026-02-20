import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/quran_provider.dart';
import '../data/quran_data.dart';
import '../themes/app_theme.dart';
import 'surah_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuranProvider>();
    final isDark = provider.nightMode;
    final bg = isDark ? MushafColors.nightBg : MushafColors.parchment;
    final textColor = isDark ? MushafColors.nightText : MushafColors.inkDark;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor:
            isDark ? MushafColors.nightSurface : MushafColors.green,
        foregroundColor: Colors.white,
        title: Text(
          'بحث في القرآن',
          style: GoogleFonts.amiri(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: isDark ? MushafColors.nightSurface : MushafColors.green,
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: 'ابحث بالعربية أو الإنجليزية...',
                hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white54),
                        onPressed: () {
                          _controller.clear();
                          provider.search('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white12,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: provider.search,
            ),
          ),
          // Results header
          if (provider.searchQuery.isNotEmpty)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              alignment: Alignment.centerRight,
              child: Text(
                provider.searchResults.isEmpty
                    ? 'لا توجد نتائج'
                    : '${provider.searchResults.length} نتيجة',
                style: TextStyle(
                    fontSize: 13, color: textColor.withOpacity(0.6)),
                textDirection: TextDirection.rtl,
              ),
            ),
          // Results
          Expanded(
            child: provider.searchQuery.isEmpty
                ? _SearchHints(isDark: isDark)
                : provider.searchResults.isEmpty
                    ? _NoResults(isDark: isDark)
                    : ListView.builder(
                        itemCount: provider.searchResults.length,
                        itemBuilder: (context, i) {
                          final ayah = provider.searchResults[i];
                          final surah = QuranData.getSurahByNumber(
                              ayah.surahNumber);

                          return InkWell(
                            onTap: () {
                              provider.navigateToSurah(ayah.surahNumber);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SurahDetailScreen(
                                      surahNumber: ayah.surahNumber),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? MushafColors.nightSurface
                                    : Colors.white,
                                border: Border.all(
                                  color: isDark
                                      ? MushafColors.nightBorder
                                      : MushafColors.goldLight
                                          .withOpacity(0.3),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                children: [
                                  // Surah label
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: MushafColors.green
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'آية ${ayah.ayahNumber}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: isDark
                                                ? MushafColors.greenAccent
                                                : MushafColors.green,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${surah.name} (${surah.number})',
                                        style: GoogleFonts.amiri(
                                          fontSize: 14,
                                          color: isDark
                                              ? MushafColors.gold
                                              : MushafColors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Arabic text
                                  Text(
                                    ayah.text,
                                    style: GoogleFonts.amiri(
                                      fontSize: 20,
                                      color: textColor,
                                      height: 1.8,
                                    ),
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.right,
                                  ),
                                  // Translation if available
                                  if (ayah.translation.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      ayah.translation,
                                      style: GoogleFonts.notoSans(
                                        fontSize: 12,
                                        color: textColor.withOpacity(0.6),
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _SearchHints extends StatelessWidget {
  final bool isDark;
  const _SearchHints({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search,
              size: 72,
              color: isDark ? Colors.white12 : Colors.black12),
          const SizedBox(height: 16),
          Text(
            'ابحث في القرآن الكريم',
            style: TextStyle(
                fontSize: 18,
                color: isDark ? Colors.white30 : Colors.black26),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),
          Text(
            'يمكنك البحث بالعربية أو الإنجليزية',
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

class _NoResults extends StatelessWidget {
  final bool isDark;
  const _NoResults({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'لم يتم العثور على نتائج',
        style: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.white30 : Colors.black38),
        textDirection: TextDirection.rtl,
      ),
    );
  }
}
