import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/quran_provider.dart';
import '../data/quran_data.dart';
import '../themes/app_theme.dart';
import 'surah_detail_screen.dart';

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuranProvider>();
    final isDark = provider.nightMode;
    final bg = isDark ? MushafColors.nightBg : MushafColors.parchment;
    final textColor = isDark ? MushafColors.nightText : MushafColors.inkDark;

    final surahs = QuranData.surahs.where((s) {
      if (_filter.isEmpty) return true;
      final q = _filter.toLowerCase();
      return s.name.contains(_filter) ||
          s.nameEnglish.toLowerCase().contains(q) ||
          s.nameMeaning.toLowerCase().contains(q) ||
          s.number.toString() == _filter;
    }).toList();

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor:
            isDark ? MushafColors.nightSurface : MushafColors.green,
        foregroundColor: Colors.white,
        title: Text('فهرس السور',
            style: GoogleFonts.amiri(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: TextField(
              style: TextStyle(color: textColor, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'ابحث عن سورة...',
                hintStyle:
                    const TextStyle(color: Colors.white54, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: Colors.white54, size: 20),
                suffixIcon: _filter.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear,
                            color: Colors.white54, size: 18),
                        onPressed: () => setState(() => _filter = ''),
                      )
                    : null,
                filled: true,
                fillColor: Colors.white12,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) => setState(() => _filter = v),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: surahs.length,
        itemBuilder: (context, index) {
          final surah = surahs[index];
          final isMeccan = surah.revelationType == 'Meccan';

          return InkWell(
            onTap: () {
              provider.navigateToSurah(surah.number);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      SurahDetailScreen(surahNumber: surah.number),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: isDark ? MushafColors.nightSurface : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark
                      ? MushafColors.nightBorder
                      : MushafColors.goldLight.withOpacity(0.4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    // Surah number badge
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: isDark
                              ? [
                                  MushafColors.gold.withOpacity(0.3),
                                  MushafColors.goldDark.withOpacity(0.2)
                                ]
                              : [MushafColors.gold, MushafColors.goldDark],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${surah.number}',
                          style: TextStyle(
                            color: isDark ? MushafColors.gold : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // English info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            surah.nameEnglish,
                            style: GoogleFonts.notoSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: isMeccan
                                      ? MushafColors.green.withOpacity(0.12)
                                      : MushafColors.gold.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  isMeccan ? 'Meccan' : 'Medinan',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isMeccan
                                        ? MushafColors.green
                                        : MushafColors.goldDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${surah.ayahCount} verses',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: textColor.withOpacity(0.5)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Arabic name
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          surah.name,
                          style: GoogleFonts.amiri(
                            fontSize: 20,
                            color: isDark
                                ? MushafColors.gold
                                : MushafColors.green,
                            fontWeight: FontWeight.bold,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        Text(
                          surah.nameMeaning,
                          style: TextStyle(
                            fontSize: 11,
                            color: textColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
