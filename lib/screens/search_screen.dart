import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quran_provider.dart';
import '../models/ayah.dart';
import '../data/quran_data.dart';
import 'surah_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuranProvider>();
    final isDark = provider.nightMode;
    final accentColor = isDark ? const Color(0xFF4CAF50) : const Color(0xFF1B5E20);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF2D2D2D) : accentColor,
        foregroundColor: Colors.white,
        title: const Text(
          'Search',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBar(
              controller: _controller,
              hintText: 'Search in English or Arabic...',
              leading: Icon(Icons.search, color: accentColor),
              trailing: _controller.text.isNotEmpty
                  ? [
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          provider.search('');
                        },
                      ),
                    ]
                  : null,
              onChanged: (value) {
                provider.search(value);
                setState(() {});
              },
            ),
          ),
          if (provider.searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    '${provider.searchResults.length} results',
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: provider.searchQuery.isEmpty
                ? _SearchHints(isDark: isDark)
                : provider.searchResults.isEmpty
                    ? _NoResults(query: provider.searchQuery, isDark: isDark)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: provider.searchResults.length,
                        itemBuilder: (context, index) {
                          final ayah = provider.searchResults[index];
                          return _SearchResultTile(
                            ayah: ayah,
                            query: provider.searchQuery,
                            isDark: isDark,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final Ayah ayah;
  final String query;
  final bool isDark;

  const _SearchResultTile({
    required this.ayah,
    required this.query,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final surah = QuranData.getSurahByNumber(ayah.surahNumber);
    final accentColor = isDark ? const Color(0xFF4CAF50) : const Color(0xFF1B5E20);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SurahDetailScreen(surahNumber: ayah.surahNumber),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${surah.nameEnglish} ${ayah.surahNumber}:${ayah.ayahNumber}',
                      style: TextStyle(
                        fontSize: 12,
                        color: accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    surah.name,
                    style: TextStyle(
                      fontSize: 16,
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                ayah.text,
                style: const TextStyle(
                  fontSize: 20,
                  height: 1.8,
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 6),
              Text(
                ayah.translation,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white70 : Colors.black87,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
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
          Icon(Icons.search, size: 80,
              color: isDark ? Colors.white30 : Colors.black26),
          const SizedBox(height: 16),
          Text(
            'Search the Quran',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Search in English translation or Arabic text',
            style: TextStyle(
              color: isDark ? Colors.white38 : Colors.black38,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  final String query;
  final bool isDark;

  const _NoResults({required this.query, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64,
              color: isDark ? Colors.white30 : Colors.black26),
          const SizedBox(height: 16),
          Text(
            'No results for "$query"',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
