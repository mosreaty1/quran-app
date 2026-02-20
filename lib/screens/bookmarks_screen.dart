import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quran_provider.dart';
import '../models/bookmark.dart';
import 'surah_detail_screen.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuranProvider>();
    final bookmarks = provider.bookmarks;
    final isDark = provider.nightMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF2D2D2D) : const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        title: const Text(
          'Bookmarks',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: bookmarks.isNotEmpty
            ? [
                IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined),
                  tooltip: 'Clear all bookmarks',
                  onPressed: () => _confirmClearAll(context, provider),
                ),
              ]
            : null,
      ),
      body: bookmarks.isEmpty
          ? _EmptyBookmarks(isDark: isDark)
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final bookmark = bookmarks[index];
                return _BookmarkTile(
                  bookmark: bookmark,
                  isDark: isDark,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SurahDetailScreen(
                          surahNumber: bookmark.surahNumber,
                        ),
                      ),
                    );
                  },
                  onDelete: () {
                    provider.removeBookmark(
                        bookmark.surahNumber, bookmark.ayahNumber);
                  },
                );
              },
            ),
    );
  }

  void _confirmClearAll(BuildContext context, QuranProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear All Bookmarks?'),
        content: const Text('This will remove all saved bookmarks.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              for (final b in List.from(provider.bookmarks)) {
                provider.removeBookmark(b.surahNumber, b.ayahNumber);
              }
              Navigator.pop(context);
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _BookmarkTile extends StatelessWidget {
  final Bookmark bookmark;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _BookmarkTile({
    required this.bookmark,
    required this.isDark,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = isDark ? const Color(0xFF4CAF50) : const Color(0xFF1B5E20);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: accentColor,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(Icons.bookmark, color: Colors.white, size: 22),
          ),
        ),
        title: Text(
          bookmark.surahName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          textDirection: TextDirection.rtl,
        ),
        subtitle: Text(
          'Surah ${bookmark.surahNumber} • Ayah ${bookmark.ayahNumber}',
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white54 : Colors.black54,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: onDelete,
        ),
        onTap: onTap,
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
          Icon(
            Icons.bookmark_outline,
            size: 80,
            color: isDark ? Colors.white30 : Colors.black26,
          ),
          const SizedBox(height: 16),
          Text(
            'No Bookmarks Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Long-press any ayah to bookmark it.',
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
